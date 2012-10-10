launchpad_ert
=============

Simulink (Embedded Coder) Target for TI LaunchPad

Summary:
TI LaunchPad (http://ti.com/launchpad) is an easy-to-use, affordable (< 5 USD),
and scalable introduction to the world of microcontrollers and the MSP430 family.
Simulink (http://www.mathworks.com/products/simulink) is a leading environment
for multidomain simulation and Model-Based Design.
Embedded Coder (http://www.mathworks.com/products/embedded-coder) allows you to
generate C code and deploy your algorithms to target hardware.

Installation:

1) Windows/Linux: Have Code Composer Studio 5 installed (http://processors.wiki.ti.com/index.php/Download_CCS).
Note: Currently Code Composer Studio 5 for Linux doesn't support LaunchPad
connection/debugging. Therefore, you will also need mspdebug (http://mspdebug.sourceforge.net/) on Linux to
download/debug after compiling with CCSv5 toolchain.
On Linux, you can use mspgcc toolchain instead of CCSv5. This package supports
both mspgcc and CCSv5 on Linux.

Make sure your toolchain is working (build and download some test project, check connection)
before you proceed!

2) Extract this package somewhere. Make sure you have a working/supported
host compiler (http://www.mathworks.com/support/compilers/R2012b/index.html) by running 'mex -setup' in MATLAB.
Within MATLAB, 'cd' to the directory containing launchpad_setup.m and run this script.

3) You should be good to go.

What this package already has:
- Standalone execution on target (driven by ISR)
- Support for MSP430G2553 only
- Simulink library blocks for:
        * Serial read/write (hardware UART - you must swap TX/RX jumpers on your LaunchPad)
        * LED
        * Built-in temperature sensor
        * Push button
- Execution in PIL mode
- PIL mode profiling

What this package would like to have:
- More Simulink blocks (Generic ADC, PWM...)
- Support for other LaunchPad compatible MCUs
- More documentation
