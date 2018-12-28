function monte_carlo( target, initial, guid_guess, vehicle_options, num_runs, outputs )
%MONTE_CARLO wraps around a list of indevidual simulations to execute a
%monte carlo

    % execute the vehicle_options script
    if strcmp(vehicle_options(end-1:end), '.m')
        vehicle_options = vehicle_options(1:end-2);
    end
    draw_setup = eval( vehicle_options );
    
    % Put the initial state structure into a vector
    nominal_mass = get_total_mass( draw_setup ); % nominal initial mass
    initial_state = [initial.pos; initial.vel; nominal_mass; initial.time];
    
    % make the dispersion draws
    seed = 123456789;
    draws = make_draws( draw_setup, num_runs, seed );
    
    % if it doesn't exist, make the output folder
    if ~exist(outputs.folder, 'dir')
        mkdir(outputs.folder);
    end
    
    % make histograms of the draws and save the data
    create_draw_hist( draws, outputs.folder, outputs.prefix );
    save( [outputs.folder, '/', outputs.prefix, '_draws.mat'], 'draws', 'draw_setup')
    
    
    % some constants for the sim
    constants.mu = 3.986004418e14; %m^3 / s^2
    constants.Isp = draws.engine.isp.draws(1); % nominal isp draw
    constants.thrust = draws.engine.thrust.draws(1); % nominal thrust draw
    constants.totalMass = nominal_mass; % nominal total mass 
    
    % generate an array of dispersion draws to pass into sim
    for ii = 1:num_runs
        dispersion(ii).thrust = draws.engine.thrust.draws(ii);
        dispersion(ii).Isp = draws.engine.isp.draws(ii);
        dispersion(ii).riseTime = draws.engine.rise_time.draws(ii);
        dispersion(ii).totalMass = draws.mass_properties.ss_dry_mass.draws(ii) + ...
                                   draws.mass_properties.ss_wet_mass.draws(ii) + ...
                                   draws.mass_properties.sv_mass.draws(ii);
    end
        
    % use a parallel for loop to speed up overal run time
    results = cell(1,num_runs);
    parfor run = 1:num_runs
        
        fprintf('Executing monte carlo run %d...\n', run)
        
        results{run} = execute_monte_carlo_case( target, constants, dispersion(run), ...
                                            guid_guess, initial_state );
                                        
    end
    
    % make histograms and plots and save the outputs
    create_results_hist( results, target, outputs.folder, [outputs.prefix '_resultsHist'] );
    create_timehistory_plots( results, outputs.folder, [outputs.prefix '_timehistory'] );
	save([outputs.folder, '/', outputs.prefix, '_results.mat'], 'results')

    
end

