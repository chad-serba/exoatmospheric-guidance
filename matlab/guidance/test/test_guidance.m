%% test_guidance.m
% Chad Serba
% Due 12/12/2018    


close all
clear variables
clc

%% Constants

accel = 30; % constant acceleration, m/s/s
initial_tf = 80; % initial guess for burn time, sec
mu = 3.986004418e14; %m^3 / s^2
% target.a = 24364 * 1000; % m
% target.i = 0;            % degrees
% target.e = 0.730;
% target.w = 0;           % degrees
target.a = 10000 * 1000; % m
target.i = 0;            % degrees
target.e = 0.0001;
target.w = 35;           % degrees
constants.mu = mu;
constants.accel = accel;
constants.thrust = 90000; % Newtons
constants.Isp = 348;
stepSize = 0.005;


%% New implementation

newImplementationPath = '../../';
addpath(genpath(newImplementationPath));

new.A = [0 1 0];
new.B = [0 0 0];
new.tf = 23;

% initial_state = [6571*1000; ...   % x position, m
%                  0; ...   % y position, m
%                  0; ...      % z position, m
%                  0; ... % x velocity, m/s
%                  9*1000; ...  % y velocity, m/s
%                  0; ...           % z velocity. m/s
%                  109440; ...        % mass, kg
%                  0];              % time, sec
initial_state = [8276*1000; ...   % x position, m
                 5612*1000; ...   % y position, m
                 5*1000; ...      % z position, m
                 -3.142*1000; ... % x velocity, m/s
                 4.672*1000; ...  % y velocity, m/s
                 0; ...           % z velocity. m/s
                 3000; ...        % mass, kg
                 0];              % time, sec
accelOrThrust = 'thrust';
new.guid = guidance(target, new, constants.mu, constants.Isp, constants.thrust, accelOrThrust);

new.E0 = [];
new.guid_itr = 0;
itr = 0;
maxItr = 10000;

guid_freq = 1; % guidance execution frequency, Hz
guid_steps = floor( (1/guid_freq) / stepSize);



