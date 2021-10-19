module fixe.dump;

import fixe.object;
import std.stdio;

private void dump(ref FXValue param)
{
    write(fx_value_names[param.type], " ");

    switch (param.type)
    {
        case fx_value_i32:
        {
            write(param.as_i32);
            break;
        }

        case fx_value_register:
        {
            write(param.as_register);
            break;
        }

        default:
            break;
    }

    write(" ");
}

private void dump(ref FXInstruction instruction)
{
    write(fx_op_names[instruction.type], " ");

    foreach (param; instruction.params)
        dump(param);
}

void dump(ref FXObject object)
{
    writeln("FIXE input:");

    foreach (instruction; object.instructions)
    {
        write("    ");
        dump(instruction);
        writeln();
    }
}