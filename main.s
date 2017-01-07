.data
startup_msg: .string "nonportasm 0.1\nall fennecs pet\n"
startup_msg_len: .quad (. - startup_msg) # this point - startup_msg

test_str: .string "yiff\n"
test_str_len: .quad (. - test_str)

alloc_error_msg: .string "Failed to allocate memory\n"
alloc_error_msg_len: .quad (. - alloc_error_msg)

.text
.global _start # entry point
_start:
    movq $1, %rdi # File descriptor 1 - stdout
    movq $startup_msg, %rsi # Message
    movq (startup_msg_len), %rdx # Get length
    callq write

    movq (test_str_len), %rdi # Allocate a bit of memory
    callq easy_alloc
    movq %rax, %r12 # Save address in r12
    
    testq %rax, %rax # See if we succeeded in allocating
    jz alloc_error # If zero, quit with error

    # Copy in data
    cld # Clear direction (reverse) flag so we move forward
    movq $test_str, %rsi # Source
    movq %rax, %rdi # Destination address from easy_mmap return value
    movq (test_str_len), %rcx # Set counter to string len
    rep movsb # Copy

    # Let's try printing, same as before
    movq $1, %rdi
    movq %r12, %rsi # Address was stored in r12
    movq (test_str_len), %rdx
    callq write
        
    movq %r12, %rdi # Again, address from r12
    callq easy_free # Deallocate the memory

    xorq %rdi, %rdi # No error, return 0
    jmp exit # callq sys_exit

alloc_error:
    movq $2, %rdi # stderr
    movq $alloc_error_msg, %rsi
    movq (alloc_error_msg_len), %rdx
    callq write
    
    movq $1, %rdi # Return 1
    jmp exit
