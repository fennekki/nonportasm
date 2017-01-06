.data
startup_msg: .string "nonportasm 0.1\nall fennecs pet\n"
startup_msg_len: .quad (. - startup_msg) # this point - startup_msg

test_str: .string "yiff\n"
test_str_len: .quad (. - test_str)

.text
.global _start # entry point
_start:
    movq $1, %rdi # File descriptor 1 - stdout
    movq $startup_msg, %rsi # Message
    movq (startup_msg_len), %rdx # Get length
    callq write

    movq (test_str_len), %rdi # Allocate a bit of memory
    callq easy_mmap

    # Copy in data
    cld # Clear direction (reverse) flag so we move forward
    movq $test_str, %rsi # Source
    movq %rax, %rdi # Destination address from easy_mmap return value
    movq (test_str_len), %rcx # Set counter to string len
    rep movsb # Copy

    # Let's try printing, same as before
    movq $1, %rdi
    movq %rax, %rsi # The address is still in rax even though we just wiped rdi
    movq (test_str_len), %rdx
    callq write
        
    movq %r12, %rdi # Deallocate the memory
    movq (test_str_len), %rsi
    callq munmap

    xorq %rdi, %rdi # No error, return 0
    jmp exit # callq sys_exit
