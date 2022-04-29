module tests.main;

import fixe.object;
import std.stdio;

void main()
{
    // Create an object
    FXObject object;

    // Write a simple program returning 0
    FXType i32 = FXType(FXTypeKind.Integer, 32);

    object.assign(FXRegister(0), i32, FXConstant(0));
    object.assign(FXRegister(1), i32, FXConstant(2));
    object.assign(FXRegister(2), i32, FXRegister(1));
    object.ret(i32, FXRegister(0));

    // Dump the non-optimized program IR
    writeln("IR:");
    object.dump();
    writeln();

    // Generate x86_64 text format from IR
    FXTarget target = FXTarget(FXTargetKind.x86_64_text);
    FXOutput output = target.compile(object);

    // Dump the optimized program IR
    writeln("Optimized IR:");
    object.dump();
    writeln();

    // Write x86_64 output
    writeln("x86_64:");
    write(output.as_string);
}