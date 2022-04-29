module fixe.object;

public import fixe.internal.ir;
public import fixe.target;

import std.stdio;
import std.conv;
import std.uni;

/// A structure that represents an object.
struct FXObject
{
    FXInstruction[] instructions;

    /// Assign a constant to a register
    void assign(FXRegister register, FXType type, FXConstant constant)
    {
        instructions ~= FXInstruction(FXInstructionKind.Assign, type,
        [
            FXConstant(register),
            constant,
        ]);
    }

    /// Assign a register to a register
    void assign(FXRegister register, FXType type, FXRegister other)
    {
        instructions ~= FXInstruction(FXInstructionKind.Assign, type,
        [
            FXConstant(register),
            FXConstant(other),
        ]);
    }

    /// Returns a register
    void ret(FXType type, FXRegister register)
    {
        instructions ~= FXInstruction(FXInstructionKind.Return, type,
        [
            FXConstant(register),
        ]);
    }

    /// Returns a constant
    void ret(FXType type, FXConstant constant)
    {
        instructions ~= FXInstruction(FXInstructionKind.Return, type,
        [
            constant,
        ]);
    }

    /// Dumps constant to stdout
    void dump(ref FXConstant constant)
    {
        final switch (constant.kind)
        {
            // %<register index>
            case FXConstantKind.Register:
            {
                write("%", constant.as_register.index);
                break;
            }

            // <number>
            case FXConstantKind.Number:
            {
                write(constant.as_number);
                break;
            }
        }
    }

    /// Dumps instruction to stdout
    void dump(ref FXInstruction instruction)
    {
        final switch (instruction.kind)
        {
            // Do nothing.
            case FXInstructionKind.Nop:
                break;

            // <register> = <constant>
            case FXInstructionKind.Assign:
            {
                dump(instruction.parameters[0]);
                write(" = ");
                write((instruction.type.kind == FXTypeKind.Integer) ? "i"
                                                                    : "f",
                       instruction.type.size,
                       " ");
                dump(instruction.parameters[1]);
                writeln();
                break;
            }

            // return <constant>
            case FXInstructionKind.Return:
            {
                write("return ");
                write((instruction.type.kind == FXTypeKind.Integer) ? "i"
                                                                    : "f",
                       instruction.type.size,
                       " ");
                dump(instruction.parameters[0]);
                writeln();
                break;
            }
        }
    }

    /// Dumps IR to stdout
    void dump()
    {
        foreach (ref FXInstruction instruction; instructions)
            dump(instruction);
    }
}