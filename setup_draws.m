function draw_setup = setup_draws()
%SETUP_DRAWS Define what parameters to use in the monte carlo draws

    % MASS PROPERTIES %
    % define draws on mass properties
    % future iterations: dry mass, wet mass, cg locations, moments of
    % inertia, 
    draw_setup.mass_properties.ss_dry_mass.mean = 500; % kg
    draw_setup.mass_properties.ss_dry_mass.sigma = 5;  % kg
    draw_setup.mass_properties.ss_dry_mass.units = 'kg';
    
    draw_setup.mass_properties.ss_wet_mass.mean = 2500;
    draw_setup.mass_properties.ss_wet_mass.sigma = 10;
    draw_setup.mass_properties.ss_wet_mass.units = 'kg';
    
    draw_setup.mass_properties.sv_mass.mean = 500;
    draw_setup.mass_properties.sv_mass.sigma = 5;
    draw_setup.mass_properties.sv_mass.units = 'kg'; 
    
    
    % NAVIGATION %
    % define draws on navigational accuracy. 

    
    % ENGINE %
    % define draws on engine specifics
    draw_setup.engine.isp.mean = 450;
    draw_setup.engine.isp.sigma = 1.5;
    draw_setup.engine.isp.units = 'sec';
    
    draw_setup.engine.thrust.mean = 100000;
    draw_setup.engine.thrust.sigma = 300;
    draw_setup.engine.thrust.units = 'N';
    
    draw_setup.engine.rise_time.mean = 0.5;
    draw_setup.engine.rise_time.sigma = 0.075;
    draw_setup.engine.rise_time.units = 'sec';
    
    
    
end

