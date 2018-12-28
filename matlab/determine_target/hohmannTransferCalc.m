function [ dv1, dv2 ] = hohmannTransferCalc( startOrb, endOrb )
%HOMMANTRANSFERCALC calculate the two delta-Vs of a Hommann Transfer
%   startOrb - semi-major axis of starting circular orbit (meters)
%   endOrb - semi-magor axis of final circular orbit (meters)

    %%%%%%%%%%%%%
    % CONSTANTS %
    %%%%%%%%%%%%%
    mu = 3.986004418E14; % earth's gravitational constant (m^3 / s^2)
    
    
    at = (startOrb + endOrb) / 2; % find transfer orbit semi-major axis
    et = 1 - startOrb / at; % find transfer orbit eccentricity
    
    % calculate the delta-v for each burn
    dv1 = sqrt( (mu / at) * ( (1+et) / (1-et) ) ) - sqrt( mu / startOrb );
    dv2 = sqrt( mu / endOrb ) - sqrt( (mu / at) * ( (1-et) / (1+et) ) );

%     dv1 = sqrt(mu / startOrb) * ( sqrt(2*endOrb / (startOrb + endOrb)) - 1 );
%     dv2 = sqrt(mu / endOrb) * ( 1 - sqrt(2*startOrb / (startOrb + endOrb)) );

end

