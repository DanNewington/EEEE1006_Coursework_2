function temp_monitor(a)
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    x=0;
    while x == 0 %allows the program to loop indefinitely
        volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
        temp = (volt - Volt0C)/tempCoef;
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
        elseif temp >= 18 && temp <= 24
            writeDigitalPin(a,"D2", 1); % Turn on the green LED
            pause(1)
            writeDigitalPin(a,"D2", 0); % Turn off the green LED
        end %all temps end with LEDs off so there is no overlap with which are on
    end
end
