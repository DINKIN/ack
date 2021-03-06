/* $Id$ */
/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
#define	indir	 0
#define	exit	 1
#define	fork	 2
#define	read	 3
#define	write	 4
#define	open	 5
#define	close	 6
#define	wait	 7
#define	creat	 010
#define	link	 011
#define	unlink	 012
#define	exec	 013
#define	chdir	 014
#define	time	 015
#define	mknod	 016
#define	chmod	 017
#define	chown	 020
#define	break	 021
#define	stat	 022
#define	lseek	 023
#define	getpid	 024
#define	mount	 025
#define	umount	 026
#define	setuid	 027
#define	getuid	 030
#define	stime	 031
#define	ptrace	 032
#define	alarm	 033
#define	fstat	 034
#define	pause	 035
#define	utime	 036
#define	smdate	 036
#define	stty	 037
#define	gtty	 040
#define	access	 041
#define	nice	 042
#define	sleep	 043
#define	ftime	 043
#define	sync	 044
#define	kill	 045
#define	csw	 046
#define	setpgrp	 047
#define	dup	 051
#define	pipe	 052
#define	times	 053
#define	profil	 054
#define	getgrp	 055
#define	setgid	 056
#define	getgid	 057
#define	signal	 060
#define	rtp	 061
#define	setgrp	 062
#define	acct	 063
#define	phys	 064
#define	lock	 065
#define	ioctl	 066
#define	reboot	 067
#define	mpx	 070
#define	vfork	 071
#define	setinf	 073
#define	exece	 073
#define	local	 072
#define	umask	 074
#define	getinf	 074
#define	chroot	 075

#define	login	 01
#define	lstat	 02
#define	submit	 03
#define	nostk	 04
#define	killbkg	 05
#define	killpg	 06
#define	renice	 07
#define	fetchi	 010
#define	ucall	 011
#define	quota	 012
#define	qfstat	 013
#define	qstat	 014
#define	gldav	 016
#define	fperr	 017
#define	vhangup	 020
#define	symlink	 035
#define	readlink 036

#define	select	 022
#define	gethost	 023
#define	sethost	 024
#define	socket	 025
#define	connect	 026
#define	accept	 027
#define	send	 030
#define	receive	 031
#define	socketa	 032
#define	setreuid 033
#define	setregid 034
#define	gethstid 037
#define	sethstid 040

.sect .text; .sect .rom; .sect .data; .sect .bss; .sect .text
