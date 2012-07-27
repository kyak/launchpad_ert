function sl_customization(cm)
% SL_CUSTOMIZATION for TI LaunchPad PIL connectivity config

cm.registerTargetInfo(@loc_createSerialConfig);

% local function
function config = loc_createSerialConfig

config = rtw.connectivity.ConfigRegistry;
config.ConfigName = 'TI LaunchPad connectivity config using Serial';
config.ConfigClass = 'launchpad.ConnectivityConfig';

% matching launchpad target file
config.SystemTargetFile = {'launchpad.tlc'};

% match launchpad template makefile
config.TemplateMakefile = {'launchpad_tmf'};

% match launchpad hardware configuration
config.TargetHWDeviceType = {'Texas Instruments->MSP430'};