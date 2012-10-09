/* launchpad_timer.c
 *
 * Specifies profile timer access functions
 *
 */

#include "launchpad_timer.h"

/* Timer overflow count */
volatile unsigned char LPTimer_ovf = 0;

unsigned long profileTimerRead(void)
{
    static unsigned char firstTime = 0;
    volatile unsigned long out = 0;
    if (firstTime == 0) {
        /* Enable interrupts for Timer overflow */
        CCTL0 = CCIE;
        /* Set up Timer_A Control Register
         * TASSEL_2: Source the Timer clock from SMCLK (125 kHz)
         * MC_2: Set the Timer to continuous mode (count up to 0xFFFF) */
        TACTL = TASSEL_2 + MC_1; //UP
        CCR0 = 0xFFFF; //UP to 0xFFFF
        /* Enable interrupts */
        _BIS_SR(GIE);
        out = 0;
        firstTime = 1;
    } else {
        /* Halt the Timer */
        TACTL = MC_0;
        /* Read the current Timer value */
        out = ((unsigned long)LPTimer_ovf<<16) + TAR;
        /* Resume the Timer */
        TACTL = TASSEL_2 + MC_1;
    }
    return out;
}
#pragma vector=TIMER0_A0_VECTOR
__interrupt void Timer_A (void)
{
    /* We are here because the Timer has overflown */
    LPTimer_ovf++;
}
