function [ u_hat, varargout ] = thrust_direction( A, B, t )
%THRUST_DIRECTION returns the thrust direction angles given A, B
%   INPUTS:
%       A: The "A" term from the bilinear guidance law
%       B: The "B" term from the bilinear guidance law
%       t: The time from the start of the maneuver
%   OUTPUTS:
%       u_hat: the thrust direction vector, in the local rotating frame
%       theta: (optional) the thrust pitch angle, in the local frame
%       alpha: (optional) the thrust yaw angle, in the local frame

    if length(A) ~= 3 || length(B) ~= 3
        error('A and B must be three element vectors')
    end
    
    % get the three dimensional thrust direction
    aplusbt = A + B*t;
    u_hat = aplusbt / sqrt( aplusbt * aplusbt' ); % faster normalization
    
    % optionally output the thrust direction angles
    if nargout > 1
        theta = atan2d( A(3) + B(3)*t, A(1) + B(1)*t );
        alpha = atan2d( A(2) + B(2)*t, A(1) + B(1)*t ); 
        varargout{1} = theta;
        varargout{2} = alpha;
    end
end

