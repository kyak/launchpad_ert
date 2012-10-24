classdef ConnectivityConfig < rtw.connectivity.Config
%CONNECTIVITYCONFIG is TI LaunchPad PIL configuration class

    methods
        % Constructor
        function this = ConnectivityConfig(componentArgs)
            
            % An executable framework specifies additional source files and
            % libraries required for building the PIL executable
            targetApplicationFramework = ...
                launchpad.TargetApplicationFramework(componentArgs);
            
            % Filename extension for executable on the target system (e.g.
            % '.exe' for Windows or '' for Unix

            exeExtension = '.out';
            
            % Create an instance of MakefileBuilder; this works in
            % conjunction with our template makefile to build the PIL
            % executable
            builder = rtw.connectivity.MakefileBuilder(componentArgs, ...
                targetApplicationFramework, ...
                exeExtension);
            
            % Launcher
            launcher = launchpad.Launcher(componentArgs, builder);
            
            % File extension for shared libraries (e.g. .dll on Windows)
            sharedLibExt=system_dependent('GetSharedLibExt'); 

            % Evaluate name of the rtIOStream shared library
            if isunix
                if verLessThan('matlab', '8.0')
                    prefix = [getpref('launchpad','TargetRoot'),'/rtiostreamserial_host/lib'];
                else
                    %Use shipped host implementation starting from R2012b
                    prefix='libmw';
                end
            else
                prefix='libmw';
            end
            rtiostreamLib = [prefix 'rtiostreamserial' sharedLibExt];
            
            hostCommunicator = launchpad.Communicator(...
                componentArgs, ...
                launcher, ...
                rtiostreamLib);
            
            % For some targets it may be necessary to set a timeout value
            % for initial setup of the communications channel. For example,
            % the target processor may take a few seconds before it is
            % ready to open its side of the communications channel. If a
            % non-zero timeout value is set then the communicator will
            % repeatedly try to open the communications channel until the
            % timeout value is reached.
            hostCommunicator.setInitCommsTimeout(0); 
            
            % Configure a timeout period for reading of data by the host 
            % from the target. If no data is received with the specified 
            % period an error will be thrown.
            timeoutReadDataSecs = 30;
            hostCommunicator.setTimeoutRecvSecs(timeoutReadDataSecs);
            
            % Set up COM port used for PIL communication                                           
            portNumStr = getpref('launchpad','COMPort');

            % Custom arguments that will be passed to the              
            % rtIOStreamOpen function in the rtIOStream shared        
            % library (this configures the host-side of the           
            % communications channel)                                  
            rtIOStreamOpenArgs = {...                                  
                '-baud', '2400', ...                                  
                '-port', portNumStr,...                                 
                };                                                     
                      
            hostCommunicator.setOpenRtIOStreamArgList(...          
                rtIOStreamOpenArgs); 
            
            % call super class constructor to register components
            this@rtw.connectivity.Config(componentArgs,...
                                         builder,...
                                         launcher,...
                                         hostCommunicator);
            
            % Optionally, you can register a hardware-specific timer. Registering a timer
            % enables the code execution profiling feature. In this example
            % implementation, we use a timer for the host platform.
            timer = launchpad.Timer;
            this.setTimer(timer);
            
        end
    end
end

