function [ type ] = get_dispersion_type( parameter )
%GET_DISPERSION based on the draw parameters, get the dispersion type
%   Valid types are:
%       Uniform, defined by min and max 
%       Gaussian, defined by mean and sigma

    parFields = fields(parameter);
    
    if any(strcmp(parFields, 'mean')) && any(strcmp(parFields, 'sigma'))
        % this defines a gaussian
        type = 'gaussian';
    elseif any(strcmp(parFields, 'min')) && any(strcmp(parFields, 'max'))
        % this defines a uniform
        type = 'uniform';
    else
        % this isn't something we are familiar with
        fprintf('\nDispersion defined by:\n')
        for kk = 1:numel(parFields)
            fprintf('Entry %d: %s\n', kk, parFields{kk});
        end
        error('Unknown dispersion type.')
    end
end

