.define _lock
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.extern _lock
_lock:		trap #0
.data2	0x35
			bcc	1f
			jmp	cerror
1:
			clr.l	d0
			rts
