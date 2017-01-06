all: nonportasm

nonportasm: mem.o util.o main.o
	$(LD) -o $@ $+ 
