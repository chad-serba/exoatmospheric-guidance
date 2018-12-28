function [ local_g ] = get_local_gravity( state, initialUTC )
%GET_LOCAL_GRAVITY determines the local gravity for a given system state. I
%may need to go back and revisit this if I find that these forumla are not
%adequate for determining gravity at high altitudes (space). In particular,
%may need to completely rethink this to go with my Orbital Mechanics book's
%derivation for orbital perturbation from J2.
%   References: 
%       https://en.wikipedia.org/wiki/Normal_gravity_formula
%       https://research.utep.edu/Portals/73/PDF/Final_NAGDB_Report.pdf

    
    utc = utc_time( initialUTC, state(8) );
    
    lla = eci2lla( state(1:3), utc );
    
    % get latitude-correct normal gravity through Somigliana Formula
    gamma_a = 9.7803267715; % standard gravity at equator, m/s/s
    gamma_b = 9.8321863685; % m/s/s
    a = 6378137; % m
    b = 6356752.3141; % m
    p = ((b*gamma_b) / (a*gamma_a)) - 1;
    e_sq = 1 - b^2 / a^2; % eccentricity of oblate squared
    gamma = gamma_a * ( (1 + p*sind(lla(1))^2) / sqrt(1 - e_sq*sind(lla(1))^2) );
    
    % calculate theoretical gravity using second order approximation
    % and values from GRS80
    g_h = -(3.087691E-6 - 4.398E-9 * sin(lla(1))^2)*lla(3) + lla(3)^2 * 7.2125E-13; % m/s/s
    
    % local gravity is the normal gravity plus the altitude correction
    local_g = gamma + g_h;  
end

