module fixe.instruction;

import fixe.value;

enum FXInstructionType
{
    syscall,
}

__gshared string[] fxInstructionNames = 
[
    "syscall",
];

struct FXInstruction
{
    FXValue[] params;
    uint type;
}