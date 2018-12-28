function [ g ] = guid_compute_grav_vec( position )
%GUID_COMPUTE_GRAV_VEC computes the gravity vector at a given orbital
%position
%   the returned direction vector is in an ECI frame

    % constant mu for earth
    mu = 3.986004418e14; %m^3 / s^2
    
    % intermediate calc
    R = norm(position);
    
    % calculate the acceleration due to gravity
    g = [ -mu*position(1) / R^3; ...
          -mu*position(2) / R^3; ...
          -mu*position(3) / R^3];
      
    % normalize to be just direction vector
    g = g / norm(g);
    
end

