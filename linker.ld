OUTPUT_FORMAT(binary)
ENTRY(main)

SECTIONS
{
	. = 0x8000;

    	.text : {
        	bootsect_begin = .;
        	KEEP(*(.entry*))
		*(.text*)
    	}

	.rodata : {
		*(.rodata*)
	}

    	.data : {
        	KEEP(*(.data*))
        	. += 31744 - (. - bootsect_begin);
    	}

	.bss : {
		bss_begin = .;
		*(.bss*)
		bss_end = .;
	}
}
