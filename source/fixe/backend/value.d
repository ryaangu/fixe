module fixe.backend.value;

enum FXType
{
    void_,
    bool_,

    int8,
    int16,
    int32,
    int64,

    float32,
    float64,

    pointer,
    register,
}

__gshared string[] fxTypeNames = 
[
    "void",
    "bool",

    "i8",
    "i16",
    "i32",
    "i64",

    "f32",
    "f64",

    "ptr",
    "reg",
];

struct FXValue
{
    double value;
    uint type;
}

/// void
FXValue fxVoid()
{
    return FXValue(0, FXType.void_);
}

/// bool
FXValue fxBool(bool value)
{
    return FXValue(cast(double)value, FXType.bool_);
}

/// i8
FXValue fxI8(byte value)
{
    return FXValue(cast(double)value, FXType.int8);
}

/// i16
FXValue fxI16(short value)
{
    return FXValue(cast(double)value, FXType.int16);
}

/// i32
FXValue fxI32(int value)
{
    return FXValue(cast(double)value, FXType.int32);
}

/// i64
FXValue fxI64(long value)
{
    return FXValue(cast(double)value, FXType.int64);
}

/// f32
FXValue fxF32(float value)
{
    return FXValue(cast(double)value, FXType.float32);
}

/// f64
FXValue fxF64(double value)
{
    return FXValue(value, FXType.float64);
}

/// ptr
FXValue fxPtr(ulong value)
{
    return FXValue(cast(double)value, FXType.pointer);
}

/// reg
FXValue fxReg(ulong value)
{
    return FXValue(cast(double)value, FXType.register);
}