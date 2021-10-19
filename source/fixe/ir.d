module fixe.ir;

public import fixe.value;

enum
{
    fx_op_frame,
    fx_op_frame_end,
    fx_op_syscall,
}

string[] fx_op_names = 
[
    "frame",
    "frame_end",
    "syscall",
];

struct FXInstruction
{
    uint      type;
    FXValue[] params;
}