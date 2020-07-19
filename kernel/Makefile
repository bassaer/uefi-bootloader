CC        = gcc
INCLUDE   = -I../include -I../bin/include
CFLAGS    = -c -Wall -Wextra $(INCLUDE) -nostdlib -fno-builtin
KERN_OBJ  = kernel/main.o \

.PHONY: build clean

build: kernel.bin

%.o: %.c
	${CC} $(CFLAGS) -o $@ $*.c

%.bin: %.o
	ld $(LDFLAGS) $^ -T $*.ld -o $@

kernel.bin: main.o
	ld $^ -Map kernel.map -o $@

clean:
	rm -rf *.img kernel.bin *.o *.map
