/* launchpad_timer.h
 *
 * Specifies function prototypes for profile timer access functions
 *
 */

#ifndef _LPTIMER_H
#define _LPTIMER_H

#ifdef __MW_CODE_METRICS__
#include "code_metrics.h"
#endif
#include <msp430.h>

unsigned short profileTimerRead(void);

#endif
