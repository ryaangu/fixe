module fixe.target;

import fixe.targets.x86_64_text;
import fixe.targets.x86_64;

import fixe.object;
import std.stdio;

/// The kind of a target.
enum FXTargetKind
{
    /// x86_64 text format
    x86_64_text,
}

/// A structure that represents an output.
struct FXOutput
{
    union
    {
        string as_string;
    }

    FXTargetKind target_kind;

    /// Constructs string output
    this(FXTargetKind target, string output)
    {
        target_kind = target;
        as_string   = output;
    }
}

/// A structure that represents a target.
struct FXTarget
{
    FXTargetKind kind;
    FXLiveRange[uint] ranges;

    bool changed = false;

    /// Do liveness analysis on IR
    void liveness_analysis(ref FXObject object)
    {
        foreach (uint index, ref FXInstruction instruction; object.instructions)
        {
            final switch (instruction.kind)
            {
                // Do nothing.
                case FXInstructionKind.Nop:
                    break;

                case FXInstructionKind.Assign:
                {
                    // Get register index
                    uint register = instruction.parameters[0].as_register.index;

                    // First add a live range if not found
                    if ((register in ranges) == null)
                        ranges[register] = FXLiveRange(register, index);

                    // Update live range to
                    FXLiveRange *range = &ranges[register];
                    range.to = index;

                    // Check for source register
                    if (instruction.parameters[1].kind == FXConstantKind.Register)
                    {
                        // Get source register index
                        uint source_register = instruction.parameters[1].as_register.index;

                        // Update source live range to
                        FXLiveRange *source_range = &ranges[source_register];
                        source_range.to = index;
                    }
                    break;
                }

                case FXInstructionKind.Return:
                {
                    // Get register index
                    uint register = instruction.parameters[0].as_register.index;

                    // Update live range to
                    FXLiveRange *range = &ranges[register];
                    range.to = index;
                    break;
                }
            }
        }

        // A little optimization to remove "dead code"
        version (canOptimize)
        {
            foreach (ref FXLiveRange range; ranges)
            {
                if (range.from == range.to)
                {
                    object.instructions[range.from].kind = FXInstructionKind.Nop;
                    ranges.remove(range.register);

                    changed = true;
                }
            }

            // Do liveness analysis again if IR was changed
            if (changed)
            {
                changed = false;
                liveness_analysis(object);
            }
        }
    }

    /// Do linear register allocation 
    void linear_register_allocation()
    {
        final switch (kind)
        {
            case FXTargetKind.x86_64_text:
            {
                linear_register_allocation_x86_64(this);
                break;
            }
        }
    }
    
    /// Compile object to target
    FXOutput compile(ref FXObject object)
    {
        // Do liveness analysis on IR
        liveness_analysis(object);

        // Do linear register allocation on live ranges
        linear_register_allocation();

        // Compile
        final switch (kind)
        {
            case FXTargetKind.x86_64_text:
                return FXOutput(kind, compile_to_x86_64_text(object, this));
        }
    }
}