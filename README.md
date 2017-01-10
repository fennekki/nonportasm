# nonportasm

## Calling convention

(Integer) args go in rdi, rsi, rdx, r10, r8, r9. Return goes in rax and rdx.
Registers rbp, rbx and r12 to r15 are callee-saved, others are caller-saved.

## Strings

Strings are all UTF-8 encoded (implicitly! Nothing in the code enforces this or
checks encoding, right now) so this thing probably will produce completely
unexpected results on systems that use non-8-bit character encoding and vaguely
wrong results on those that use non-UTF-8 encodings.

The "native" string type consists of a bytestring of UTF-8 codepoints prefixed
by a 64-bit (8-byte) integer specifying the length of the string. This means
even an "empty" string is in fact 8 bytes long, but on the other hand all
strings carry their length information with them.
