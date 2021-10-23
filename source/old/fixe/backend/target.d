module old.fixe.backend.target;

enum FXBackendType
{
    unsupported,
    c,
    x86_64,
}

enum FXOSType
{
    unsupported,
    linux,
}

struct FXTarget
{
    FXBackendType backend;
    FXOSType      os;


}