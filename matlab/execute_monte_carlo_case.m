function [ results ] = execute_monte_carlo_case( target, constants, dispersions, guidance_guess, initial_state )
%EXECUTE_MONTE_CARLO is a wrapper function to execute a guidance simulation
%   Detailed explanation goes here

    % log the start time 
    tstart = tic;

    accelOrThrust = 'thrust';
    guid = guidance(target, guidance_guess, constants.mu, ...
                    constants.Isp, constants.thrust, accelOrThrust);
    
    % an object to give the engine thrust curve
    engine = engine_thrust( dispersions.riseTime, dispersions.thrust );
    
    % function to determine the mass that the guidance algorithm thinks it
    % is 
    g0 = 9.80665; % m / s^2
    curr_mass = @(t_from_burn) constants.totalMass - ( constants.thrust / (constants.Isp * g0) ) * t_from_burn;
    
    % some set up
    E0 = [];
    guid_itr = 0;
    itr = 0;
    tf = [];
    A = [];
    B = [];
    updateTimes = [];
    current_thrust = [];
    
    % some guidance configuration stuff
    tgo_noUpdateTime = 10;
    switchToSlowFreqTime = 5;
    switchToFastFreqTime = 15;
    fastUpdateFreq = 1; % was 1/3, change to use 1 Hz updates always;
    slowUpdateFreq = 1;
    stepSize = 0.005;
    guid_freq = fastUpdateFreq; % initial guidance execution frequency
    guid_steps = floor( (1/guid_freq) / stepSize);

    % the first state
    x_guid(1,:) = initial_state';
    tgo = inf;
    
    while tgo(end) > 0
   
        % calculate guidance update
        % dont update the guidane if close to predicted meco
        if ~mod(itr, guid_steps) && tgo(end) > tgo_noUpdateTime

            guid_itr = guid_itr + 1;

            % modify guidance execution frequency after converged and before
            % close to the end of the burn
            if tgo(end) >= switchToSlowFreqTime && tgo(end) > switchToFastFreqTime
                guid_freq = slowUpdateFreq; % slower execution frequency
                guid_steps = floor( (1/guid_freq) / stepSize);
            elseif tgo(end) <= switchToFastFreqTime
                guid_freq = fastUpdateFreq; % executes every second
                guid_steps = floor( (1/guid_freq) / stepSize);
            end

            % guidance doesn't know everything about its state perfectly
            % overwrite the integrator-calculated mass (which includes
            % dispersions) with what the guidnace algorithm would be able
            % to estimate
            guid_state = x_guid(end,:);
            guid_state(end-1) = curr_mass( x_guid(end,end) - x_guid(1,end) );
            
            
            guid = guid.update( guid_state );
            tf(end+1) = guid.get_tf;
            E0(end+1) = norm( guid.get_E0 );
            A(end+1,:) = guid.get_A;
            B(end+1,:) = guid.get_B;
            updateTimes(end+1) = x_guid(end,end);
%             fprintf('Guidance Executed. t=%3.3f...tf=%3.3f...tgo=%3.3f...E0=%3.3f\n', x_guid(end,end), tf(end), tgo(end), E0(end))
            if tf(end) < 0
                break;
            end
        end

        itr = itr + 1;
        tgo(end+1) = tf(end) - x_guid(itr,end);

        % set thrust according to guidance law
        eciThrustDirection(itr,:) = guid_eci_thrust( guid, x_guid(end,:) );
        
        % get current thrust
        t_from_engine_start = x_guid(itr,end) - x_guid(1,end);        
        current_thrust(itr) = engine.getThrust( t_from_engine_start );
        
        % integrate to next time step
        if strcmpi(accelOrThrust, 'accel')
            x_guid(itr+1,:) = propagate_orbit_const_accel( x_guid(itr,:)', dispersions.accel, eciThrustDirection(itr,:), stepSize );
        elseif strcmpi(accelOrThrust, 'thrust')
            x_guid(itr+1,:) = propagate_orbit_thrust( x_guid(itr,:)', current_thrust(itr), dispersions.Isp, eciThrustDirection(itr,:), stepSize );
        end
    end
    
    % log the end time
    endTime = toc(tstart);
    
    % get the ending state
    burnDuration = x_guid(end,end) - x_guid(1,end);
    endingOE = OrbitalElements( x_guid(end,1:3), x_guid(end,4:6), constants.mu);
    [rp, vp] = guid_perigee_target( target, constants.mu );
    closedLoopNu = calc_targeted_nu(x_guid(end,1:3), rp, vp);

    % put the results in a structure
    results.simTime = endTime;
    results.burnDuration = burnDuration;
    results.endingOE = endingOE;
    results.nuAtInjection = closedLoopNu;
    results.timeVarying.stateDesc = {'x position (m)', 'y position (m)', 'z postition (m)', 'x velocity (m/s)', 'y velocity (m/s)', 'z velocity (m/s)', 'mass (kg)', 'time (sec)'};
    results.timeVarying.state = x_guid;
    results.timeVarying.thrust = current_thrust;
    results.timeVarying.A = A;
    results.timeVarying.B = B;
    results.timeVarying.tf = tf;
    results.timeVarying.E0 = E0;
    results.timeVarying.guidanceUpdateTimes = updateTimes;
    results.timeVarying.eciThrustDirection = eciThrustDirection;
    
    
end

