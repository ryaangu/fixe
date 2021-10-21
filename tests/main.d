module main;

import fixe.fixe;
import std.stdio;

void main()
{
    FXObject obj;
    
    obj.syscall(fxReg(0), fxI32(60), fxI32(0));
    obj.dump();
}