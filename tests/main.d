module main;

import fixe.backend.object;
import fixe.backend.value;
import fixe.backend.target;

import std.stdio;

void main()
{
    FXObject obj;
    FXTarget target = FXTarget(FXBackendType.c, FXOSType.linux);

    obj.label("main");
    obj.label(".end");
    obj.ret(fxVoid);
    obj.label("test");
    obj.ret(fxVoid);

    obj.compile(target, "tests/out/test.c");
}