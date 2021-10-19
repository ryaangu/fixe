module fixe.x64;

struct X64Register
{
    uint index;
    uint size;
}

__gshared const X64Register g_eax = { 0, 4 };
__gshared const X64Register g_ecx = { 1, 4 };
__gshared const X64Register g_edx = { 2, 4 };
__gshared const X64Register g_ebx = { 3, 4 };
__gshared const X64Register g_esp = { 4, 4 };
__gshared const X64Register g_ebp = { 5, 4 };
__gshared const X64Register g_esi = { 6, 4 };
__gshared const X64Register g_edi = { 7, 4 };

__gshared const X64Register g_rax = { 0, 8 };
__gshared const X64Register g_rcx = { 1, 8 };
__gshared const X64Register g_rdx = { 2, 8 };
__gshared const X64Register g_rbx = { 3, 8 };
__gshared const X64Register g_rsp = { 4, 8 };
__gshared const X64Register g_rbp = { 5, 8 };
__gshared const X64Register g_rsi = { 6, 8 };
__gshared const X64Register g_rdi = { 7, 8 };

struct X64Assembler
{
    ubyte[] code;

    // Write bytes to code
    private void write_32(int value)
    {
        ubyte *bytes = cast(ubyte *)(&value);

        for (uint i = 0; i < 4; ++i)
            code ~= bytes[i];
    }

    // XOR
    void xor(const ref X64Register a, const ref X64Register b)
    {
        if (a.size == 8)
            code ~= 0x48;
        
        code ~= 0x31;
        code ~= cast(ubyte)(((0b11 << 3) | b.index) << 3 | a.index);
    }

    // MOV
    void mov(const ref X64Register register, int value)
    {
        code ~= cast(ubyte)(0xB8 + register.index);
        write_32(value);
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