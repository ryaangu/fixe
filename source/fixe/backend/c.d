module fixe.backend.c;

import fixe.backend.instruction;
import fixe.backend.value;

import std.stdio;
import std.conv;
import std.file;

private string output;

private void writeOutput(T ...)(T contents)
{
    foreach (ref string content; contents)
        output ~= content;
}

private void writeInclude(string path, bool quotes = false)
{
    if (quotes)
        writeOutput("#include \"", path, "\"\n");
    else
        writeOutput("#include <", path, ">\n");
}

private void writeGuardStart(string name)
{
    writeOutput("#ifndef ", name, "_H\n");
    writeOutput("#define ", name, "_H\n");
}

private void writeGuardEnd()
{
    writeOutput("#endif");
}

private void writeComment(string comment)
{
    writeOutput("// ", comment, "\n");
}

private void writeComments(T...)(T comments)
{
    writeOutput("/*\n");

    foreach (ref string comment; comments)
        writeOutput("\t", comment, "\n");

    writeOutput("*/\n");
}

private void writeLine()
{
    writeOutput("\n");
}

private void writeParam(ref FXValue param)
{
    if (param.type == FXType.register)
        writeOutput("_r", to!(string)(param.value));
    else
        writeOutput(to!(string)(param.value));
}

private void writeReturnStatement(ref FXInstruction instruction)
{
    writeOutput("\t");

    if (instruction.params[0].type == FXType.void_)
        writeOutput("return;\n");
    else 
    {
        writeOutput("return ");
        writeParam(instruction.params[0]);
        writeOutput(";\n");
    }
}

void convertIRToC(string path, ref FXInstruction[] instructions)
{
    writeGuardStart("FIXE_OUTPUT");
    writeLine();

    writeComments("This is going to be removed when", "we make our C runtime.");
    writeInclude("stdio.h");
    writeInclude("stdlib.h");
    writeLine();

    foreach (ref FXInstruction instruction; instructions)
    {
        switch (instruction.type)
        {
            case FXInstructionType.ret:
            {
                writeReturnStatement(instruction);
                break;
            }

            default:
                break;
        }
    }

    writeLine();
    writeGuardEnd();

    File file = File(path, "w");
    file.write(output);
    file.close();
}