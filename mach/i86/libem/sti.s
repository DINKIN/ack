.sect .text; .sect .rom; .sect .data; .sect .bss
.sect .text
.define .sti
.define .sts

	! #bytes in cx
	! address in bx
	! save di/si. they might be register variables
.sts:
	mov	dx,di		! save di
	mov	di,bx
	pop	bx
	sar     cx,1
	jnb     1f
	pop     ax
	stosb
	mov	di,dx
	jmp     bx
.sti:
	! only called with count > 4
	mov	dx,di
	mov	di,bx
	pop	bx
	sar	cx,1
1:
	mov	ax,si
	mov     si,sp
	rep movs
	mov     sp,si
	mov	di,dx
	mov	si,ax
	jmp     bx
