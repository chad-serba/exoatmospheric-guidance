function [ J ] = guid_form_jacobian( E0, Eperturb, deltaLambda )
%GUID_FORM_JACOBIAN Summary of this function goes here
%   Detailed explanation goes here


    
    [~, numPerturbations] = size(Eperturb);
    for jj = 1:numPerturbations
        % pull out control parameters
        lam = deltaLambda(jj,jj);
        
        J(:,jj) = ( E0 - Eperturb(:,jj) ) / lam;
    end
        
    
end

