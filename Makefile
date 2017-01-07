all: nonportasm

nonportasm: mem.o io.o util.o main.o
	$(LD) -o $@ $+ 
