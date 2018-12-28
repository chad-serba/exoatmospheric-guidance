function [ pos, vel] = guid_perigee_target( target, mu )
%PERIGEE_TARGET Gets the targeted position and velocity unit vectors given
%omega
%   Reference: https://en.wikipedia.org/wiki/Apsis
%              http://www.bogan.ca/orbits/kepler/orbteqtn.html 

    posMag = (1 - target.e) * target.a;
    pos =  posMag * [cosd(target.w); ...
                     sind(target.w); ...
                     0];
    
    
    velMag = sqrt( ((1+target.e)*mu) / ((1-target.e)*target.a) );
    vel = velMag *[-sind(target.w); ...
                    cosd(target.w); ...
                    0];
    
end

