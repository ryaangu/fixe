module main;

import fixe.backend.object;
import fixe.backend.value;
import fixe.backend.target;

import std.stdio;

void main()
{
    FXObject obj;
    
    obj.label("main");
    obj.ret(fxVoid);
    obj.label("test");
    obj.ret(fxVoid);

    obj.compile(FXTarget(FXBackendType.c, FXOSType.linux), "tests/out/test.c");
}