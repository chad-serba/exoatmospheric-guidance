function [draw_struct] = make_draws(setup, num, seed)
%MAKE_DRAWS takes in a setup_draw structure and performs the draws 
%   Inputs:
%       setup: structure from the output of setup_draws
%       num: number of draws to make for each variable
%       seed: seed for the random number generator, to recreate results

    % setup the seed. This is important for repeatability of draws
    rng(seed);
    
    % get the number of draw categories and loop through 
    categories = fields(setup);
    for ii = 1:numel(categories)
        
        % get the number of parameters in this category and loop through
        parameters = fields(setup.(categories{ii}));
        for jj = 1:numel(parameters)
            
            % determine the type of draw to make 
            type = get_dispersion_type(setup.(categories{ii}).(parameters{jj}));
            
            if strcmp(type, 'gaussian')
                meanVal = setup.(categories{ii}).(parameters{jj}).mean;
                sigmaVal = setup.(categories{ii}).(parameters{jj}).sigma;
                
                draw_struct.(categories{ii}).(parameters{jj}).draws = ...
                    normrnd(meanVal, sigmaVal, 1, num);
            elseif strcmp(type, 'uniform')
                minVal = setup.(categories{ii}).(parameters{jj}).min;
                maxVal = setup.(categories{ii}).(parameters{jj}).max;
                meanVal = (minVal + maxVal) / 2;
                
                draw_struct.(categories{ii}).(parameters{jj}).draws = ...
                    minVal + (maxVal-minVal).*rand(1,num);
            else
                error('Unknown Dispersion Type: %s', type)
            end
            
            % add a nominal draw to the front 
            draw_struct.(categories{ii}).(parameters{jj}).draws = ...
                [meanVal, draw_struct.(categories{ii}).(parameters{jj}).draws];
            
            % record the units
            draw_struct.(categories{ii}).(parameters{jj}).units = ...
                setup.(categories{ii}).(parameters{jj}).units;
        
        end
        
    end
    
end

