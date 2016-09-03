/* $Source: /cvsroot/tack/Ack/plat/linux386/libsys/signal.c,v $
 * $State: Exp $
 * $Revision: 1.1 $
 */

#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include "libsys.h"

sighandler_t signal(int signum, sighandler_t handler)
{
	return (sighandler_t) _syscall(__NR_signal, signum, (quad) handler, 0);
}
