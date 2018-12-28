function [ rot ] = get_rotation_matrix( r, v, direction )
%GET_ROTATION_MATRIX outputs a rotation matrix to convert from ECI to RIC
%coordinates
%   Reference: https://scholar.colorado.edu/cgi/viewcontent.cgi?article=1094&context=asen_gradetds
%              ( equation 5.6 )

%     % GETTING RID OF THIS STUFF TO SAVE TIME
%     [~,rsz] = size(r);
%     [~,vsz] = size(v);
%     if rsz ~= 3 || vsz ~= 3
%         error('v and r must be 3-element row vectors')
%     end
    
    R = r / sqrt( r * r' ); % faster normalization
    rvcross = mexCross(r, v);
    C = rvcross / sqrt( rvcross * rvcross' ); % faster normalization
    I = mexCross(C,R);
    
    if strcmp(direction, 'ECI2RCI')
        % this rotation matrix is from ECI -> RCI. Transpose to get RCI -> ECI
        rot = [R; ...
               I; ...
               C];
    elseif strcmp(direction, 'RCI2ECI')
        % this rotation matrix is from RCI2ECI. Transpose to get RCI -> ECI
        rot = [R; ...
               I; ...
               C]';
    else
        error('Unknown direction %s', direction)
    end
    
end

