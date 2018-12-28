%% target_orbit.m
% Chad Serba
% Script to determine the initial conditions and target orbit for my
% Guidance project

addpath('../') % need OrbitalElements.m

RE = 6371*1000; % radius of earth, m
mu = 3.986004418E14; % earth's gravitational constant, m^3 / s^2
parkingOrbitAlt = 200*1000; % m
GSO_orbitAlt = 35786*1000; % m 

parkingOrbitRadius = parkingOrbitAlt + RE;
GSO_orbitRadius = GSO_orbitAlt + RE;

parkingOrbitVel = sqrt( mu / parkingOrbitRadius );

[dv1, ~] = hohmannTransferCalc( parkingOrbitRadius, GSO_orbitRadius );

% the perfect parking orbit state vector
y_parking = [parkingOrbitRadius; ...
             0; ...
             0; ...
             0; ...
             parkingOrbitVel; ...
             0];

% the instant the first Hohmann transfer delta-v is applied 
y_transfer = [parkingOrbitRadius; ...
              0; ...
              0; ...
              0; ...
              parkingOrbitVel + dv1; ...
              0];

% GTO targeted orbital elements
OE_transfer = OrbitalElements(y_transfer(1:3), y_transfer(4:6), mu);
OE_transfer.w = atan2(OE_transfer.e(2), OE_transfer.e(1)); % convention for equatorial orbits
fprintf('Target semimajor axis: %3.3f km\n', OE_transfer.a / 1000)
fprintf('Target eccentricity: %3.3f n.d.\n', norm(OE_transfer.e))
fprintf('Target inclination: %3.3f deg\n', OE_transfer.i)
fprintf('Target argument of perigee: %3.3f deg\n', OE_transfer.w)

fprintf('\nImpulsive Delta-V required: %3.3f m/s\n', dv1)
