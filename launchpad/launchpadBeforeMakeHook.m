function [ ] = launchpadBeforeMakeHook( modelName )

% Check the model if a target_paths.mk should be created
if (strcmp(get_param(modelName,'SystemTargetFile')  ,'launchpad.tlc') && ...
        strcmp(get_param(modelName,'TemplateMakefile')  ,'launchpad_tmf') && ...
        strcmp(get_param(modelName,'TargetHWDeviceType'),'Texas Instruments->MSP430'))
    
    TargetRoot = getpref('launchpad','TargetRoot');
    if isunix
        if (ispref('launchpad','MSPGCC'))
            % Only if mspgcc toolchain was chosen for UNIX
            MSPGCC = getpref('launchpad','MSPGCC');
        elseif (ispref('launchpad','CCSRoot'))
            % CCSv5
            CompilerRoot = getpref('launchpad','CompilerRoot');
            CCSRoot = getpref('launchpad','CCSRoot');
        end
        
        % Create the target paths makefile
        makefileName = 'target_paths_unix.mk';
        fid = fopen(makefileName,'w');
        fwrite(fid, sprintf('%s\n\n', '# launchpad paths'));
        if exist('MSPGCC','var')
            fwrite(fid, sprintf('MSPGCC  = %s\n', MSPGCC));
        end
        if exist('CCSRoot','var')
            fwrite(fid, sprintf('CompilerRoot  = %s\n', CompilerRoot));
            fwrite(fid, sprintf('CCSRoot       = %s\n', CCSRoot));
        end
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
    
    % For static code metrics this needs to be in the buildinfo object.
    makertwObj = rtwprivate('get_makertwsettings',modelName,'BuildInfo');
    addDefines(makertwObj, '-D__MSP430G2553__', 'OPTS');
    if (isunix && ispref('launchpad','MSPGCC'))
        addIncludePaths(makertwObj, ['/usr/msp430/include']);
    else
        addIncludePaths(makertwObj, [CCSRoot,'/ccs_base/msp430/include']);
    end
end
