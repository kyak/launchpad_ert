function launchpad_download(modelName,makertwObj)

disp(['### Downloading ', modelName, ' to LaunchPad...']);

TargetRoot = getpref('launchpad','TargetRoot');
if isunix
	%TODO - catch errors in which
	%TODO - which returns trailing newline, heh..
	%[~,MSPDEBUG] = system('which mspdebug');
else
	CCSRoot = getpref('launchpad','CCSRoot');
end

%assignin('base','makertwObj',makertwObj);
%TODO: parse the PROGRAM_FILE_EXT from target_tools.mk
if (ischar(makertwObj)) %String 'PIL'
	outfile = modelName;
else
    outfile = [modelName, '.out'];
	%outfile = fullfile(makertwObj.BuildDirectory, [modelName, '.out']);
end
if isunix
	system(['mspdebug rf2500 ''prog ',outfile,'''']);
    if (ischar(makertwObj)) %Stupid workaround for PIL
        %system(['jpnevulator --tty /dev/',getpref('launchpad','COMPort'),':SB2400d --write 2>&1 > /dev/null &']);
        %con = rtiostream_wrapper('libmwrtiostreamserial.so','open','-port','ttyACM0','-baud','2400');
		%stty 2400 -F .. might help?? Try it..
    end
else
	%system(['"',CCSRoot,'/ccs_base/scripting/bin/trace_dss.bat" ',...
    %	'"',matlabroot,'/toolbox/idelink/extensions/ticcs/ccsdemos/runProgram.js" ',...
    system(['"',CCSRoot,'/ccs_base/scripting/examples/loadti/loadti.bat" -a ',...
		'-c "',TargetRoot,'/MSP430G2553.ccxml" ',...
		'"',outfile,'"']);
end

end