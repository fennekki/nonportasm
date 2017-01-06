all: nonportasm

nonportasm: main.o
	$(LD) -o $@ $+ 
