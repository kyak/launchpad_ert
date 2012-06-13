% Populate legacy_code structure with information
def = legacy_code('initialize');
def.SFunctionName = 'serialRead';
def.HeaderFiles = {'serial.h'};
def.SourceFiles = {'serial.c'};
def.StartFcnSpec = 'void serial_init(void)';
def.OutputFcnSpec = 'uint8 y1 = serial_getc()';

% Support calling from within For-Each subsystem
def.Options.supportsMultipleExecInstances = true;

% Generate, compile and link S-function for simulation
legacy_code('generate_for_sim', def);
% Generate TLC file for Code Generation
legacy_code('sfcn_tlc_generate', def);
% Generate according Simulink Block
legacy_code('slblock_generate', def);
% Generate rtwmakecfg.m file to automatically set up some build options
legacy_code('rtwmakecfg_generate', def);