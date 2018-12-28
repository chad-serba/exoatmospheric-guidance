function [ dxdt ] = odefun( t, x, A, B, constants )
%ODEFUN is a function to use as a handle to pass into ode45
%   Simulattes a launch vehicle trajectory

    rci2eci = get_rotation_matrix(x(1:3)', x(4:6)', 'RCI2ECI');
    dir = rci2eci * thrust_direction(A, B, t)';
    
    % constants 
    g0 = 9.80665; % m / s^2
    
    % intermediate variable 
    r = sqrt( x(1:3)' * x(1:3) );
    
    % ensure that the direction vector is a unit vector
    dir = dir / norm(dir);
    
    % get xdot
    dxdt = [x(4); ... % x velocity
            x(5); ... % y velocity
            x(6); ... % z velocity
          (-constants.mu*x(1))/r^3 + (constants.thrust/x(7))*dir(1); ... % x acceleration
          (-constants.mu*x(2))/r^3 + (constants.thrust/x(7))*dir(2); ... % y acceleration
          (-constants.mu*x(3))/r^3 + (constants.thrust/x(7))*dir(3); ... % z acceleration
          -constants.thrust / (constants.Isp * g0); ... % mass
            1]; % time    
    
end

