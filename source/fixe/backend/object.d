module fixe.backend.object;

import fixe.backend.instruction;
import fixe.backend.value;
import fixe.backend.dump;
import fixe.backend.target;
import fixe.backend.c;

import std.stdio;

struct FXLabel
{
    string name;
    ulong address;
}

struct FXObject
{
    FXInstruction[] instructions;
    FXLabel[] labels;

    private FXInstruction* make_instruction(uint type)
    {
        FXInstruction instruction;
        instruction.type = type;

        instructions ~= instruction;
        return &instructions[$ - 1];
    }

    /// label name:
    void label(string name)
    {
        FXInstruction *instruction = make_instruction(FXInstructionType.label);
        instruction.params ~= fxLabel(name);

        labels ~= FXLabel(name, instructions.length);
    }

    /// copy destination, source
    void copy(T...)(T params)
    {
        static if (params.length == 2)
        {
            FXInstruction *instruction = make_instruction(FXInstructionType.copy);

            instruction.params ~= params[0];
            instruction.params ~= params[1];
        }
    }

    /// ret source
    void ret(T...)(T params)
    {
        static if (params.length == 1)
        {
            FXInstruction *instruction = make_instruction(FXInstructionType.ret);
            instruction.params ~= params[0];
        }
    }

    /// syscall destination, source...
    void syscall(T...)(T params)
    {
        FXInstruction *instruction = make_instruction(FXInstructionType.syscall);
        
        foreach (ref FXValue param; params)
            instruction.params ~= param;
    }

    /// Compile the IR into target machine code
    void compile(FXTarget target, string path)
    {
        switch (target.backend)
        {
            case FXBackendType.c:
            {
                convertIRToC(path, this);
                break;
            }

            default:
                break;
        }
    }

    /// Dump the IR to the console
    void dump()
    {
        dumpObject(this);
    }
}