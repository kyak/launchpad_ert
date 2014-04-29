#ifndef MATLAB_MEX_FILE
#include <msp430.h>
#endif
        
#include "button.h"

#ifndef MATLAB_MEX_FILE
#define BUTTON BIT3 //P1.3 (S2 push button on Launchpad)
volatile unsigned char button_status = 0; // to communicate button state to application software
#endif

/* Initialize Push Button */
void button_init(void)
{
#ifndef MATLAB_MEX_FILE
    /* Set button pin as an input pin */
    P1DIR &= ~BUTTON;
    /* set pull up resistor on for button */
    P1OUT |= BUTTON;
    /* enable pull up resistor for button to keep pin high until pressed */
    P1REN |= BUTTON;
    /* Interrupt should trigger from high (unpressed) to low (pressed) */
    P1IES |= BUTTON;
    /* Clear the interrupt flag for the button */
    P1IFG &= ~BUTTON;
    /* Enable interrupts on port 1 for the button */
    P1IE |= BUTTON;
#endif
}

/* Read the button value to the application software */
unsigned char button_get(void)
{
#ifndef MATLAB_MEX_FILE
    unsigned char button_out = button_status;
    button_status = 0; //set to 1 from ISR
    return button_out;
#endif
}

/* *************************************************************
 * Port Interrupt for Button Press
 * *********************************************************** */
#ifndef MATLAB_MEX_FILE
#ifdef SKIP_STATIC_CODE_METRICS
#pragma vector=PORT1_VECTOR
__interrupt void PORT1_ISR (void)
{
    /* clear interrupt flag for port 1 */
    P1IFG = 0;
    /* disable interrupts for the button to handle button bounce */
    P1IE &= ~BUTTON;
    /* set watchdog timer to trigger every 681 milliseconds -- normally
     * this would be 250 ms, but the VLO is slower
     */
    WDTCTL = WDT_ADLY_250;
    /* clear watchdog timer interrupt flag */
    IFG1 &= ~WDTIFG;
    /* enable watchdog timer interrupts; in 681 ms the button
     * will be re-enabled by WDT_ISR() -- program will continue in
     * the meantime.
     */
    IE1 |= WDTIE;
    button_status = 1; //set to 0 from mdlOutput
}

#pragma vector=WDT_VECTOR
 __interrupt void WDT_ISR(void)
{
    /* Disable interrupts on the watchdog timer */
    IE1 &= ~WDTIE;
    /* clear the interrupt flag for watchdog timer */
    IFG1 &= ~WDTIFG;
    /* resume holding the watchdog timer so it doesn't reset the chip */
    WDTCTL = WDTPW + WDTHOLD;
    /* and re-enable interrupts for the button */
    P1IE |= BUTTON;
}

#endif
#endif
