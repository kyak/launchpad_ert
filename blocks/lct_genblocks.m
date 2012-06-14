%% Serial Write
% Populate legacy_code structure with information
serialWrite = legacy_code('initialize');
serialWrite.SFunctionName = 'serialWrite';
serialWrite.HeaderFiles = {'serial.h'};
serialWrite.SourceFiles = {'serial.c'};
serialWrite.StartFcnSpec = 'void serial_init(void)';
serialWrite.OutputFcnSpec = 'void serial_putc(uint8 u1)';
% Support calling from within For-Each subsystem
serialWrite.Options.supportsMultipleExecInstances = true;
%% Serial Read
% Populate legacy_code structure with information
serialRead = legacy_code('initialize');
serialRead.SFunctionName = 'serialRead';
serialRead.HeaderFiles = {'serial.h'};
serialRead.SourceFiles = {'serial.c'};
serialRead.StartFcnSpec = 'void serial_init(void)';
serialRead.OutputFcnSpec = 'uint8 y1 = serial_getc()';
% Support calling from within For-Each subsystem
serialRead.Options.supportsMultipleExecInstances = true;
%% LED control
% Populate legacy_code structure with information
LED_control = legacy_code('initialize');
LED_control.SFunctionName = 'LED_control';
LED_control.HeaderFiles = {'led.h'};
LED_control.SourceFiles = {'led.c'};
LED_control.StartFcnSpec = 'void led_init(void)';
LED_control.OutputFcnSpec = 'led_set(uint8 p1, uint8 u1)';
% Support calling from within For-Each subsystem
LED_control.Options.supportsMultipleExecInstances = true;
%% Put multiple registration files together
def = [serialWrite(:);serialRead(:);LED_control(:)];
%% Legacy Code Tool
% Generate, compile and link S-function for simulation
legacy_code('generate_for_sim', def);
% Generate TLC file for Code Generation
legacy_code('sfcn_tlc_generate', def);
% Generate according Simulink Block
legacy_code('slblock_generate', def);
% Generate rtwmakecfg.m file to automatically set up some build options
legacy_code('rtwmakecfg_generate', def);