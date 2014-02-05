function [xdata, ydata, lut_size] = fix_sine(errmax,nptsmax)
func = 'sin(x)';
% Define the range over which to optimize breakpoints
xmin = -2*pi;
xmax = 2*pi;
% Define the data type and scaling for the inputs
xdt = sfix(16);
xscale = 2^-12;
% Define the data type and scaling for the outputs
ydt = sfix(16);
yscale = 2^-14;
% Specify the rounding method
rndmeth = 'Floor';
% Define the maximum acceptable error
%errmax = 2^-2;
% Choose even, power-of-2 spacing for breakpoints
spacing = 'pow2';
% Generate data points for the lookup table
[xdata,ydata,errworst]=fixpt_look1_func_approx(func,...
 xmin,xmax,xdt,xscale,ydt,yscale,rndmeth,errmax,nptsmax,spacing);
lut_size = length(xdata);
% Plot the sine function (ideal and fixed-point) & errors
%fixpt_look1_func_plot(xdata,ydata,func,xmin,xmax,...
 %xdt,xscale,ydt,yscale,rndmeth);