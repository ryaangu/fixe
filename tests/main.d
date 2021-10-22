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
    obj.label(".success");
    obj.ret(fxBool(false));
    obj.label(".failure");
    obj.ret(fxBool(true));

    obj.compile(target, "tests/output/test.c");
}