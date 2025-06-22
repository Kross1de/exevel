CC = gcc
LD = ld

CFLAGS = -O2 -pipe -Wall -Wextra

INTERNAL_CFLAGS = \
				  -m16 \
				  -ffreestanding \
				  -nostdlib \
				  -masm=intel \
				  -fno-pic \
				  -mno-sse \
				  -mno-sse2 \
				  -ffreestanding \
				  -fno-stack-protector \
				  -I.

LDFLAGS =

INTERNAL_LDFLAGS = \
				   -m elf_i386 \
				   -nostdlib \
				   -Tlinker.ld 

.PHONY: all clean

C_FILES := $(shell find ./ -type f -name '*.c')
OBJ := $(C_FILES:.c=.o)

all: exe.bin

exe.bin: $(OBJ)
	$(LD) $(LDFLAGS) $(INTERNAL_LDFLAGS) $(OBJ) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(INTERNAL_CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ)
