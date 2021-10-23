module old.fixe.backend.instruction;

import fixe.backend.value;

enum FXInstructionType
{
    label,
    param,

    copy,
    ret,

    syscall,
}

__gshared string[4] fxInstructionNames = 
[
    "label",
    "param",

    "copy",
    "ret",
    
    "syscall",
];

struct FXInstruction
{
    FXValue[] params;
    uint      instructionType;
    uint      type;
}