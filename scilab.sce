clear all
clc
 
// Load SOCKET Toolbox. 
exec(SCI+'contribsocket_toolbox_2.0.1loader.sce'); 
SOCKET_init();
 
// Define Red Pitaya as TCP/IP object
IP= '192.168.178.56';            // Input IP of your Red Pitaya...
port = 5000;                     // If you are using WiFi then IP is:               
tcpipObj='RedPitaya';            // 192.168.128.1
 
// Open connection with your Red Pitaya
 
SOCKET_open(tcpipObj,IP,port);
 
// Set decimation value (sampling rate) in respect to you 
// acquired signal frequency
 
SOCKET_write(tcpipObj,'ACQ:DEC 8');
 
// Set trigger level to 100 mV
 
SOCKET_write(tcpipObj,'ACQ:TRIG:LEV 0');
 
// Set trigger delay to 0 samples
// 0 samples delay set trigger to center of the buffer
// Signal on your graph will have trigger in the center (symmetrical)
// Samples from left to the center are samples before trigger 
// Samples from center to the right are samples after trigger
 
SOCKET_write(tcpipObj,'ACQ:TRIG:DLY 0');
 
//// Start & Trigg
// Trigger source setting must be after ACQ:START
// Set trigger to source 1 positive edge
 
SOCKET_write(tcpipObj,'ACQ:START');
SOCKET_write(tcpipObj,'ACQ:TRIG NOW');  
  
// Wait for trigger
// Until trigger is true wait with acquiring
// Be aware of while loop if trigger is not achieved
// Ctrl+C will stop code executing 
 
xpause(1E+6)
 
// Read data from buffer 
 
signal_str=SOCKET_query(tcpipObj,'ACQ:SOUR1:DATA:OLD:N? 800');
 
// Convert values to numbers.// First character in string is “{“  
// and 2 latest are empty spaces and last is “}”.  
signal_str=part(signal_str, 2:length(signal_str)-3)
signal_num=strtod(strsplit(signal_str,",",length(signal_str)))';
  
plot(signal_num)
 
SOCKET_close(tcpipObj);
