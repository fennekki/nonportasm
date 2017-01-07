# Rudimentary memory management

.text
.global mmap
mmap:
    # Calls the Linux sys_mmap syscall to give us some memory.
    #
    # Inputs:
    # 	%rdi - placement hint. Set to 0, usually
    # 	%rsi - length of area to allocate
    # 	%rdx - protection mask
    # 	       0x0 - PROT_NONE - no access
    # 	       0x1 - PROT_READ - readable
    # 	       0x2 - PROT_WRITE - writable
    # 	       0x4 - PROT_EXEC - executable
    #	%r10 - flags: Lots. Ones that make sense:
    #	       NOTE: EITHER SHARED OR PRIVATE IS REQUIRED LEST YOU WANT EINVAL
    #	       0x01 - MAP_SHARED - share changes
    #	       0x02 - MAP_PRIVATE - private copy-on-write mapping
    #	       0x20 - MAP_ANONYMOUS - not backed by file. Set this
    #	%r8 - file descriptor for memory backed file.
    #	      Set to -1, usually
    #	%r9 - offset into mapped file. Set to 0, usually
    #
    # Outputs:
    # 	%rax - allocated memory address OR on error, error code matchin errno

    movq $9, %rax
    syscall
    retq

.global munmap
munmap:
    # Calls the Linux sys_munmap syscall to free allocated memory.
    #
    # Inputs:
    # 	%rdi - address to deallocate
    # 	%rsi - length to deallocate
    #
    # Outputs:
    # 	%rax - TODO what DOES it return? 0 or errno? Whoof knows

    movq $11, %rax
    syscall
    retq

.global easy_mmap
easy_mmap:
    # Just allocate the goddamn memory already.
    #
    # Inputs:
    # 	%rdi - amount of memory to allocate
    #
    # Dirties:
    # 	%rdi
    # 	%rsi
    # 	%rdx
    # 	%r10
    # 	%r8
    # 	%r9
    #
    # Outputs:
    # 	%rax - allocated memory address OR on error, error code matchin errno

    movq %rdi, %rsi # Move length to correct register
    movq $0, %rdi # Don't care about placement in memory
    movq $0x3, %rdx # Readable and writable
    movq $0x21, %r10 # Not backed by a file, shared
    movq $-1, %r8 # No file descriptor
    movq $0, %r9 # File offset 0
    movq $9, %rax # mmap inlined here
    syscall
    retq

.global easy_alloc
easy_alloc:
    # Allocate memory that "knows" how much memory you allocated.
    #
    # Currently backed by mmap and not a proper malloc! I believe mmap
    # allocates entire pages to the process which is non-ideal.
    #
    # Inputs:
    # 	%rdi - amount of memory to allocate
    #
    # Dirties:
    # 	%rdi
    # 	%rsi (via easy_mmap)
    # 	%rdx (via easy_mmap)
    # 	%r10 (via easy_mmap)
    # 	%r8 (via easy_mmap)
    # 	%r9 (via easy_mmap)
    #
    # Outputs:
    # 	%rax - allocated memory address OR on error a literal 0

    addq $8, %rdi # Add 8 bytes to requested memory size
    pushq %rdi # Save size
    callq easy_mmap # Allocate
    cmp $0, %rax # Compare rax to 0
    jge 1f # Jump to 1f if we got a positive value; We'll assume it's valid

    # If we stay here, we have an error
    movq $0, %rax
    retq # Return 0

    1: popq %rdi # Return saved size
    movq %rdi, (%rax) # Copy size of allocated memory block to memory block
    addq $8, %rax # Skip the size part in returned value
    retq

.global easy_free
easy_free:
    # Deallocate memory that "knows" how much memory you allocated.
    #
    # Inputs:
    # 	%rdi - memory address to deallocate
    #
    # Dirties:
    # 	%rdi
    # 	%rsi
    #
    # Outputs:
    # 	%rax - TODO what do we return

    subq $8, %rdi # Move address 8 bytes back 
    movq (%rdi), %rsi # Move the length of block to rsi
    callq munmap # Unmap
    retq
