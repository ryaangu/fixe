module main;

import fixe.fixe;

void main()
{
    FXObject obj;
    
    obj.frame();
    obj.syscall(fx_register(0), fx_i32(60), fx_i32(0));
    obj.frame_end();

    dump(obj);
    obj.compile();
}