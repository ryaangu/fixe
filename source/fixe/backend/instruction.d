module fixe.backend.instruction;

import fixe.backend.value;

enum FXInstructionType
{
    copy,
    ret,

    syscall,
}

__gshared string[] fxInstructionNames = 
[
    "copy",
    "ret",
    
    "syscall",
];

struct FXInstruction
{
    FXValue[] params;
    uint type;
}