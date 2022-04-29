module fixe.targets.x86_64_text;

import fixe.object;
import std.conv;

/// Compiles object to text format x86_64
string compile_to_x86_64_text(ref FXObject object, ref FXTarget target)
{
    // All the general purpose registers
    string[] register_names =
    [
        "rax",
        "rbx",
        "rcx",
        "rdx",
    ];

    // The output
    string output = "";

    foreach (ref FXInstruction instruction; object.instructions)
    {
        final switch (instruction.kind)
        {
            // Do nothing.
            case FXInstructionKind.Nop:
                break;

            // <register> = <constant>
            case FXInstructionKind.Assign:
            {
                // Get destination
                FXLiveRange *range = &target.ranges[instruction.parameters[0].as_register.index];
                string destination = register_names[range.result.value];

                // Emit value
                if (instruction.parameters[1].kind == FXConstantKind.Number)
                {
                    double value = instruction.parameters[1].as_number;

                    if (value == 0)
                    {
                        // Emit xor
                        output ~= "xor ";
                        output ~= destination;
                        output ~= ", ";
                        output ~= destination;
                        output ~= '\n';
                    }
                    else
                    {
                        // Emit mov
                        output ~= "mov ";
                        output ~= destination;
                        output ~= ", ";
                        output ~= to!(string)(value);
                        output ~= '\n';
                    }
                }
                else
                {
                    FXLiveRange *source = &target.ranges[instruction.parameters[1].as_register.index];
                    
                    // Emit mov
                    output ~= "mov ";
                    output ~= destination;
                    output ~= ", ";
                    output ~= register_names[source.result.value];
                    output ~= '\n';
                }
                break;
            }

            // return <constant>
            case FXInstructionKind.Return:
            {
                // Get source
                FXLiveRange *range = &target.ranges[instruction.parameters[0].as_register.index];
                
                // Check for register
                if (range.result.value == 0) // eax?
                {
                    // Only emit ret
                    output ~= "ret\n";
                }
                else
                {
                    // Emit mov
                    output ~= "mov ";
                    output ~= register_names[0];
                    output ~= ", ";
                    output ~= register_names[range.result.value];

                    // Emit ret
                    output ~= "\nret\n";
                }
                break;
            }
        }
    }

    return output;
}