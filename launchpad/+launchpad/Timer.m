classdef Timer < coder.profile.Timer
    methods
        function this = Timer
            
            % Configure data type returned by timer reads
            this.setTimerDataType('uint16');
            
            % What returns profileTimerRead() function
            % see ConfigClocks() at rtiostreamserial.c
            ticksPerSecond = 1.25e5;
            this.setTicksPerSecond(ticksPerSecond);
            
            % The timer counts upwards
            this.setCountDirection('up');
            
            % Configure source files required to access the timer
            timerSourceFile = fullfile(getpref('launchpad','TargetRoot'),...
                'launchpad_timer.c');
            
            headerFile = fullfile(getpref('launchpad','TargetRoot'),...
                'launchpad_timer.h');
            
            this.setSourceFile(timerSourceFile);
            this.setHeaderFile(headerFile);
            
            % Configure the expression used to read the timer
            readTimerExpression = 'profileTimerRead()';
            this.setReadTimerExpression(readTimerExpression);
        end
    end
end
