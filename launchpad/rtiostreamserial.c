#include <msp430.h>      
#include "rtiostream.h"
#include "rtwtypes.h"

void FaultRoutine(void);
void ConfigWDT(void);
void ConfigClocks(void);
void led_init(void);
void led_toggle(void);

/* Receive Data at P1.1 */
#define RXD		BIT1

/* Transmit Data at P1.2 */
#define TXD		BIT2

/* Initialize Serial */
int rtIOStreamOpen(int argc, void *argv[])
{
    /* ASCII character a is 65 */
    #define RTIOSTREAM_OPEN_COMPLETE 65
    static const uint8_T init_complete = RTIOSTREAM_OPEN_COMPLETE;
    
    ConfigWDT();
    ConfigClocks();

	P1SEL  = RXD + TXD;                       
  	P1SEL2 = RXD + TXD;                       
  	UCA0CTL1 |= UCSSEL_2;                     // SMCLK
  	UCA0BR0 = 13;                             // 1/8MHz 9600
  	UCA0BR1 = 0;                              // 1/8MHz 9600
  	UCA0MCTL = UCBRS0;                        // Modulation UCBRSx = 1
  	UCA0CTL1 &= ~UCSWRST;                     // Initialize USCI state machine
  	IE2 |= UCA0RXIE;                          // Enable USCI_A0 RX interrupt

    /* send out the initial character */
    while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
  	UCA0TXBUF = init_complete;                // TX
    led_init();
    return RTIOSTREAM_NO_ERROR;
}

uint8_T serial_getc()
{
    while (!(IFG2&UCA0RXIFG));                // USCI_A0 RX buffer ready?
	return UCA0RXBUF;
}

/* Read data from serial */
int rtIOStreamRecv(
    int      streamID, // A handle to the stream that was returned by a previous call to rtIOStreamOpen.
    void   * dst,      // A pointer to the start of the buffer where received data must be copied.
    size_t   size, // Size of data to copy into the buffer. For byte-addressable architectures,
                   // size is measured in bytes. Some DSP architectures are not byte-addressable.
                   // In these cases, size is measured in number of WORDs, where sizeof(WORD) == 1.
    size_t * sizeRecvd) // The number of units of data received and copied into the buffer dst (zero if no data was copied).
{
    *sizeRecvd=0U; // Initialize the number of received chars to zero.
    //unsigned char *ptr = (unsigned char *)dst; // Initialize ptr is a pointer to the buffer of chars.
    uint8_T *ptr = (uint8_T *)dst; // Initialize ptr is a pointer to the buffer of chars.
    while (*sizeRecvd < size ) // Try to receive char as many times as commanded.
    {
        *ptr = serial_getc(); // Receive a char into the buffer of chars (as pointed by ptr).
        ptr++; // Point to the next element of receive buffer.
        (*sizeRecvd)++; // Increase the number of received chars.
    }
    led_toggle();
    return RTIOSTREAM_NO_ERROR;
}


void serial_putc(uint8_T c)
{
	while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
  	UCA0TXBUF = c;                    		  // TX
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

    while((*sizeSent < size)) {
    	serial_putc(*ptr);
        ptr++;
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
    if (CALBC1_1MHZ ==0xFF || CALDCO_1MHZ == 0xFF)
    FaultRoutine(); // If calibration data is erased
                    // run FaultRoutine()
    BCSCTL1 = CALBC1_1MHZ; // Set range
    DCOCTL = CALDCO_1MHZ; // Set DCO step + modulation
    BCSCTL3 |= LFXT1S_2; // LFXT1 = VLO
    IFG1 &= ~OFIFG; // Clear OSCFault flag
    BCSCTL2 |= SELM_0 + DIVM_3 + DIVS_3; // MCLK = DCO/8, SMCLK = DCO/8
    //BCSCTL2 = 0; //to drive MCLK and SMCLK directly from DCO
}

void FaultRoutine(void)
{
    P1OUT = BIT0; // P1.0 on (red LED)
    while(1); // TRAP
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