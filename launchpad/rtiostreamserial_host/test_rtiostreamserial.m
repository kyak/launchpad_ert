%% Rebuild library
system(['make CFLAGS="-I',matlabroot,'/extern/include"']);
%% Unload library
rtiostream_wrapper([pwd,'/librtiostreamserial.so'],'unloadlibrary');
%% Prepare
%Use socat to create a pair of virtual serial ports:
%socat -d -d pty,raw,echo=0 pty,raw,echo=0
%Otherwise, use the USB-Serial adapter with loopback jumper.
%% Open connection
con = rtiostream_wrapper([pwd,'/librtiostreamserial.so'],'open','-port','ttyACM0','-baud','2400');
%% Write to serial
payload = ['Hello, World!',10,13];
[res_write, size_sent] = rtiostream_wrapper([pwd,'/librtiostreamserial.so'],'send',con,uint8(payload),length(payload));
%% Read from serial
%disp(['Now go ahead and write something to serial port, i''ll try to read ',num2str(length(payload)),' bytes']);
[res_read, data_read, size_recv] = rtiostream_wrapper([pwd,'/librtiostreamserial.so'],'recv',con,length(payload));
%% Close connection
res = rtiostream_wrapper([pwd,'/librtiostreamserial.so'],'close',con);

if (size_sent == size_recv && strcmp(payload,char(data_read)))
    disp('Test was a success!');
else
    disp('Test has failed!');
end