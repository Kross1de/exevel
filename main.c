asm (
    ".section .entry\n\t"
    "xor dh, dh\n\t"
    "push edx\n\t"
    "call main\n\t"
);

#include <drivers/vga_textmode.h>
#include <lib/real.h>

void main(int bootDrive) {
	init_vga_textmode();
	text_write("exevel\n\n", 11);
	for (;;) {
		struct rm_regs r = {0};
		rm_int(0x16, &r, &r);
		char c = (char)(r.eax & 0xff);
		text_write(&c, 1);
	}	
}
