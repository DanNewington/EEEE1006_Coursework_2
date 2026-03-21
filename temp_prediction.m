function temp_prediction(a)
    splot = animatedline;
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
    temps(1) = (volt - Volt0C)/tempCoef; %there needs to be a value in temps(1) for a later calculation, but this shouldn't be in the loop as it only needs to be done once
    for x = 2:inf
        pause(0.00000000001)
        volt = readVoltage(a, 'A0');
        temps(x) = (volt - Volt0C)/tempCoef;
        tempGrad(x) = (temps(x)-temps(x-1))/1; %the change in the time is 1 second as that is how often readings are taken
        meanGrad = mean(tempGrad);
        sigma = sqrt(var(tempGrad));
        if abs(abs(tempGrad(x))-abs(meanGrad)) > sigma %using statiscal distributions to calculate if gradient is an outlier - 1 sigma used as inflection point on bell curve
            tempPMin = meanGrad*60;
            tempGrad(x) = 0;
        else
            tempPMin = 60*tempGrad(x);
        end
        temp5Mins = 5*tempPMin + temps(x);
        sprintf("\n%s %f.2", "The change in temperature in C/s is ", tempGrad(x))
        if tempPMin > 4
            writeDigitalPin(a,'D7',1)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D2',0)
        elseif tempPMin < -4
            writeDigitalPin(a,'D4',1)
            writeDigitalPin(a,'D7',0)
            writeDigitalPin(a,'D2',0)
        else
            writeDigitalPin(a,'D2',1)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D7',0)
        end
        sprintf("\n%s %f.2 %s","The temperature now is ", temps(x), "C")
        sprintf("\n%s %f.2 %s","The temperature in 5 mins will be ", temp5Mins, "C")
    end
end