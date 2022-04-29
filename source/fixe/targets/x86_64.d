module fixe.targets.x86_64;

import std.algorithm.sorting;
import std.algorithm;
import std.stdio;

import fixe.object;

/// The kind of a x86_64 register.
enum FXRegister8664Kind
{
    RAX,
    RBX,
    RCX,
    RDX,
}

/// A structure that represents a x86_64 register
struct FXRegister8664
{
    FXRegister8664Kind kind;
    uint index;
    bool used;
}

/// Find available x86_64 register
FXRegister8664 *find_available_x86_64_register(ref FXRegister8664[] registers)
{
    foreach (ref FXRegister8664 register; registers)
    {
        if (!register.used)
        {
            register.used = true;
            return &register;
        }
    }

    return null;
}

/// Does register allocation for x86_64
void linear_register_allocation_x86_64(ref FXTarget target)
{
    // All the general purpose registers
    FXRegister8664[] registers =
    [
        FXRegister8664(FXRegister8664Kind.RAX, 0, false),
        FXRegister8664(FXRegister8664Kind.RBX, 1, false),
        FXRegister8664(FXRegister8664Kind.RCX, 2, false),
        FXRegister8664(FXRegister8664Kind.RDX, 3, false),
    ];

    // Current stack address
    int stack_address = 0;

    // Make a list of sorted ranges in order of increasing from
    FXLiveRange[] sorted_ranges;

    foreach (ref FXLiveRange range; target.ranges)
        sorted_ranges ~= range;

    sorted_ranges.sort!((a, b) => a.from < b.from)();

    // Do linear scan
    FXLiveRange[] active;

    foreach (ref FXLiveRange range; sorted_ranges)
    {
        // Expire old ranges
        foreach (uint index, ref FXLiveRange active_range; active)
        {
            if (active_range.to >= active_range.from)
                break;

            active.remove(index);

            // Set register used to false
            uint register = target.ranges[active_range.register].result.value;
            registers[register].used = false;
        }

        // Spill live range
        if (active.length == registers.length)
        {
            FXLiveRange *spill = &active[$ - 1];

            if (spill.to > range.to)
            {
                target.ranges[range.register].result.kind  = FXResultKind.Register;
                target.ranges[range.register].result.value = spill.result.value;

                target.ranges[spill.register].result.kind  = FXResultKind.Stack;
                target.ranges[spill.register].result.value = (stack_address -= 4);

                active.remove((cast(int)active.length) - 1);
                active ~= range;

                active.sort!((a, b) => a.to < b.to)();
            }
            else
            {
                target.ranges[range.register].result.kind  = FXResultKind.Stack;
                target.ranges[range.register].result.value = (stack_address -= 4);
            }
        }

        // Allocate register
        else
        {
            target.ranges[range.register].result.kind  = FXResultKind.Register;
            target.ranges[range.register].result.value = find_available_x86_64_register(registers).index;

            active ~= range;
            active.sort!((a, b) => a.to < b.to)();
        }
    }
}