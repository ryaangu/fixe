module fixe.dump;

import fixe.object;
import fixe.instruction;
import fixe.value;

import std.stdio;

private void dumpInstruction(ref FXInstruction instruction)
{
    write("    ", fxInstructionNames[instruction.type], " ");

    foreach (ref FXValue param; instruction.params)
        write(fxTypeNames[param.type], " ", param.value, " ");

    writeln();
}

void dumpObject(ref FXObject object)
{
    foreach (ref FXInstruction instruction; object.instructions)
        dumpInstruction(instruction);
}