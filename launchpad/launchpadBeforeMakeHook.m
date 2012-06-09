function [ ] = launchpadBeforeMakeHook( modelName )

% Check the model if a target_paths.mk should be created
if (strcmp(get_param(modelName,'SystemTargetFile')  ,'launchpad.tlc') && ...
    strcmp(get_param(modelName,'TemplateMakefile')  ,'launchpad_tmf') && ...
    strcmp(get_param(modelName,'TargetHWDeviceType'),'Texas Instruments->MSP430'))

    TargetRoot = getpref('launchpad','TargetRoot');
if isunix
	MSPGCC = getpref('launchpad','MSPGCC');
	
	% Create the target paths makefile
    makefileName = 'target_paths_unix.mk';
    fid = fopen(makefileName,'w');
    fwrite(fid, sprintf('%s\n\n', '# launchpad paths'));
    fwrite(fid, sprintf('MSPGCC  = %s\n', MSPGCC));
    fwrite(fid, sprintf('TargetRoot    = %s\n', TargetRoot));
    fclose(fid);
else
	CompilerRoot = getpref('launchpad','CompilerRoot');
    CCSRoot = getpref('launchpad','CCSRoot');
    
    % Create the target paths makefile
    makefileName = 'target_paths.mk';
    fid = fopen(makefileName,'w');
    fwrite(fid, sprintf('%s\n\n', '# launchpad paths'));
    fwrite(fid, sprintf('CompilerRoot  = %s\n', CompilerRoot));
    fwrite(fid, sprintf('TargetRoot    = %s\n', TargetRoot));
    fwrite(fid, sprintf('CCSRoot       = %s\n', CCSRoot));
    fclose(fid);
end

end
 