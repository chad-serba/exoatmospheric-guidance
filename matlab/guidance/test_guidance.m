%% test_guidance.m
% Chad Serba
% Due 12/12/2018    


close all
clear variables
clc

%% Problem 1

initial_state = [8276*1000; ...   % x position, m
                 5612*1000; ...   % y position, m
                 5*1000; ...      % z position, m
                 -3.142*1000; ... % x velocity, m/s
                 4.672*1000; ...  % y velocity, m/s
                 0; ...           % z velocity. m/s
                 0];              % time, sec
accel = 30; % constant acceleration, m/s/s
initial_tf = 23; % initial guess for burn time, sec
mu = 3.986004418e14; %m^3 / s^2
target.a = 10000 * 1000; % m
target.i = 0;            % degrees
target.e = 0.0001;
target.w = 35;           % degrees
constants.mu = mu;
constants.accel = accel;
constants.saveFile = 'runLogs/guidanceUpdateInfo.txt';
A = [0 1 0];
B = [0 0 0];
tf = 23;


%% Compare the implementation from HW4 to the project implementation

hw4path = 'E:\Chads Stuff\College\Graduate - CU Boulder\Courses\Fall 2018\ASEN6519 - Guidance\HW4';
addpath(hw4path)

guid_freq = 1; % guidance execution frequency, Hz
guid_steps = floor( (1/guid_freq) / stepSize);


hw4.E0 = [];
hw4.guid_itr = 0;
hw4.itr = 0;
hw4.maxItr = 10000;
hw4.isConverged = 0;

fprintf('Running Guidance Simulation...\n'); tstart = tic;
hw4.x_guid(1,:) = initial_state';
hw4.tgo = inf;
while hw4.tgo(end) > 0
   
    % calculate guidance update
    % dont update the guidane if within 5 sec of predicted meco
    if ~mod(itr, guid_steps) && hw4.tgo(end) > 5
        
        guid_itr = guid_itr + 1;

        % modify guidance execution frequency after converged and before
        % close to the end of the burn
        if guid_itr >= 5 && hw4.tgo(end) > 12
            guid_freq = 0.25; % executes every 4 seconds
            guid_steps = floor( (1/guid_freq) / stepSize);
        elseif hw4.tgo(end) <= 12
            guid_freq = 1; % executes every second
            guid_steps = floor( (1/guid_freq) / stepSize);
        end

        tic
        [hw4.A(end+1,:), hw4.B(end+1,:), hw4.tf(end+1), hw4.E0(end+1)] = guid_update( hw4.x_guid(end,:), [hw4.A(end,:), hw4.B(end,:), hw4.tf(end)], target, constants);
        executionTime = toc;
        fprintf('Guidance Executed in %3.2f sec. t=%3.3f...tf=%3.3f...tgo=%3.3f...E0=%3.3f\n', executionTime, hw4.x_guid(end,7), hw4.tf(end), hw4.tgo(end), hw4.E0(end))
        hw4.timeOfPrevUpdate = hw4.x_guid(end,7);
        if hw4.tf(end) < 0
            break;
        end
    end
        
    itr = itr + 1;
    hw4.tgo(end+1) = hw4.tf(end) - hw4.x_guid(itr,7);
    
    % set thrust according to guidance law
    hw4.rci2eci = get_rotation_matrix(hw4.x_guid(itr,1:3), hw4.x_guid(itr,4:6), 'RCI2ECI');
    [hw4.rciThrustDirection(itr,:), hw4.theta(itr), hw4.alpha(itr)] = thrust_direction(hw4.A(end,:), hw4.B(end,:), hw4.x_guid(itr,7));
    hw4.eciThrustDirection(itr,:) = ( hw4.rci2eci * hw4.rciThrustDirection(itr,:)' )';
    
    % integrate to next time step
    hw4.x_guid(itr+1,:) = propagate_orbit_const_accel( hw4.x_guid(itr,:)', constants.accel, hw4.eciThrustDirection(itr,:), stepSize );
    
end

endTime = toc(tstart); fprintf('Guidance Sim finished in %3.3f sec\n', endTime)
hw4.burnDuration = hw4.x_guid(end,7) - hw4.x_guid(1,7);
fprintf('Burn lasted %3.2f seconds\n', hw4.burnDuration)

hw4.endingOE = OrbitalElements( hw4.x_guid(end,1:3), hw4.x_guid(end,4:6), constants.mu);
[hw4.rp, hw4.vp] = perigee_target( target, constants.mu );
hw4.closedLoopNu = calc_targeted_nu(hw4.x_guid(end,1:3), hw4.rp, hw4.vp);

fprintf('Closed Loop Burn Difference from Targets:\n')
fprintf('\ta: %3.5f km\n', (hw4.endingOE.a - target.a)/1000)
fprintf('\ti: %3.5f deg\n', hw4.endingOE.i - target.i)
fprintf('\te: %3.5f n.d.\n', norm(hw4.endingOE.e) - norm(target.e))
fprintf('\tw: %3.5f deg\n', hw4.endingOE.w - target.w)
fprintf('Closed Loop Nu at Injection: %3.4f\n', hw4.closedLoopNu);


figure
subplot(2,1,1)
    plot(A)
    title('A')
    xlabel('Guidance Iterations')
subplot(2,1,2)
    plot(diff(A))
    title('Delta-A')
    xlabel('Guidance Iterations')
ax = gca;
set(ax, 'Color', 'none')
export_fig('A_updates.png', '-nocrop', '-m3', '-transparent')
    

figure
subplot(2,1,1)
    plot(B)
    title('B')
    xlabel('Guidance Iterations')
subplot(2,1,2)
    plot(diff(B))
    title('Delta-B')
    xlabel('Guidance Iterations')
ax = gca;
set(ax, 'Color', 'none')
export_fig('B_updates.png', '-nocrop', '-m3', '-transparent')


figure
subplot(2,1,1)
    plot(tf)
    title('tf')
    xlabel('Guidance Iterations')
    ylabel('sec')
subplot(2,1,2)
    plot(diff(tf))
    title('Delta-tf')
    xlabel('Guidance Iterations')
    ylabel('sec')
ax = gca;
set(ax, 'Color', 'none')
export_fig('tf_updates.png', '-nocrop', '-m3', '-transparent')

    
figure
plot(x_guid(1:end-1,7), eciThrustDirection)
title('Thrust Direction in ECI Frame')
xlabel('Time')
legend('x', 'y', 'z')
ax = gca;
set(ax, 'Color', 'none')
export_fig('thrust_direction.png', '-nocrop', '-m3', '-transparent')



figure
subplot(2,1,1)
    plot(x_guid(1:end-1,7), theta)
    title('Local Frame Theta')
    ylabel('Angle (deg)')
    xlabel('Time (sec)')
subplot(2,1,2)
    plot(x_guid(1:end-1,7), alpha)
    title('Local Frame Alpha')
    ylabel('Angle (deg)')
    xlabel('Time (sec)')
    
    
figure
subplot(2,1,1)
    plot(E0)
    title('Norm of Error Vector')
    xlabel('Guidance Iterations')
subplot(2,1,2)
    plot(diff(E0))
    title('Delta Norm of Error Vector')
    xlabel('Guidance Iterations')
ax = gca;
set(ax, 'Color', 'none')
export_fig('error_norm.png', '-nocrop', '-m3', '-transparent')

    



