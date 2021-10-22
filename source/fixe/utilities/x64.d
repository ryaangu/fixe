module fixe.utilities.x64;

struct X64Register
{
    uint index;
    uint size;
}

__gshared const(X64Register) gEax = { 0, 4 };
__gshared const(X64Register) gEcx = { 1, 4 };
__gshared const(X64Register) gEdx = { 2, 4 };
__gshared const(X64Register) gEbx = { 3, 4 };
__gshared const(X64Register) gEsp = { 4, 4 };
__gshared const(X64Register) gEbp = { 5, 4 };
__gshared const(X64Register) gEsi = { 6, 4 };
__gshared const(X64Register) gEdi = { 7, 4 };

__gshared const(X64Register) gRax = { 0, 8 };
__gshared const(X64Register) gRcx = { 1, 8 };
__gshared const(X64Register) gRdx = { 2, 8 };
__gshared const(X64Register) gRbx = { 3, 8 };
__gshared const(X64Register) gRsp = { 4, 8 };
__gshared const(X64Register) gRbp = { 5, 8 };
__gshared const(X64Register) gRsi = { 6, 8 };
__gshared const(X64Register) gRdi = { 7, 8 };

struct X64Assembler
{
    ubyte[] code;

    // Write bytes to code
    private void write32(int value)
    {
        ubyte *bytes = cast(ubyte *)(&value);

        for (uint i = 0; i < 4; ++i)
            code ~= bytes[i];
    }

    // XOR
    void xor(ref const(X64Register) a, ref const(X64Register) b)
    {
        if (a.size == 8)
            code ~= 0x48;
        
        code ~= 0x31;
        code ~= cast(ubyte)(((0b11 << 3) | b.index) << 3 | a.index);
    }

    // MOV
    void mov(ref const(X64Register) register, int value)
    {
        code ~= cast(ubyte)(0xB8 + register.index);
        write32(value);
    }

    // SYSCALL
    void syscall()
    {
        code ~= 0x0F;
        code ~= 0x05;
    }

    // LEAVE
    void leave()
    {
        code ~= 0xC9;
    }

    // RET
    void ret()
    {
        code ~= 0xC3;
    }
}