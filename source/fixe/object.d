module fixe.object;

import fixe.instruction;
import fixe.value;
import fixe.dump;

struct FXObject
{
    FXInstruction[] instructions;

    void syscall(T...)(T params)
    {
        FXInstruction instruction;
        instruction.type = FXInstructionType.syscall;
        
        foreach (ref FXValue param; params)
            instruction.params ~= param;

        instructions ~= instruction;
    }

    void compile()
    {

    }

    void dump()
    {
        dumpObject(this);
    }
}