

## What is FIXE?
**FIXE** is a platform-independent instruction set intended to provide an efficient, portable native backend to compiler projects.

```llvm
message: [u8 x 2] "hi"
length:  u32      2

main: 
    syscall %0, write(i32 1, ptr message, u32 length)
    syscall %1, exit(i32 1)
```

## Installation
TODO

## Supported Platforms
Operating Systems:
- [x] Linux
- [ ] Windows
- [ ] MacOS

Planned Architectures:
- [x] x86_64
- [ ] AArch64
- [ ] RISC-V
- [ ] WASM

## License
See [**LICENSE**](https://github.com/ryaangu/fixe/blob/main/LICENSE) for details.
