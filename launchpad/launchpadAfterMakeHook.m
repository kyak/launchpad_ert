function [ ] = launchpadAfterMakeHook( modelName )
% Check the model if a target_paths.mk should be created
if (strcmp(get_param(modelName,'SystemTargetFile')  ,'launchpad.tlc') && ...
    strcmp(get_param(modelName,'TemplateMakefile')  ,'launchpad_tmf') && ...
    strcmp(get_param(modelName,'TargetHWDeviceType'),'Texas Instruments->MSP430'))
  
    % Check if user chose to Download to Launchpad in Settings
    makertwObj = get_param(gcs, 'MakeRTWSettingsObject');
    makertwArgs = makertwObj.BuildInfo.BuildArgs;
    downloadToLaunchPad = 1;
    for i=1:length(makertwArgs)
        if strcmp(makertwArgs(i).DisplayLabel,'LAUNCHPAD_DOWNLOAD')
            downloadToLaunchPad = str2double(makertwArgs(i).Value);
        end
    end
    
    % allow a back door for tests to skip download to hardware
    if evalin('base','exist(''downloadToLaunchPad'')')
        downloadToLaunchPad = evalin('base', 'downloadToLaunchPad' );
    end
    
    if ~i_isPilSim && ~i_isModelReferenceBuild(modelName) &&...
            downloadToLaunchPad
        i_download(modelName,makertwObj)
    end

end

end

function isPilSim = i_isPilSim
    s = dbstack;
    isPilSim = false;
    for i=1:length(s)
        if strfind(s(i).name,'build_pil_target')
            isPilSim=true;
            break;
        end
    end
end
    
function isMdlRefBuild = i_isModelReferenceBuild(modelName)
    mdlRefTargetType = get_param(modelName, 'ModelReferenceTargetType');
    isMdlRefBuild = ~strcmp(mdlRefTargetType, 'NONE');
end

function i_download(modelName,makertwObj)

disp(['### Downloading ', modelName, ' to LaunchPad...']);

TargetRoot = getpref('launchpad','TargetRoot');
if isunix
	%TODO - move to launchpad_setup.m?
	%TODO - catch errors in which
	%TODO - which returns trailing newline, heh..
	%[~,MSPDEBUG] = system('which mspdebug');
else
	CCSRoot = getpref('launchpad','CCSRoot');
end

%assignin('base','makertwObj',makertwObj);
%TODO: parse the PROGRAM_FILE_EXT from target_tools.mk
outfile = fullfile(makertwObj.BuildDirectory, [modelName, '.out']);
if isunix
	system(['mspdebug rf2500 ''prog ',outfile,'''']);
else
	system(['"',CCSRoot,'/ccs_base/scripting/bin/trace_dss.bat" ',...
		'"',matlabroot,'/toolbox/idelink/extensions/ticcs/ccsdemos/runProgram.js" ',...
		'"',TargetRoot,'/MSP430G2553.ccxml" ',...
		'"',outfile,'"']);
end

end