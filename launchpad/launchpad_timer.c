/* launchpad_timer.c
 *
 * Specifies profile timer access functions
 *
 */

#include "launchpad_timer.h"

unsigned short profileTimerRead(void)
{
    static unsigned char firstTime = 0;
    unsigned short out = 0;
    if (firstTime == 0) {
        /* Set up Timer_A Control Register
         * TASSEL_2: Source the Timer clock from SMCLK (125 kHz)
         * MC_2: Set the Timer to continuous mode (count up to 0xFFFF) */
        TACTL = TASSEL_2 + MC_2;
        out = 0;
        firstTime = 1;
    } else {
        /* Halt the Timer */
        TACTL = MC_0;
        /* Read the current Timer value */
        out = TAR;
        /* Resume the Timer */
        TACTL = TASSEL_2 + MC_2;
    }
    return out;
}