fprintf('Running Guidance Simulation...\n'); tstart = tic;
new.x_guid(1,:) = initial_state';
new.tgo = inf;
while new.tgo(end) > 0
   
    % calculate guidance update
    % dont update the guidane if within 5 sec of predicted meco
    if ~mod(itr, guid_steps) && new.tgo(end) > 5
        
        new.guid_itr = new.guid_itr + 1;

        % modify guidance execution frequency after converged and before
        % close to the end of the burn
        if new.guid_itr >= 5 && new.tgo(end) > 15
            guid_freq = 1; % executes every 4 seconds
            guid_steps = floor( (1/guid_freq) / stepSize);
        elseif new.tgo(end) <= 20
            guid_freq = 1; % executes every second
            guid_steps = floor( (1/guid_freq) / stepSize);
        end

        tic
        new.guid = new.guid.update( new.x_guid(end,:) );
        new.tf(end+1) = new.guid.get_tf;
        new.E0(end+1) = norm( new.guid.get_E0 );
        new.A(end+1,:) = new.guid.get_A;
        new.B(end+1,:) = new.guid.get_B;
        new.executionTime = toc;
        fprintf('Guidance Executed in %3.2f sec. t=%3.3f...tf=%3.3f...tgo=%3.3f...E0=%3.3f\n', new.executionTime, new.x_guid(end,end), new.tf(new.guid_itr), new.tgo(end), new.E0(new.guid_itr))
        new.timeOfPrevUpdate = new.x_guid(end,end);
        if new.tf(end) < 0
            break;
        end
    end
        
    itr = itr + 1;
    new.tgo(end+1) = new.tf(end) - new.x_guid(itr,end);
    
    % set thrust according to guidance law
    new.eciThrustDirection(itr,:) = guid_eci_thrust( new.guid, new.x_guid(end,:) );
    
    % integrate to next time step
    if strcmpi(accelOrThrust, 'accel')
        new.x_guid(itr+1,:) = propagate_orbit_const_accel( new.x_guid(itr,:)', constants.accel, new.eciThrustDirection(itr,:), stepSize );
    elseif strcmpi(accelOrThrust, 'thrust')
        new.x_guid(itr+1,:) = propagate_orbit_thrust( new.x_guid(itr,:)', constants.thrust, constants.Isp, new.eciThrustDirection(itr,:), stepSize );
    end
end


endTime = toc(tstart); fprintf('Guidance Sim finished in %3.3f sec\n', endTime)
new.burnDuration = new.x_guid(end,end) - new.x_guid(1,end);
fprintf('Burn lasted %3.2f seconds\n', new.burnDuration)

new.endingOE = OrbitalElements( new.x_guid(end,1:3), new.x_guid(end,4:6), constants.mu);
[new.rp, new.vp] = guid_perigee_target( target, constants.mu );
new.closedLoopNu = calc_targeted_nu(new.x_guid(end,1:3), new.rp, new.vp);

fprintf('New Implementation - Closed Loop Burn Difference from Targets:\n')
fprintf('\ta: %3.5f km\n', (new.endingOE.a - target.a)/1000)
fprintf('\ti: %3.5f deg\n', new.endingOE.i - target.i)
fprintf('\te: %3.5f n.d.\n', norm(new.endingOE.e) - norm(target.e))
fprintf('\tw: %3.5f deg\n', new.endingOE.w - target.w)
fprintf('Closed Loop Nu at Injection: %3.4f\n', new.closedLoopNu);


%% Make some plots

figure
subplot(2,1,1)
    hold on
    plot(new.A)
    title('A')
    xlabel('Guidance Iterations')
subplot(2,1,2)
    hold on
    plot(diff(new.A))
    title('Delta-A')
    xlabel('Guidance Iterations')
    

figure
subplot(2,1,1)
    hold on
    plot(new.B)
    title('B')
    xlabel('Guidance Iterations')
subplot(2,1,2)
    hold on
    plot(diff(new.B))
    title('Delta-B')
    xlabel('Guidance Iterations')


figure
subplot(2,1,1)
    hold on
    plot(new.tf)
    title('tf')
    xlabel('Guidance Iterations')
    ylabel('sec')
subplot(2,1,2)
    hold on
    plot(diff(new.tf))
    title('Delta-tf')
    xlabel('Guidance Iterations')
    ylabel('sec')

    
figure
hold on
plot(new.x_guid(1:end-1,end), new.eciThrustDirection)
title('Thrust Direction in ECI Frame')
xlabel('Time')
legend('x', 'y', 'z')


figure
subplot(3,1,1)
    title('Radius Over Time')
    hold on
    plot(new.x_guid(:,end), new.x_guid(:,1))
subplot(3,1,2)
    hold on
    plot(new.x_guid(:,end), new.x_guid(:,2))
subplot(3,1,3)
    hold on
    plot(new.x_guid(:,end), new.x_guid(:,3))
xlabel('Time')


figure
subplot(3,1,1)
    title('Velocity Over Time')
    hold on
    plot(new.x_guid(:,end), new.x_guid(:,4))
subplot(3,1,2)
    hold on
    plot(new.x_guid(:,end), new.x_guid(:,5))
subplot(3,1,3)
    hold on
    plot(new.x_guid(:,end), new.x_guid(:,6))
xlabel('Time')

accel = diff(new.x_guid(:,4:6));
totalAccel = sqrt(accel(:,1).^2 + accel(:,2).^2 + accel(:,3).^2);
figure
plot(new.x_guid(1:end-1,end), totalAccel)
title('Total Acceleration Over Time')


figure
plot(new.x_guid(:,end), new.x_guid(:,7))
title('Changing Mass Over Time')

    
figure
subplot(2,1,1)
    hold on
    plot(new.E0)
    title('Norm of Error Vector')
    xlabel('Guidance Iterations')
subplot(2,1,2)
    hold on
    plot(diff(new.E0))
    title('Delta Norm of Error Vector')
    xlabel('Guidance Iterations')


