#ifndef MATLAB_MEX_FILE 
#include <msp430.h>
#endif
        
#include "serial.h"

/* Receive Data at P1.1 */
#define RXD		BIT1

/* Transmit Data at P1.2 */
#define TXD		BIT2


/* Initialize Serial */
void serial_init(void)
{
#ifndef MATLAB_MEX_FILE 

	P1SEL  = RXD + TXD;                       
  	P1SEL2 = RXD + TXD;                       
  	UCA0CTL1 |= UCSSEL_2;                     // SMCLK
  	UCA0BR0 = 13;                             // 1/8MHz 9600
  	UCA0BR1 = 0;                              // 1/8MHz 9600
  	UCA0MCTL = UCBRS0;                        // Modulation UCBRSx = 1
  	UCA0CTL1 &= ~UCSWRST;                     // Initialize USCI state machine
  	IE2 |= UCA0RXIE;                          // Enable USCI_A0 RX interrupt
#endif
}

/* Read one character from serial (blocking!) */
unsigned char serial_getc()
{
#ifndef MATLAB_MEX_FILE
    while (!(IFG2&UCA0RXIFG));                // USCI_A0 RX buffer ready?
	return UCA0RXBUF;
#endif
}

/* Write one character to serial (blocking!) */
void serial_putc(unsigned char c)
{
#ifndef MATLAB_MEX_FILE
	while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
  	UCA0TXBUF = c;                    		  // TX
#endif
}
