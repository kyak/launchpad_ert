#ifndef MATLAB_MEX_FILE
#ifdef __MW_CODE_METRICS__
#include "code_metrics.h"
#endif
#include <msp430.h>
#endif

/* only defined by mspgcc */
#ifdef MSP430
/* Delay Routine from mspgcc help file */
static void __inline__ delay(register unsigned int n)
{
  __asm__ __volatile__ (
  "1: \n"
  " dec %[n] \n"
  " jne 1b \n"
        : [n] "+r"(n));
}
#endif

#include "temperature.h"

/* Initialize Temperature measurements */
void temperature_init(void)
{
#ifndef MATLAB_MEX_FILE
#endif
}

/* Read the temperature to the application software */
/* unit: 1/2 (Celsius/Fahrenheit) */
signed char temperature_read(unsigned char unit)
{
#ifndef MATLAB_MEX_FILE
    ADC10CTL1 = INCH_10 + ADC10DIV_0; // Temp Sensor ADC10CLK
    ADC10CTL0 = SREF_1 + ADC10SHT_3 + REFON + ADC10ON;
	#ifdef MSP430
	delay(5);
	#else
	_delay_cycles(5);           // Wait for ADC Ref to settle
	#endif
    ADC10CTL0 |= ENC + ADC10SC; // Sampling & conversion start
	#ifdef MSP430
    delay(100);
	#else
    _delay_cycles(100);
	#endif
    ADC10CTL0 &= ~ENC;          // Disable ADC conversion
    ADC10CTL0 &= ~(REFON + ADC10ON); // Ref and ADC10 off
    // Read conversion value, convert and return
    if (unit == 2)
        // oF = ((A10/1024)*1500mV)-923mV)*1/1.97mV = A10*761/1024 - 468
        return (signed char)( (((long)ADC10MEM - 630) * 761) / 1024 );
    else
        // oC = ((A10/1024)*1500mV)-986mV)*1/3.55mV = A10*423/1024 - 278
        return (signed char)( (((long)ADC10MEM - 673) * 423) / 1024 );
#endif
}
