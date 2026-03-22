function temp_prediction(a)
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    aimTime=0.1; %the time aimed for for a total cycle to reread temperature
    addt=0; %requires an inital value and in theory there should be no delay
    z=0; %has to initally be set to 0 so that the addition can be done in the loop correctly
    l = animatedline; %this was used to check the noise in the output
    ylim([-10 50])
    volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
    temps(1) = (volt - Volt0C)/tempCoef; %there needs to be a value in temps(1) for a later calculation, but this shouldn't be in the loop as it only needs to be done once
    for x = 2:inf %repeats the process indefinitely
        t=aimTime-addt; %calculates how long to pause to aim for a consistent temperature reading interval
        pause(t)
        tic %starts stopwatch
        volt = readVoltage(a, 'A0');
        temps(x) = (volt - Volt0C)/tempCoef;
        tempGrad(x) = (temps(x)-temps(x-1))/(aimTime); %the change in the time is t second as that is how often readings are taken
        z=z+1; %selects next spot available in array
        validGrads(z) = tempGrad(x); %tempoarily assigns this value into valid grads
        meanGrad = mean(tempGrad); %only uses correct data
        sigma = sqrt(var(validGrads([1 z]))); %uses statistics to find distribution
        if abs(abs(tempGrad(x))-abs(meanGrad)) > sigma %calculate if gradient is extreme - 1 sigma used as inflection point on bell curve
            tempPMin = meanGrad*60; %uses mean value if gradient is extreme
        else
            tempPMin = 60*tempGrad(x); %uses true value if within range
        end
        z=0;
        tempSigma = sqrt(var(tempGrad));
        for n = 1:x
            if abs(abs(tempGrad(x))-abs(meanGrad)) > tempSigma
                z=z+1;
                validGrads(z) = tempGrad(n); % Store valid gradients
            end
        end
        temp5Mins = 5*tempPMin + temps(x); %calculates the 5 min prediction
        sprintf("\n%s %f.2", "The change in temperature in C/s is ", tempGrad(x))
        if tempPMin > 4 %turns on red LED
            writeDigitalPin(a,'D7',1)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D2',0)
        elseif tempPMin < -4 % turns on yellow LED
            writeDigitalPin(a,'D4',1)
            writeDigitalPin(a,'D7',0)
            writeDigitalPin(a,'D2',0)
        else %turn on green LED
            writeDigitalPin(a,'D2',1)
            writeDigitalPin(a,'D4',0)
            writeDigitalPin(a,'D7',0)
        end
        addpoints(l,x,temp5Mins) %used for checking noise
        refreshdata
        drawnow
        sprintf("\n%s %f.2 %s","The temperature now is ", temps(x), "C")
        sprintf("\n%s %f.2 %s","The temperature in 5 mins will be ", temp5Mins, "C")
        addt = toc();
    end
end