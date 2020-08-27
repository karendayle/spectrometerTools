        %Pass in array of points
        myN = length(dataPoint)
        mySum = 0;
        for I = 1 : myN
            mySum = mySum + dataPoints(I);
        end
        % calculate average
        myAvg = mySum/myN;
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        for I = 1 : myN
            % 4. Add to the sum of the squares
            mySumSq = mySumSq + (dataPoints(I) - myAvg).^2; 
        end
        
        % 5. Compute standard deviation at each index of the averaged spectra 
        myStdDev = sqrt(mySumSq/myN);

        return [ myAvg myStdDev ]