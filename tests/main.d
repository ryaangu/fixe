module main;

import fixe.backend.object;
import fixe.backend.value;

import std.stdio;

void main()
{
    FXObject obj;
    
    obj.syscall(fxReg(0), fxI32(60), fxI32(0));
    obj.ret(fxVoid);

    obj.dump();
}