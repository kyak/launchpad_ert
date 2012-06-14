function launchpad_setup()

curpath = pwd;
tgtpath = curpath(1:end-length('\launchpad'));
addpath(fullfile(tgtpath, 'launchpad'));
addpath(fullfile(tgtpath, 'blocks'));
cd('../blocks');
lct_genblocks;
savepath;
if ispref('launchpad')
	rmpref('launchpad');
end
addpref('launchpad','TargetRoot',curpath);
if isunix
	%TODO Check return status
	[~,MSPGCC] = system('which msp430-gcc');
	addpref('launchpad','MSPGCC',MSPGCC);
else
	addpref('launchpad','CompilerRoot','c:\CCSv5\ccsv5\tools\compiler\msp430_4.1.0');
	addpref('launchpad','CCSRoot','c:\CCSv5\ccsv5');
end
