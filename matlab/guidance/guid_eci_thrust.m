function [ eciThrust ] = guid_eci_thrust( guid, state )
%GUID_ECI_THRUST Summary of this function goes here
%   Detailed explanation goes here

    rci2eci = get_rotation_matrix( state(1:3), state(4:6), 'RCI2ECI' );
    rciThrustDirection = guid.thrust_direction( state(end) );
    eciThrust = ( rci2eci * rciThrustDirection' )';
end

