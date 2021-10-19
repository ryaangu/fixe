module fixe.value;

enum
{
    fx_value_void,
    fx_value_u8,
    fx_value_u16,
    fx_value_u32,
    fx_value_u64,
    fx_value_i8,
    fx_value_i16,
    fx_value_i32,
    fx_value_i64,
    fx_value_f32,
    fx_value_f64,
    fx_value_pointer,
    fx_value_address,
    fx_value_array,
    fx_value_register,
}

string[] fx_value_names = 
[
    "void",
    "u8",
    "u16",
    "u32",
    "u64",
    "i8",
    "i16",
    "i32",
    "i64",
    "f32",
    "f64",
    "pointer",
    "address",
    "array",
    "register",
];

struct FXAddress
{
    ulong register;
    long  offset;
}

struct FXValueArray 
{
    uint type;
    uint length;
}

struct FXValue
{
    union
    {
        ubyte        as_u8;
        ushort       as_u16;
        uint         as_u32;
        ulong        as_u64;
        byte         as_i8;
        short        as_i16;
        int          as_i32;
        long         as_i64;
        float        as_f32;
        double       as_f64;
        long         as_pointer;
        FXAddress    as_address;
        FXValueArray as_array;
        ulong        as_register;
    }

    uint type;
}

FXValue fx_void()
{
    FXValue fx_value;

    fx_value.type = fx_value_void;

    return fx_value;
}

FXValue fx_u8(ubyte value)
{
    FXValue fx_value;

    fx_value.type  = fx_value_u8;
    fx_value.as_u8 = value;

    return fx_value;
}

FXValue fx_u16(ushort value)
{
    FXValue fx_value;

    fx_value.type   = fx_value_u16;
    fx_value.as_u16 = value;

    return fx_value;
}

FXValue fx_u32(uint value)
{
    FXValue fx_value;

    fx_value.type   = fx_value_u32;
    fx_value.as_u32 = value;

    return fx_value;
}

FXValue fx_u64(ulong value)
{
    FXValue fx_value;

    fx_value.type   = fx_value_u64;
    fx_value.as_u64 = value;

    return fx_value;
}

FXValue fx_i8(byte value)
{
    FXValue fx_value;

    fx_value.type  = fx_value_i8;
    fx_value.as_i8 = value;

    return fx_value;
}

FXValue fx_i16(short value)
{
    FXValue fx_value;

    fx_value.type   = fx_value_i16;
    fx_value.as_i16 = value;

    return fx_value;
}

FXValue fx_i32(int value)
{
    FXValue fx_value;

    fx_value.type   = fx_value_i32;
    fx_value.as_i32 = value;

    return fx_value;
}

FXValue fx_i64(long value)
{
    FXValue fx_value;

    fx_value.type   = fx_value_i64;
    fx_value.as_i64 = value;

    return fx_value;
}

FXValue fx_register(ulong value)
{
    FXValue fx_value;

    fx_value.type        = fx_value_register;
    fx_value.as_register = value;

    return fx_value;
}