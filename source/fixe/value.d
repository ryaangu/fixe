module fixe.value;

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

FXValue fxVoid()
{
    return FXValue(0, FXType.void_);
}

FXValue fxBool(bool value)
{
    return FXValue(cast(double)value, FXType.bool_);
}

FXValue fxI8(byte value)
{
    return FXValue(cast(double)value, FXType.int8);
}

FXValue fxI16(short value)
{
    return FXValue(cast(double)value, FXType.int16);
}

FXValue fxI32(int value)
{
    return FXValue(cast(double)value, FXType.int32);
}

FXValue fxI64(long value)
{
    return FXValue(cast(double)value, FXType.int64);
}

FXValue fxF32(float value)
{
    return FXValue(cast(double)value, FXType.float32);
}

FXValue fxF64(double value)
{
    return FXValue(value, FXType.float64);
}

FXValue fxPtr(ulong value)
{
    return FXValue(cast(double)value, FXType.pointer);
}

FXValue fxReg(ulong value)
{
    return FXValue(cast(double)value, FXType.register);
}