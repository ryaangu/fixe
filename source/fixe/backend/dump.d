module fixe.backend.dump;

import fixe.backend.object;
import fixe.backend.instruction;
import fixe.backend.value;

import std.stdio;

private void dumpInstruction(ref FXInstruction instruction)
{
    write("    ", fxInstructionNames[instruction.type], " ");

    foreach (ulong i, ref FXValue param; instruction.params)
    {
        if (param.type == FXType.register)
            write("r");
        else
            write(fxTypeNames[param.type], " ");

        if (param.type != FXType.void_)
            write(param.value);

        if (i != cast(ulong)instruction.params.length - 1)
            write(", ");
    }

    writeln();
}

void dumpObject(ref FXObject object)
{
    foreach (ref FXInstruction instruction; object.instructions)
        dumpInstruction(instruction);
}