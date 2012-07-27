classdef Launcher < rtw.connectivity.Launcher
%LAUNCHER is TI LaunchPad class for launching a PIL application
 
    methods
        % constructor
        function this = Launcher(componentArgs, builder)
            narginchk(2, 2);
            % call super class constructor
            this@rtw.connectivity.Launcher(componentArgs, builder);
        end

        % destructor
        function delete(this) %#ok
        end

        % Start the application
        function startApplication(this)
            % get name of the executable file
            exe = this.getBuilder.getApplicationExecutable; 
			launchpad_download(exe,'PIL');
			disp('### Starting PIL execution on TI LaunchPad');
        end
        
        % Stop the application
        function stopApplication(~)
            disp('### Stopping PIL execution on TI launchPad')
        end
    end
end
