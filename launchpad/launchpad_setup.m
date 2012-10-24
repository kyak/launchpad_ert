function launchpad_setup()

curpath = pwd;
tgtpath = curpath(1:end-length('/launchpad'));
addpath(fullfile(tgtpath, 'launchpad'));
addpath(fullfile(tgtpath, 'demos'));
addpath(fullfile(tgtpath, 'blocks'));
savepath;
if ispref('launchpad')
	rmpref('launchpad');
end
addpref('launchpad','TargetRoot',curpath);
addpref('launchpad','COMPort',setup_com_port);
if isunix
	toolchain = questdlg('Are you using mspgcc or CCSv5 toolchain?',...
		'UNIX Toolchain Selection','mspgcc','CCSv5','mspgcc');
    if (strcmp(toolchain,'mspgcc'))
		%TODO Check return status
		[~,MSPGCC] = system('which msp430-gcc');
		addpref('launchpad','MSPGCC',deblank(MSPGCC));
	elseif (strcmp(toolchain,'CCSv5'))
		[CCSRoot, CompilerRoot] = ccs_setup_paths;
		addpref('launchpad','CCSRoot',CCSRoot);
		addpref('launchpad','CompilerRoot',CompilerRoot);
	else
		error('Your setup is not complete!');
    end
    if verLessThan('matlab', '8.0')
        %MATLAB < R2012b didn't have host rtiostreamserial implementation
        %for Linux, so use our own.
        cd('rtiostreamserial_host');
        system(['make',' CFLAGS=-I',matlabroot,'/extern/include']);
        cd(curpath);
    end
else
	[CCSRoot, CompilerRoot] = ccs_setup_paths;
	addpref('launchpad','CCSRoot',CCSRoot);
	addpref('launchpad','CompilerRoot',CompilerRoot);
end
cd('../blocks');
lct_genblocks;
cd(curpath);
sl_refresh_customizations;
disp('TI LaunchPad Target setup is complete!');
disp('<strong>!!! Make sure you''ve crossed TX/RX jumpers on LaunchPad board !!!</strong>');
disp('Otherwise, Serial connection and PIL won''t work');
end

function [CCSRoot, CompilerRoot] = ccs_setup_paths()
	% TODO: make it foolproof
	CCSRoot = uigetdir(matlabroot,'CCS root directory: (the one with ccs_base, tools ...)');
	CompilerRoot = uigetdir(CCSRoot,'CCS Compiler root directory: (tools/compiler/msp430_X.X.X)');
end

function COMPort = setup_com_port()

[ports, names] = find_com_ports;

% Choose COM port
[selection,ok] = listdlg('PromptString','Choose TI LaunchPad COM port:',...
    'SelectionMode','single',...
    'ListSize',[260 160],...
    'ListString',names);
if (ok == 1 && selection > 2) %have actually chosen COM port
    COMPort = char(ports{selection-2}); % -2 for padding with names array
elseif (ok == 1 && selection > 1) %chosen to refresh COM Ports
    COMPort = setup_com_port();
else %chosen to enter manually or canceled
    COMPort = cell2mat(inputdlg('Enter COM port manually: (ex. COM3 or ttyACM0)','COM port',1));
end
end

function [ports, names] = find_com_ports()
%Find COM ports
names_string = {'Enter COM port manually...','Refresh COM ports list...'};
if isunix
    %TODO
	%check /dev/serial
	unixCmd = 'ls -l /dev/serial/by-id/*';
	[unixCmdStatus,unixCmdOutput]=system(unixCmd);
	if (unixCmdStatus > 0)
		ports = {};
		names = {};
	else
		%names = regexp(unixCmdOutput,'(?<=/dev/serial/by-id/)\S+','match');
		%ports = regexp(unixCmdOutput,'(?<=->.*/)tty\w+','match');
		[names, ports] = regexp(unixCmdOutput,'(?<=/dev/serial/by-id/)\S.*?((?<=->.*/)tty\w+)','match','tokens');
	end
else
    wmiCmd = ['wmic /namespace:\\root\cimv2 '...
              'path Win32_SerialPort get DeviceID,Name'];
    %TODO catch error (wmic is not on WinXP Home for instance).
    [~,wmiCmdOutput]=system(wmiCmd);
    % in a single regexp call with tokens
    [names, ports] = regexp(wmiCmdOutput,'(?<=COM\d+\s*)\S.*?\((COM\d+)\)','match','tokens');
    % same in two regexp calls..
    %ports = regexp(wmiCmdOutput,'COM\d+(?!\))','match');
    %names = regexp(wmiCmdOutput,'(?<=COM\d+\s*)\S.*?\(COM\d+\)','match');
    %regCmd=['reg query '...
    %        'HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM'];
    %[~,regCmdOutput]=system(regCmd);
    %ports = regexp(regCmdOutput,'COM\d+','match');
end
names = [names_string,names];
end
