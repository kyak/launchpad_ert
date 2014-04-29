#ifdef MSPGCC
#define __MSP430_IOMACROS_H_
#define sfrb(x,x_) extern volatile unsigned char x
#define sfrw(x,x_) extern volatile unsigned int x
#define sfra(x,x_) extern volatile unsigned long int x
#define const_sfrb(x,x_) sfrb(x,x_)
#define const_sfrw(x,x_) sfrw(x,x_)
#define const_sfra(x,x_) sfra(x,x_)
#define LPM0_bits           (CPUOFF)
#define LPM1_bits           (SCG0+CPUOFF)
#define LPM2_bits           (SCG1+CPUOFF)
#define LPM3_bits           (SCG1+SCG0+CPUOFF)
#define LPM4_bits           (SCG1+SCG0+OSCOFF+CPUOFF)
#endif

#define __interrupt
