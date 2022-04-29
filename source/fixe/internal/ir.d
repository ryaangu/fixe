module fixe.internal.ir;

/// A structure that represents a register.
struct FXRegister
{
    uint index;
}

/// The kind of a constant.
enum FXConstantKind
{
    Register,
    Number,
}

/// The kind of a type.
enum FXTypeKind 
{
    Integer,
}

/// The type of an instruction or constant.
struct FXType
{
    FXTypeKind kind;
    uint size;
}

/// A structure that represents a constant.
struct FXConstant
{
    union
    {
        FXRegister as_register;
        double as_number;
    }

    FXConstantKind kind;
    FXType type;

    // Constructs a register constant
    this(FXRegister register)
    {
        as_register = register;
        kind        = FXConstantKind.Register;
    }

    // Constructs a number constant
    this(double number)
    {
        as_number = number;
        kind      = FXConstantKind.Number;
        type      = FXType(FXTypeKind.Integer, 32);
    }
}

/// The kind of an instruction.
enum FXInstructionKind
{
    Nop,
    Assign,
    Return,
}

/// A structure that represents an instruction.
struct FXInstruction
{
    FXInstructionKind kind;
    FXType type;
    FXConstant[] parameters;
}

/// The kind of a result.
enum FXResultKind
{
    Register,
    Stack,
}

/// A structure that represents a register allocation result
struct FXResult
{
    FXResultKind kind;
    uint value;
}

/// A structure that represents a live range.
struct FXLiveRange
{
    uint register;
    uint from;
    uint to;
    FXResult result;
}