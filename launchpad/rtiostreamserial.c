#ifdef __MW_CODE_METRICS__
#include "code_metrics.h"
#endif
#include <msp430.h>      
#include "rtiostream.h"
#include "rtwtypes.h"

void FaultRoutine(void);
void ConfigWDT(void);
void ConfigClocks(void);
void usci_init(void);
void led_init(void);
void led_toggle(void);
uint8_T serial_getc();
void serial_putc(uint8_T c);

/* Receive Data at P1.1 */
#define RXD		BIT1

/* Transmit Data at P1.2 */
#define TXD		BIT2

/* Initialize Serial */
int rtIOStreamOpen(int argc, void *argv[])
{
    /* ASCII character A is 65 */
    #define RTIOSTREAM_OPEN_COMPLETE 65
    static const uint8_T init_complete = RTIOSTREAM_OPEN_COMPLETE;
    
    ConfigWDT();
    ConfigClocks();
    usci_init();

    /* send out the initial character */
  	//serial_putc(init_complete);

    led_init();
    return RTIOSTREAM_NO_ERROR;
}

/* Read data from serial */
int rtIOStreamRecv(
    int      streamID,  // A handle to the stream that was returned by a previous call to rtIOStreamOpen.
    void   * dst,       // A pointer to the start of the buffer where received data must be copied.
    size_t   size, 	    // Size of data to copy into the buffer. For byte-addressable architectures,
                   	    // size is measured in bytes. Some DSP architectures are not byte-addressable.
                   	    // In these cases, size is measured in number of WORDs, where sizeof(WORD) == 1.
    size_t * sizeRecvd) // The number of units of data received and copied into the buffer dst (zero if no data was copied).
{
    uint8_T *ptr = (uint8_T *)dst; // Initialize ptr is a pointer to the buffer of chars.

    *sizeRecvd=0U; // Initialize the number of received chars to zero.

    while (*sizeRecvd < size) // Try to receive char as many times as commanded.
    {
    	*ptr++ = serial_getc();
        (*sizeRecvd)++; 		 // Increase the number of received chars.
    }
    led_toggle();
    return RTIOSTREAM_NO_ERROR;
}

/* Write data to serial */
int rtIOStreamSend(
    int          streamID,
    const void * src,
    size_t       size,
    size_t     * sizeSent)
{

    *sizeSent=0U;
    uint8_T *ptr = (uint8_T *)src;

    while (*sizeSent < size) {
    	serial_putc(*ptr++);
        (*sizeSent)++;
    }
    return RTIOSTREAM_NO_ERROR;
}

int rtIOStreamClose(int streamID)
{
    return RTIOSTREAM_NO_ERROR;
}

void ConfigWDT(void)
{
    WDTCTL = WDTPW + WDTHOLD; // Stop watchdog timer
}

void ConfigClocks(void)
{
    /* 
     * Basic Clock System Control 2
     * 
     * SELM_0 -- DCOCLK
     * DIVM_0 -- Divide by 1
     * ~SELS -- DCOCLK
     * DIVS_3 -- Divide by 8
     * ~DCOR -- DCO uses internal resistor
     * 
     * Note: ~<BIT> indicates that <BIT> has value zero
     */
    BCSCTL2 = SELM_0 | DIVM_0 | DIVS_3;

    if (CALBC1_1MHZ != 0xFF) {
        /* Follow recommended flow. First, clear all DCOx and MODx bits. Then
         * apply new RSELx values. Finally, apply new DCOx and MODx bit values.
         */
        DCOCTL = 0x00;
        BCSCTL1 = CALBC1_1MHZ;      /* Set DCO to 1MHz */
        DCOCTL = CALDCO_1MHZ;
    }

    /* 
     * Basic Clock System Control 1
     * 
     * XT2OFF -- Disable XT2CLK
     * ~XTS -- Low Frequency
     * DIVA_0 -- Divide by 1
     * 
     * Note: ~XTS indicates that XTS has value zero
     */
    BCSCTL1 |= XT2OFF | DIVA_0;

    /* 
     * Basic Clock System Control 3
     * 
     * XT2S_0 -- 0.4 - 1 MHz
     * LFXT1S_2 -- If XTS = 0, XT1 = VLOCLK ; If XTS = 1, XT1 = 3 - 16-MHz crystal or resonator
     * XCAP_1 -- ~6 pF
     */
    BCSCTL3 = XT2S_0 | LFXT1S_2 | XCAP_1;
}

void FaultRoutine(void)
{
    P1OUT = BIT0; // P1.0 on (red LED)
    while(1); // TRAP
}

void usci_init(void)
{
	P1SEL  = RXD + TXD;
  	P1SEL2 = RXD + TXD;
  	UCA0CTL1 |= UCSSEL_2;                     // SMCLK
  	UCA0BR0 = 52; //2400 see http://www.daycounter.com/Calculators/MSP430-Uart-Calculator.phtml
  	UCA0BR1 = 0;
  	UCA0MCTL = 0x20;
  	UCA0CTL1 &= ~UCSWRST;                     // Initialize USCI state machine
}

void led_init(void)
{
    P1DIR |= BIT0;                 // P1.0 output (red LED)
    P1OUT &= ~BIT0;                // LED off
}

void led_toggle(void)
{
    static unsigned char led_counter = 0;
    unsigned char led_threshold = 100;
    if (led_counter > led_threshold)
    {
        P1OUT |= BIT0;                   // P1.0 on (red LED)
        led_counter = 0;
    } else {
        P1OUT &= ~BIT0;                  // red LED off
    }
    led_counter++;
}

uint8_T serial_getc()
{
    while (!(IFG2&UCA0RXIFG));                // USCI_A0 RX buffer ready?
	return UCA0RXBUF;
}

void serial_putc(uint8_T c)
{
	while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
  	UCA0TXBUF = c;                    		  // TX
}
