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
currentDate = datetime("today");
fmt = "dd/MM/yyyy";
dateNow = string(currentDate,fmt);

for x = 1:(duration+1) %plus one so that up to the required duration values are taken as the starting value is 1, not 0 
    volts(x) = readVoltage(a, 'A0'); %reads voltage from the thermistor
    temps(x) = (volts(x) - Volt0C)/tempCoef;
    pause(1)
end
minTemp = min(temps);
maxTemp = max(temps);
meanTemp = mean(temps);

plot(temps) %plots the graph
xlabel('Time (seconds)')
ylabel('Temperature (C)')
xlim([0 duration])

minFormat = "\n%-15s %-.0f \n"; %formatting for when the minutes line is output
tempFormat = "%-15s %-.2f %-3s\n"; %formatting for when the temperature line is output
sprintf("%s %s \n","Data logging initiated - ", dateNow)
sprintf("Location - Nottingham\n") %done from my accomodation at university
for x = 1:60:duration+1 %steps in every 60 seconds - 1min = 60 secs
    sprintf(minFormat, "Minute", (x-1)/60) %calculates the minute value
    sprintf(tempFormat, "Temperature", temps(x), " C") %displays temp value at that time
end
sprintf("\n" + tempFormat, "Max temp", maxTemp, " C") %similar formatting can be used
sprintf(tempFormat, "Min temp", minTemp, " C")
sprintf(tempFormat, "Average temp", meanTemp, " C")
sprintf("\nData logging terminated\n")

inputData = fopen("capsule_temperature.txt","w"); %similar formatting to put into text file
fprintf(inputData,"%s %s \n","Data logging initiated - ", dateNow);
fprintf(inputData,"Location - Nottingham\n");
for x = 1:60:duration+1
    fprintf(inputData,minFormat, "Minute", (x-1)/60);
    fprintf(inputData,tempFormat, "Temperature", temps(x), " C");
end
fprintf(inputData,"\n" + tempFormat, "Max temp", maxTemp, " C");
fprintf(inputData,tempFormat, "Min temp", minTemp, " C");
fprintf(inputData,tempFormat, "Average temp", meanTemp, " C");
fprintf(inputData,"\nData logging terminated");
fclose(inputData);

fileCheck = fopen("capsule_temperature.txt","r"); %opens the file in read mode and displays the contents to be checked
dataCheck = fileread("capsule_temperature.txt");
sprintf(string(dataCheck))
fclose(fileCheck);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear

a = arduino;
temp_monitor(a)
doc temp_monitor


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]
clear

%enter

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% No need to enter any answers here, please answer on the .docx template.


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answers here, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.