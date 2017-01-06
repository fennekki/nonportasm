# nonportasm

## Calling convention

(Integer) args go in rdi, rsi, rdx, r10, r8, r9. Return goes in rax and rdx.
Registers rbp, rbx and r12 to r15 are callee-saved, others are caller-saved.
