function cordic_fxp
% see also web([docroot '/fixedpoint/ug/creating-lookup-tables-for-a-sine-function.html'])
mdl = 'tilp_fxp';
mdlref = 'tilp_pil_fxp';
evalin('base','cordic = 1;');
trig_block = [mdlref,'/Variant/cordic/Trigonometric Function'];
open_system(mdl);
open_system(mdlref);
range=(8:16);
for i=range
    disp(i);
    set_param(trig_block,'NumberOfIterations',num2str(i));
    save_system(mdlref);
    sim(mdl);
    sine_error = rms(logsout.getElement('sine').Values.Data-logsout.getElement('sine_ideal').Values.Data);
    executionProfile = evalin('base','executionProfile');
    execution_time = executionProfile.Sections(2).ExecutionTimeInSeconds;
    sine_errors(i) = sine_error;
    execution_times(i) = mean(execution_time);
    [memoryUsed, RAMUsed] = getMemUsage(mdlref);
    memoryUseds(i) = memoryUsed;
    RAMUseds(i) = RAMUsed;
end

evalin('base','cordic = 0;');
trig_block = [mdlref,'/Variant/table/1-D Lookup Table'];

%errmax=[2^-1, 2^-2, 2^-3, 2^-4, 2^-5, 2^-6];
nptsmax=[8, 14, 26, 27, 52];
j = 1;
%for i=errmax
for i=nptsmax
    disp(i);
    %[xdata, ydata, lut_size] = fix_sine(i,[]); %for errmax
    [xdata, ydata, lut_size] = fix_sine([],i); %for nptsmax
    set_param(trig_block,'BreakpointsForDimension1',mat2str(xdata));
    set_param(trig_block,'Table',mat2str(ydata));
    save_system(mdlref);
    sim(mdl);
    sine_error = rms(logsout.getElement('sine').Values.Data-logsout.getElement('sine_ideal').Values.Data);
    executionProfile = evalin('base','executionProfile');
    execution_time = executionProfile.Sections(2).ExecutionTimeInSeconds;
    sine_errorsLUT(j) = sine_error;
    lut_sizes(j) = lut_size;
    execution_timesLUT(j) = mean(execution_time);
    [memoryUsed, RAMUsed] = getMemUsage(mdlref);
    memoryUsedsLUT(j) = memoryUsed;
    RAMUsedsLUT(j) = RAMUsed;
    j = j+1;
end


% plot(range,sine_errors(range));
% title('RMS');
% figure;
% plot(range,execution_times(range));
% title('Execution Time');
% figure;
% plot(range,memoryUseds(range));
% title('FLASH Used');
% figure;
% plot(range,RAMUseds(range));
% title('RAM Used');
out = table(double(sine_errors(range)'),execution_times(range)',memoryUseds(range)',RAMUseds(range)','VariableNames',{'RMSerror','ExecutionTime','FlashUsed','RAMused'},'RowNames',regexp(sprintf('CORDIC-%d ',range),'[a-zA-Z_-0-9]*','match'));
out1 = table(double(sine_errorsLUT'),execution_timesLUT',memoryUsedsLUT',RAMUsedsLUT','VariableNames',{'RMSerror','ExecutionTime','FlashUsed','RAMused'},'RowNames',regexp(sprintf('LUT-%d(%d) ',[lut_sizes;nptsmax]),'[a-zA-Z_\-\.()0-9]*','match'));
%out1 = table(double(sine_errorsLUT'),execution_timesLUT',memoryUsedsLUT',RAMUsedsLUT','VariableNames',{'RMSerror','ExecutionTime','FlashUsed','RAMused'},'RowNames',regexp(sprintf('LUT-%d(%f) ',[lut_sizes;errmax]),'[a-zA-Z_\-\.()0-9]*','match'));
disp(out);
disp(out1);
end

function [memoryUsed, RAMUsed] = getMemUsage(mdlref)
CodeGenFolder = Simulink.fileGenControl('getConfig').CodeGenFolder;
mapFile = fullfile(CodeGenFolder,'slprj','launchpad',mdlref,'pil',[mdlref,'.map']);
mapFileContents = fileread(mapFile);
memoryHexString = cell2mat(regexp(mapFileContents,'FLASH(.*?)RWIX','tokens','once'));
memoryHexValues = sscanf(memoryHexString, '%x%x%x%x');
memoryUsed   = memoryHexValues(3);
RAMHexString = cell2mat(regexp(mapFileContents,'RAM(.*?)RWIX','tokens','once'));
RAMHexValues = sscanf(RAMHexString, '%x%x%x%x');
RAMUsed   = RAMHexValues(3);
end