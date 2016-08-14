function [ output ] = interpolate_measurements( loam )
%INTERPOLATE_MEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here
    format long;
    FREQUENCY = 2;
    
    seconds_converter = 10^6;
    
    interpolation_period = FREQUENCY * seconds_converter; % every 2 seconds we will get a measurement    
    
    output = [];
    % iterate from 0, every 2  seconds( frequency) until the end of loam seconds, for 
    for i = 2:FREQUENCY:loam(end,1)/seconds_converter
        begin_index = find(loam(:,1)<((i-1)*seconds_converter),1, 'last'); % the index of the number less than the interpolation period
        a = loam(begin_index,:); % a - start of the interpolation
        % find the measurement right after the current period
        end_index = find(loam(:,1)>(i*seconds_converter),1); % the index of the first seen number bigger then the interpolation period
        b = loam(end_index,:); % b - end of the interpolation
        
        % now we have the first and the last element, time to interpolate
        % the position and slerp the orientation
        output(i/2, 1) = i*10^6;
        
        % time, how close to measurement
        t = ((i*10^6) - a(1,1)) / (b(1,1)-a(1,1));
        
        output(i/2, 2) = a(1,2)+(b(1,2) - a(1,2))*t; % retrieve the new x
        output(i/2, 3) = a(1,3)+(b(1,3) - a(1,3))*t; % retrieve the new y
        output(i/2, 4) = a(1,3)+(b(1,4) - a(1,4))*t; % retrieve the new z
        
        % orientation
        if size(a,2) > 4
            output(i/2, 5:8) = slerp(a(1,5:8)', b(1,5:8)', t);        
        else
            output(i/2, 5:8) = [0,0,0,0];
        end
        
        
    end
end

