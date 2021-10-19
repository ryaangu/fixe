module fixe.object;

public import fixe.ir;
public import fixe.dump;
       import fixe.x64;
       import fixe.optimizer;

struct FXObject
{
    FXInstruction[] instructions;

    private FXOptimizer optimizer;
    
    void frame()
    {
        FXInstruction instruction;

        instruction.type  = fx_op_frame;
        instructions     ~= instruction;
    }

    void frame_end()
    {
        FXInstruction instruction;

        instruction.type  = fx_op_frame_end;
        instructions     ~= instruction;
    }

    void syscall(T...)(T params)
    {
        FXInstruction instruction;
        instruction.type = fx_op_syscall;
        
        foreach (param; params)
            instruction.params ~= param;

        instructions ~= instruction;
    }

    void compile()
    {
        optimizer.start(&this);
    }
}