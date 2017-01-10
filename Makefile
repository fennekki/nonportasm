all: nonportasm

nonportasm: mem.o stringz.o io.o util.o main.o
	$(LD) -o $@ $+ 
