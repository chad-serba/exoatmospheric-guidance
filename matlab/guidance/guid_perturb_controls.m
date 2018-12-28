function [ perturbed_results, deltaLambda ] = guid_perturb_controls( xstart, lambda_nom, constants )
%GUID_PERTURB_CONTROLS Computes the final state after integrating forward
%the trajectory with perturbed controls

    % choose a small perturbation. May need to play with this and find a
    % value for each control parameter.
    perturbations = [0.005 0.005 0.005 0.005 0.005 0.005 0.01];

    for ii = 1:length(lambda_nom)
       
        lambda_test = lambda_nom;
        lambda_test(ii) = lambda_test(ii) + perturbations(ii);
        perturbed_results(ii,:) = guid_integrate_forward(xstart, lambda_test, constants);
        
        deltaLambda(ii,:) = lambda_test - lambda_nom;
        
    end
    
    

end

