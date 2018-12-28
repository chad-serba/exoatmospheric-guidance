function [ next_x ] = propagate_orbit_const_accel( curr_x, accel, direction, step ) %#codegen
%PROPAGATE_ORBIT_CONST_ACCEL propogates a constant-acceleration orbital
%maneuver.
%   INPUTS:
%       curr_x: the current state
%       accel: the acceleration of the vehicle
%       direction: the direction of the acceleration, in inertial
%                  coordinate system
%       step: the size of the integration step


%     % make sure x is in the correct shape
%     flip_x = 0;
%     if all( size(curr_x) == [1 7] )
%         curr_x = curr_x';
%         flip_x = 1;
%     end
    
    % constants 
    mu = 3.986004418e14; %m^3 / s^2
    
    % intermediate variable 
    r = sqrt( curr_x(1:3)' * curr_x(1:3) );
    
    % ensure that the direction vector is a unit vector
    direction = direction / norm(direction);
    
    % get xdot
    xdot = [curr_x(4); ... % x velocity
            curr_x(5); ... % y velocity
            curr_x(6); ... % z velocity
          (-mu*curr_x(1)/r^3) + accel*direction(1); ... % x acceleration
          (-mu*curr_x(2)/r^3) + accel*direction(2); ... % y acceleration
          (-mu*curr_x(3)/r^3) + accel*direction(3); ... % z acceleration
            1]; % time
    
    % implement euler integration
    next_x = curr_x + xdot * step;
        
%     if flip_x
%         next_x = next_x';
%     end
end

