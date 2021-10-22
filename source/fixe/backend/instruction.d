module fixe.backend.instruction;

import fixe.backend.value;

enum FXInstructionType
{
    label,

    copy,
    ret,

    syscall,
}

__gshared string[4] fxInstructionNames = 
[
    "label",

    "copy",
    "ret",
    
    "syscall",
];

struct FXInstruction
{
    FXValue[] params;
    uint type;
}