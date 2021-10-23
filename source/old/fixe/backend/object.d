module old.fixe.backend.object;

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

    private FXLabel *currentLabel;

    private FXInstruction* makeInstruction(uint type)
    {
        FXInstruction instruction;
        instruction.instructionType = type;

        instructions ~= instruction;
        return &instructions[$ - 1];
    }

    FXLabel *findLabel(string name)
    {
        foreach (ref FXLabel label; labels)
        {
            if (label.name == name)
                return &label;
        }

        return null;
    }

    /// label:
    void label(string name)
    {
        bool isGlobal = name[0] != '.';

        if (!isGlobal)
            name = currentLabel.name ~ "_" ~ name[1 .. name.length];
        else
        {
            labels ~= FXLabel(name, instructions.length);
            currentLabel = &labels[$ - 1];
        }
        
        FXInstruction *instruction = makeInstruction(FXInstructionType.label);
        instruction.params ~= fxLabel(name);
    }

    /// param type register

    /// copy destination, source
    void copy(T...)(T params)
    {
        static if (params.length == 2)
        {
            FXInstruction *instruction = makeInstruction(FXInstructionType.copy);

            instruction.params ~= params[0];
            instruction.params ~= params[1];
        }
    }

    /// ret source
    void ret(T...)(T params)
    {
        static if (params.length == 1)
        {
            FXInstruction *instruction = makeInstruction(FXInstructionType.ret);
            instruction.params ~= params[0];
        }
    }

    /// syscall destination, source...
    void syscall(T...)(T params)
    {
        FXInstruction *instruction = makeInstruction(FXInstructionType.syscall);
        
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