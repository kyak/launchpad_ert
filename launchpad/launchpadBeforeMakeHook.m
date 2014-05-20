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
    buildInfo = rtwprivate('get_makertwsettings',modelName,'BuildInfo');
    addDefines(buildInfo, '-D__MSP430G2553__', 'OPTS');
    addIncludePaths(buildInfo, fullfile(TargetRoot, 'code_metrics'));
    if (isunix && ispref('launchpad','MSPGCC'))
        addIncludePaths(buildInfo, '/usr/msp430/include');
        addDefines(buildInfo, '-DMSPGCC', 'OPTS');
    else
        addIncludePaths(buildInfo, [CCSRoot,'/ccs_base/msp430/include']);
    end
    
    % When static code metrics is enabled, it is not enough to remove the
    % main_MODEL.c from TMF, which i did (see how i mangle the PREBUILT_SRCS in
    % TMF). With static code metrics + Top model PIL, i get the error from
    % static code analyzer:
    %
    % Function 'main' is defined multiple times in pil_main.c, main_MODEL.c.
    %
    % Removing main_MODEL.c from sources (see remSourceFiles in Stellaris
    % target) is also not enough - at least at this stage (perhaps it would work
    % at PostCodeGen). The main_MODEL.c has found its way into |>MODEL_SOURCES<|
    % token by this stage, and removing it from there doesn't help either.
    %
    % Deleting main_MODEL.c is a bad idea, because Embedded Coder starts
    % complaining about missing files. So i just empty the file.
    %
    % TODO: Of course, this should be done somehow in main.tlc. The problem is
    % how to detect PIL mode from within TLC (similar to detection of Model
    % Reference build).
    
    fname = ['main_',modelName,'.c'];
    if i_isPIL(buildInfo) && exist(fname,'file')
        % Dummy main_MODEL.c file
        csvwrite(fname,[]);
    end
end
end


function isPIL = i_isPIL(buildInfo)
buildOpts = rtwprivate('get_makertwsettings',buildInfo.ModelName,'BuildOpts');
isPIL = buildOpts.XilInfo.IsPil;
end
