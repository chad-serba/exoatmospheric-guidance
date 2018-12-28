function [ nu ] = calc_targeted_nu( r_tf, r_p, v_p )
%CALC_TARGETED_NU Determines the currently targeted orbital true anomaly.
%   INPUTS:
%       r_tf: radius at time of burn end (3 element vector)
%       r_p: radius at target orbit time of perigee (3 element vector)
%       v_p: velocity at target orbit time of perigee (3 element vector)
%   OUTPUTS:
%       nu: currently targeted true anomaly, degrees

    % quick error check
    if length(r_tf) ~= 3 || length(r_p) ~= 3 || length(v_p) ~= 3
        error('r_tf, r_p, v_p must all be 3-element vectors')
    end
    
    % normalize the perigee vectors
    r_p = r_p / norm(r_p);
    v_p = v_p / norm(v_p);
    
    % get the true anomaly in degrees.
    nu = atan2d( dot(r_tf, v_p), dot(r_tf, r_p) );
    
end

