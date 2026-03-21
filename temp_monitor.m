function temp_monitor(a)
    function greenGlow(a)
        writeDigitalPin(a,'D2',1)
    end
    function yellowFlash(a)
        x=0;
        while x==0
            writeDigitalPin(a,'D7',1)
            pause(0.5)
            writeDigitalPin(a,'D7',0)
            pause(0.5)
        end
    end
    function redFlash(a)
        x=0;
        while x==0
            writeDigitalPin(a,'D7',1)
            pause(0.5)
            writeDigitalPin(a,'D7',0)
            pause(0.5)
        end
    end
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    x=0;
    while x == 0 %allows the program to loop indefinitely
        volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
        temp = (volt - Volt0C)/tempCoef;
        if temp > 24 && r.State ~= "running" %if function is already running no need to rerun it
            cancel(y) %cancelling background funcations in the if statement means there is not any interuption if the same status is required as previous
            cancel(g) %cancels both as more efficient than checking which background funcion would be running
            writeDigitalPin(a,'D2',0) %ensures the other lights are off as they may have been left in an on state when the function was cancelled
            writeDigitalPin(a,'D4',0)
            r = parfeval(backgroundPool,@redFlash,0,a); %this allows the function to run in the background so the temperature can be checked as frequently as possible for the quickest updates
        elseif temp < 18 && y.State ~= "running"
            cancel(r)
            cancel(g)
            writeDigitalPin(a,'D2',0)
            writeDigitalPin(a,'D7',0)
            y = parfeval(backgroudPool,@yellowFlash,0,a);
        elseif temp >= 18 && temp <= 24 && g.State ~= "running"
            cancel(r)
            cancel(y)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D7',0)
            g = parfeval(backgroundPool,@greenGlow,0,a);
        end
    end
end
