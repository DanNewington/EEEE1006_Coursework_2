%This function calculates a predictoin for the temperature in the future by
%calculating the current rate of temperature change. This is the filtered
%using statistical distribution to see if the calculated value falls in the
%expected range or if it would be erroneous. Specific LEDs will also
%illuminate based on the rate per minute.
function temp_prediction(a)
    Volt0C  = 0.5; %given specifications for the thermistor
    tempCoef = 0.01;
    aimTime=0.1; %the time aimed for for a total cycle to reread temperature
    addt=0; %requires an inital value and in theory there should be no delay
    z=0; %has to initally be set to 0 so that the addition can be done in the loop correctly
    %l = animatedline; %this was used to check the noise in the output
    %ylim([-10 50]) %limits axis of graph that was used to see noise
    volt = readVoltage(a, 'A0'); %reads voltage from the thermistor
    temps(1) = (volt - Volt0C)/tempCoef; %there needs to be a value in temps(1) for a later calculation, but this shouldn't be in the loop as it only needs to be done once
    for x = 2:inf %repeats the process indefinitely
        t=aimTime-addt; %calculates how long to pause to aim for a consistent temperature reading interval
        pause(t) %holds the program to limit the rate of readings
        tic %starts stopwatch
        volt = readVoltage(a, 'A0'); 
        temps(x) = (volt - Volt0C)/tempCoef; %finding the temperature
        tempGrad(x) = (temps(x)-temps(x-1))/(aimTime); %the change in the time is t second as that is how often readings are taken
        z=z+1; %selects next spot available in array
        validGrads(z) = tempGrad(x); %tempoarily assigns this value into valid grads
        meanGrad = mean(tempGrad); %finds the average rate of change, grad will mean rate in variable/array names
        validSigma = sqrt(var(validGrads([1 z]))); %uses statistics to find distribution
        if abs(abs(tempGrad(x))-abs(meanGrad)) > validSigma %calculate if gradient is extreme - 1 sigma used as inflection point on bell curve
            tempPMin = meanGrad*60; %uses mean value if gradient is extreme
        else
            tempPMin = 60*tempGrad(x); %uses true value if within range
        end
        z=0;
        tempSigma = sqrt(var(tempGrad)); %calculates spread of data to use for verifying which values are valid or too extreme
        for n = 1:x
            if abs(abs(tempGrad(x))-abs(meanGrad)) > tempSigma %runs code if it is valid
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
        %addpoints(l,x,temp5Mins) %creates graph used for checking noise
        %refreshdata
        %drawnow
        sprintf("\n%s %f.2 %s","The temperature now is ", temps(x), "C")
        sprintf("\n%s %f.2 %s","The temperature in 5 mins will be ", temp5Mins, "C")
        addt = toc(); %find how long code takes to alter time paused earleir
    end
end