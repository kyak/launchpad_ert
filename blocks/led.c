#ifndef MATLAB_MEX_FILE
#include <msp430.h>
#endif
        
#include "led.h"

/* Initialize LEDs */
void led_init(void)
{
#ifndef MATLAB_MEX_FILE
    P1DIR |= BIT6 + BIT0;                 // P1.6 and P1.0 outputs
    P1OUT &= ~(BIT6 + BIT0);              // LEDs off
#endif
}

/* Set LED status */
/* led: 1/2 (red/green); status: 0/1 (off/on) */
void led_set(unsigned char led, unsigned char status)
{
#ifndef MATLAB_MEX_FILE
    if (led == 1)
        if (status == 1)
            P1OUT |= BIT0;                   // P1.0 on (red LED)
        else
            P1OUT &= ~BIT0;                  // red LED off
    else if (led == 2)
        if (status == 1)
            P1OUT |= BIT6;                   // P1.6 on (green LED)
        else
            P1OUT &= ~BIT6;                  // green LED off
    else
        P1OUT = 0;                       // should never get here
#endif
}
