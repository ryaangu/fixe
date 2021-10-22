module fixe.backend.instruction;

import fixe.backend.value;

enum FXInstructionType
{
    copy,
    ret,

    syscall,
}

__gshared string[3] fxInstructionNames = 
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