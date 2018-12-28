function [ E ] = compute_error_vec( r_R, v_R, h_R, r, v, lambda, B, g)
%COMPUTE_ERROR_VEC calculates the error vector
%   INPUTS:
%       r_R: the required position at injection
%       v_R: the required velocity at injection
%       r: the calculated position at injection
%       v: the calculated velocity at injection
%       lambda: the final control vector, A + B*tf
%       B: the guidance parameter, also lambda_dot
%       g: the gravity vector at tf (in ECI frame)
%   OUTPUTS:
%       E: a 7-element error vector

    % the first three components are the difference between the required
    % velocity at injection true anomaly minus the predicted velocity at
    % the end of the burn
    E(1) = v_R(1) - v(1);
    E(2) = v_R(2) - v(2);
    E(3) = v_R(3) - v(3); 
    
    % the fourth component is the difference in position magnitude
    E(4) = r_R - sqrt( r * r' ); % faster normalization
    
    % the fifth component ensures the correct plane
    h_R = h_R / norm(h_R); % ensure this is a unit vector, use faster normalization
    E(5) = dot(h_R, r);
    
    % TODO: what does this ensure? 
    rot = get_rotation_matrix(r, v, 'RCI2ECI'); % put everyhing in the same frame
    E(6) = dot(rot * lambda', g) - dot(rot * B', v);
    
    % TODO: what does this ensure? 
    E(7) = sqrt( dot(lambda, lambda) ) - 1;
    
end

