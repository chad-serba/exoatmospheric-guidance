function [ newTimeVec ] = utc_time( startTimeVec, secondsSince )
%UTC_TIME Takes a starting UTC time vector and adds the elapsed seconds to
%get out a new UTC time vector
%   startTimeVec - baseline time vector [year month day hour minute second]
%   secondsSince - number of seconds since startTimeVec

    days = 0;
    hours = 0;
    minutes = 0;
    seconds = 0;
    
    if secondsSince >= 86400
        days = floor(secondsSince / 86400);
        secondsSince = secondsSince - days*86400;
    end
    
    if secondsSince >= 3600
        hours = floor(secondsSince / 3600);
        secondsSince = secondsSince - hours*3600;
    end
    
    if secondsSince >= 60
        minutes = floor(secondsSince / 60);
        secondsSince = secondsSince - minutes*60;
    end
    
    seconds = secondsSince;
    
    newTimeVec = startTimeVec + [0 0 days hours minutes seconds];
    
end

