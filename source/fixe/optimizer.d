module fixe.optimizer;

import fixe.object;
import fixe.x64;

import std.stdio;

private struct Block
{
    ulong start;
    ulong end;

    LiveRange[ulong] ranges;
}

private struct LiveRange
{
    ulong start;
    ulong end;
    ulong register;
    
    long target_register;
    long target_location;
}

private struct Register
{
    ulong value;
    bool  used;
}

struct FXOptimizer
{
    private Block   []  blocks;
    private FXObject   *object;

    private ulong   stack_address;
    private long [] active;

    private X64Assembler x64_assembler;

    private Register[] x64_registers =
    [
        Register(0, false),
        Register(1, false),
        Register(2, false),
        Register(3, false),
        Register(4, false),
    ];

    void start(FXObject *_object)
    {
        object = _object;

        find_blocks();
        compute_ranges();
        allocate_x64_registers();
        convert_to_x64();
    }

    private void find_blocks()
    {
        Block block;
        block.start = -1;

        foreach (i, instruction; object.instructions)
        {
            if (instruction.type == fx_op_frame)
                block.start = i;
            else if (instruction.type == fx_op_frame_end && block.start != -1)
            {
                block.end = i;

                if (block.start != block.end)
                    blocks ~= block;

                block.start = -1;
            }
        }
    }

    private void compute_ranges()
    {
        foreach (index, ref block; blocks)
        {
            for (ulong i = block.start; i < block.end; ++i)
            {
                FXInstruction *instruction = &object.instructions[i];

                foreach (param; instruction.params)
                {
                    if (param.type == fx_value_register)
                    {
                        if (!(param.as_register in block.ranges))
                            block.ranges[param.as_register] = LiveRange(i, i, param.as_register, 0, 0);
                        else
                            block.ranges[param.as_register].end = i;
                    }
                }
            }
        }
    }

    private Register *get_x64_available_register()
    {
        foreach (i, ref register; x64_registers)
        {
            if (!register.used)
            {
                register.used = true;
                return &register;
            }
        }

        return null;
    }

    private void free_x64_register(ulong value)
    {
        foreach (i, ref register; x64_registers)
        {
            if (register.value == value)
            {
                register.used = false;
                return;
            }
        }
    }

    private LiveRange *find_range(ulong register, ref LiveRange[ulong] ranges)
    {
        foreach (ref range; ranges)
        {
            if (range.register == register)
                return &range;
        }

        return null;
    }

    private void allocate_x64_registers()
    {
        foreach (block; blocks)
        {
            foreach (i, ref range; block.ranges)
            {
                expire_old_ranges(range, block.ranges);

                Register *register = get_x64_available_register();

                if (register == null)
                    spill_at_range(range, i, block.ranges);
                else 
                {
                    range.target_register  = register.value;
                    active                ~= i;
                }
            }


            writeln(block.ranges);
        }
    }

    private void expire_old_ranges(ref LiveRange range, ref LiveRange[ulong] ranges)
    {
        foreach(i, range_id; active)
        {
            if (range_id == -1)
                continue;

            LiveRange *other_range = &ranges[range_id];

            if (other_range.end > range.start)
                return;

            active[i] = -1;
            free_x64_register(other_range.register);
        }
    }

    private void spill_at_range(ref LiveRange range, ulong i, ref LiveRange[ulong] ranges)
    {
        long index = ((active.length > 0) ? active[$ - 1] : -1);

        if (index != -1)
        {
            LiveRange *other_range = &ranges[index];

            if (other_range.end > range.end)
            {
                range.register              = other_range.register;
                other_range.target_register = -1;
                other_range.target_location = (stack_address -= 8);

                active[$ - 1]  = -1;
                active        ~= i;

                return;
            }
        }

        range.target_register = -1;
        range.target_location = (stack_address -= 8);
    }

    private void convert_to_x64()
    {
        foreach (block; blocks)
        {
            for (ulong i = block.start; i < block.end; ++i)
            {
                FXInstruction *instruction = &object.instructions[i];

                switch (instruction.type)
                {
                    case fx_op_syscall:
                    {
                        const(X64Register) *args[] = [&g_rax, &g_rdi];

                        for (ulong j = 1; j < instruction.params.length; ++j)
                            x64_assembler.mov(*args[j - 1], instruction.params[j].as_i32);

                        x64_assembler.syscall();
                        break;
                    }

                    default:
                        break;
                }
            }
        }

        writeln("\nFIXE output (x86_64):");

        foreach (b; x64_assembler.code)
            printf("%02X ", b);

        writeln();
    }
}