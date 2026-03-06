% Dan Newington
% eeydn3@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
clear

a = arduino;
for x = 1:10 %repeats the flash 10 times
    writeDigitalPin(a,'D4',1) %turns onto high power
    pause(0.5)
    writeDigitalPin(a,'D4',0) %turns off
    pause(0.5)
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear

a = arduino;
duration = 600;
volts = zeros(1,duration+1);
temps = zeros(1,duration+1);
Volt0C  = 0.5;
tempCoef = 0.01;

for x = 1:(duration+1) %plus one so that 600 values are taken, 
    volts(x) = readVoltage(a, 'A0'); %reads voltage from the thermistor
    temps(x) = (volts(x) - Volt0C)/tempCoef;
    pause(1)
end
minTemp = min(temps);
maxTemp = max(temps);
meanTemp = mean(temps);

plot(temps)
xlabel('Time (seconds)')
ylabel('Temperature (C)')
xlim([0 600])

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% No need to enter any answers here, please answer on the .docx template.


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answers here, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.