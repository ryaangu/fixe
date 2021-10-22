module fixe.backend.c;

import fixe.backend.instruction;
import fixe.backend.value;
import fixe.backend.object;

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

private void writeFunctionDeclaration(ref FXInstruction instruction)
{
    if (instruction.params[0].label != "main")
        writeOutput("void _", instruction.params[0].label, "()\n{\n");
    else
        writeOutput("void main()\n{\n");
}

private void writeLabel(ref FXInstruction instruction)
{
    writeOutput("_l", instruction.params[0].label, ":\n");
}

void convertIRToC(string path, ref FXObject object)
{
    writeGuardStart("FIXE_OUTPUT");
    writeLine();

    writeComments("This is going to be removed when", "we make our C runtime.");
    writeInclude("stdio.h");
    writeInclude("stdlib.h");
    writeLine();

    bool hadLabel = false;

    if (object.labels.length == 0)
    {
        hadLabel = true;
        writeOutput("void main()\n{\n");
    }

    foreach (ref FXInstruction instruction; object.instructions)
    {
        switch (instruction.type)
        {
            case FXInstructionType.label:
            {
                if (object.findLabel(instruction.params[0].label) == null)
                    writeLabel(instruction);
                else
                {
                    if (hadLabel)
                        writeOutput("}\n\n");

                    hadLabel = true;
                    writeFunctionDeclaration(instruction);
                }
                break;
            }
            
            case FXInstructionType.ret:
            {
                writeReturnStatement(instruction);
                break;
            }

            default:
                break;
        }
    }

    if (hadLabel)
        writeOutput("}\n");

    writeLine();
    writeGuardEnd();

    File file = File(path, "w");
    file.write(output);
    file.close();
}