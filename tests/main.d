module main;

import fixe.fixe;

void main()
{
    FXObject obj;
    
    obj.frame();
    obj.syscall(fx_register(0), fx_i32(60), fx_i32(0));
    obj.syscall(fx_register(1), fx_i32(60), fx_i32(0));
    obj.syscall(fx_register(3), fx_i32(60), fx_i32(0));
    obj.syscall(fx_register(4), fx_i32(60), fx_i32(0));
    obj.syscall(fx_register(5), fx_i32(60), fx_i32(0));
    obj.syscall(fx_register(0), fx_i32(60), fx_i32(0));
    obj.frame_end();

    dump(obj);
    obj.compile();
}