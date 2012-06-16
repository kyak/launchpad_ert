launchpad_ert
=============

Simulink (Embedded Coder) Target for TI LaunchPad

Installation:

1) Windows/Linux: Have Code Composer Studio 5 installed.
Note: Currently Code Composer Studio 5 for Linux doesn't support LaunchPad
connection/debugging. Therefore, you will also need mspdebug on Linux to work with CCSv5.
On Linux, you can use mspgcc toolchain instead of CCSv5. This package supports
both mspgcc and CCSv5 on Linux.

Make sure your toolchain is working (build and download some test project, check connection)
before you proceed!

2) Extract this package somewhere. Make sure you have a working/supported host compiler by running mex -setup in MATLAB.
Within MATLAB, cd to the directory containing launchpad_setup.m and run this script.

3) You should be good to go.

What this package already has:
- Standalone execution on target (driven by ISR)
- Support for MSP430G2553 only
- Simulink library blocks for serial read/write, LED, temperature sensor, push button

What this package would like to have:
- PIL
- More Simulink blocks
- Support for other LaunchPad compatible MCUs
- Multirate support
