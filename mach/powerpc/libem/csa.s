.sect .text

! this is not a subroutine, but just a
! piece of code that computes the jump-
! address and jumps to it.
! traps if resulting address is zero
!
! Stack: ( value tableaddr -- )

.define .csa
.csa:
	lwz r3, 0(sp)
	lwz r4, 4(sp)
	addi sp, sp, 8

	lwz r5, 0(r3)            ! load default
	mtspr ctr, r5
	
	lwz r5, 4(r3)            ! fetch lower bound
	subf. r4, r5, r4         ! adjust value
	bltctr                   ! jump to default if out of range

	lwz r5, 8(r3)            ! fetch range
	cmplw r4, r5
	bgtctr                   ! jump to default if out of range

	addi r3, r3, 12          ! skip header
	slwi r4, r4, 2           ! scale value (<<2)
	lwzx r5, r3, r4          ! load target
	mtspr ctr, r5

	or. r5, r5, r5           ! test it
	bnectr                   ! jump to target if non-zero
	b .trap_ecase            ! otherwise trap
