.define _chroot
.sect .text
.sect .rom
.sect .data
.sect .bss
.extern _chroot
.sect .text
_chroot:	move.w #0x3D,d0
		move.l 4(sp),a0
		jmp callc
