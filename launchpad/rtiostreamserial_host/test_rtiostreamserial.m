%% Rebuild library
system(['make CFLAGS="-I',matlabroot,'/extern/include"']);
libname = [pwd,'/librtiostreamserial.so'];
%% Unload library
rtiostream_wrapper(libname,'unloadlibrary');
%% Prepare
%Use socat to create a pair of virtual serial ports:
%socat -d -d pty,raw,echo=0 pty,raw,echo=0
%Otherwise, use the USB-Serial adapter with loopback jumper.
%Using socat or hardware connection? Change as necessary.
socat = 1;
baud = '115200';
if socat
    con_port = 'pts/3';
    con2_port = 'pts/4';
else
    con_port = 'ttyACM0';
end
%% Open connection for sending
con = rtiostream_wrapper(libname,'open','-port',con_port,'-baud',baud);
%% Write to serial
payload = ['Hello, World!',10,13];
[res_write, size_sent] = rtiostream_wrapper(libname,'send',con,uint8(payload),length(payload));
%% Read from serial
%disp(['Now go ahead and write something to serial port, i''ll try to read ',num2str(length(payload)),' bytes']);
if socat
    con2 = rtiostream_wrapper(libname,'open','-port',con2_port,'-baud',baud);
    [res_read, data_read, size_recv] = rtiostream_wrapper(libname,'recv',con2,length(payload));
else
    [res_read, data_read, size_recv] = rtiostream_wrapper(libname,'recv',con,length(payload));
end
%% Close connection
if socat
    res2 = rtiostream_wrapper(libname,'close',con2);
end
res = rtiostream_wrapper(libname,'close',con);

if (size_sent == size_recv && strcmp(payload,char(data_read)))
    disp('Test was a success!');
else
    disp('Test has failed!');
end