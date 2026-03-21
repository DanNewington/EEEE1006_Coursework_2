%This function runs indefinitely and tracks the temperature overtime.
%It plots an updating graph as the temperature is read every second.
%It also has LEDs which illuminate based off of different temperature
%conditions to indicate the temperature range.
function temp_monitor(a)
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    x=0;
    t=0;
    temps = animatedline;
    xlabel('Time (seconds)')
    ylabel('Temperature (C)')
    title("Time (s) vs Temperature (C)")
    while x == 0 %allows the program to loop indefinitely
        volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
        temp = (volt - Volt0C)/tempCoef;
        addpoints(temps,t,temp)
        refreshdata
        drawnow
        if temp > 24 %checks temp value and completes LED cycle
            for k = 1:2 %does this twice to last for a second
                writeDigitalPin(a,'D7',1)
                pause(0.25)
                writeDigitalPin(a,'D7',0)
                pause(0.25)
            end
        elseif temp < 18
            writeDigitalPin(a,'D4',1)
            pause(0.5)
            writeDigitalPin(a,'D4',0)
            pause(0.5) %lasts for 1 second total
        else
            writeDigitalPin(a,"D2", 1); % Turn on the green LED
            pause(1)
            writeDigitalPin(a,"D2", 0); % Turn off the green LED
        end %all temps end with LEDs off so there is no overlap with which are on
        t=t+1; %a second will have passed at the end of this loop
    end
end
