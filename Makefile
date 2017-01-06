all: nonportasm

nonportasm: util.o main.o
	$(LD) -o $@ $+ 
