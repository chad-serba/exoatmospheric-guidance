function [ xend ] = guid_integrate_forward( xstart, lambda, constants )
%GUID_INTEGRATE_FORWARD integrates a trajectory forward as part of the
%guidance algorithm
%   INPUTS:
%       x: state at the start of the integration, including time
%       lambda: control vector to use (has components A, B, tf)

    
    tf = lambda(end);
    A = lambda(1:3);
    B = lambda(4:6);
    
%     deltaT = 0.01;
%     if tf > 500 
%         % there is no way this is feasible 
%         fprintf('Trying to integrate a trajectory for more than 500 sec: tf=%3.3f\n', tf)
%         deltaT = 0.1; % make this much bigger
%     end
%         
%     % iterate from the time of the starting trajectory to the predicted
%     % end of the burn 
%     iterations = floor( (tf-xstart(end)) / deltaT ); % TODO: should this be something other than a floor?
%     if ~isempty(iterations) && iterations > 0
%         for ii = 1:iterations
% 
%             % set the thrust direction according to the guidance law
%             rci2eci = get_rotation_matrix(xstart(1:3), xstart(4:6), 'RCI2ECI');
%             dir = rci2eci * thrust_direction(A, B, xstart(end))';
% 
%             if constants.useAccel
%                 xend = propagate_orbit_const_accel( xstart', constants.accel, dir, deltaT )';
%             else
%                 xend = propagate_orbit_thrust( xstart', constants.thrust, constants.Isp, dir, deltaT)';
%             end
%             xstart = xend;
% 
%         end
%     else
%         xend = xstart;
%     end
    
    % faster and more accurate to just use ode45
    [~,y] = ode45(@(t,y) odefun(t, y, A, B, constants), [xstart(end) tf], xstart);
    xend = y(end,:);
    
end

