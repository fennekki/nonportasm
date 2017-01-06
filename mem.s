# Rudimentary memory management

.global mmap
mmap:
    # Calls the Linux sys_mmap syscall to give us some memory
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
    # Calls the Linux sys_munmap syscall to free allocated memory
    #
    # Inputs:
    # 	%rdi - address to deallocate
    # 	%rsi - length to deallocate
    #
    # Outputs:
    # 	%rax - TODO what

    movq $11, %rax
    syscall
    retq

.global easy_mmap
easy_mmap:
    # Just allocate the goddamn memory already
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
    # 	TODO should these be cleaned? Probably not?
    #
    # Outputs:
    # 	%rax - allocated memory address
    # 	TODO NO IT DOESNT?? I T RETURNS 0???

    movq %rdi, %rsi # Move length to correct register
    movq $0, %rdi # Don't care about placement in memory
    movq $0x3, %rdx # Readable and writable
    movq $0x21, %r10 # Not backed by a file, shared
    movq $-1, %r8 # No file descriptor
    movq $0, %r9 # File offset 0
    movq $9, %rax # mmap inlined here
    syscall
    retq
