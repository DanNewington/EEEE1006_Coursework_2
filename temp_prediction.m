function temp_prediction(a)
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
    temps(1) = (volt - Volt0C)/tempCoef; %there needs to be a value in temps(1) for a later calculation, but this shouldn't be in the loop as it only needs to be done once
    for x = 2:inf
        pause(1)
        volt = readVoltage(a, 'A0');
        temps(x) = (volt - Volt0C)/tempCoef;
        tempGrad(x) = (temps(x)-temps(x-1))/1; %the change in the time is 1 second as that is how often readings are taken
        tempPMin = tempGrad*60; %calculates the change per minute for use of LEDs
        sprintf("\n%s %f.2", "The change in temperature in C/s is ", tempGrad)
        if tempPMin > 4
            writeDigitalPin(a,'D7',1)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D2',0)
        elseif tempPMin <-4
            writeDigitalPin(a,'D4',1)
            writeDigitalPin(a,'D7',0)
            writeDigitalPin(a,'D2',0)
        else
            writeDigitalPin(a,'D2',1)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D7',0)
        end
        temp5Mins = 300*tempGrad(x) + temps(x);
        sprintf("\n%s %f.2 %s","The temperature now is ", temps(x), "C")
        sprintf("\n%s %f.2 %s","The temperature in 5 mins will be ", temp5Mins, "C")
    end
end