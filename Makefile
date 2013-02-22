#COBJS = main.o
SOBJS = helloos.o lowlevel_init.o begin.o lib.o int_entry.o
SOBJS += dummy.o
COBJS = start.o font.o mouse.o

LDSCRITP = helloos.lds
#SRCS := $(SOBJS:.o=.s) $(COBJS:.o=.c)


helloos: $(SOBJS) $(LDSCRITP) $(COBJS)
	ld -N -T $(LDSCRITP) $(SOBJS) $(COBJS) -o $@ --print-map
helloos.bin: helloos
	objcopy -O binary $< $@
dump: helloos.bin
	objdump -b binary -D -mi8086 $<
boot.img: helloos.bin
	dd if=$< of=boot.img bs=512 count=1024
run.x86: boot.img
	kvm -d cpu -fda $< -net none -no-kvm

clean:
	rm -rf boot.img helloos $(SOBJS) $(COBJS) helloos.bin
