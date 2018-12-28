function totalMass = get_total_mass( draws )
%GET_TOTAL_MASS Summary of this function goes here
%   Detailed explanation goes here

    totalMass = 0;
    if isfield(draws, 'mass_properties')
        massPropFields = fields(draws.mass_properties);
        numMassProps = numel(massPropFields);
        for ii = 1:numMassProps
            totalMass = totalMass + draws.mass_properties.(massPropFields{ii}).mean;
        end
    else
        error('no mass properties defined!')
    end
end

