function launchpad_setup()

curpath = pwd;
tgtpath = curpath(1:end-length('/launchpad'));
addpath(fullfile(tgtpath, 'launchpad'));
addpath(fullfile(tgtpath, 'blocks'));
savepath;
if ispref('launchpad')
	rmpref('launchpad');
end
addpref('launchpad','TargetRoot',curpath);
if isunix
	toolchain = questdlg('Are you using mspgcc or CCSv5 toolchain?',...
		'UNIX Toolchain Selection','mspgcc','CCSv5','mspgcc');
	if (strcmp(toolchain,'mspgcc'))
		%TODO Check return status
		[~,MSPGCC] = system('which msp430-gcc');
		addpref('launchpad','MSPGCC',MSPGCC);
	elseif (strcmp(toolchain,'CCSv5'))
		[CCSRoot, CompilerRoot] = ccs_setup_paths;
		addpref('launchpad','CCSRoot',CCSRoot);
		addpref('launchpad','CompilerRoot',CompilerRoot);
	else
		error('Wrong choice, exiting...');
	end
else
	[CCSRoot, CompilerRoot] = ccs_setup_paths;
	addpref('launchpad','CCSRoot',CCSRoot);
	addpref('launchpad','CompilerRoot',CompilerRoot);
end
cd('../blocks');
lct_genblocks;
cd(curpath);
end

function [CCSRoot, CompilerRoot] = ccs_setup_paths()
	% TODO: make it foolproof
	CCSRoot = uigetdir(matlabroot,'CCS root directory: (the one with ccs_base, tools ...)');
	CompilerRoot = uigetdir(CCSRoot,'CCS Compiler root directory: (tools/compiler/msp430_X.X.X)');
end