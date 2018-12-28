function [ lambdaNew, E0_new_norm ] = guid_newton_raphson( r_req, v_req, h_req, xcurr, xendnom, xendperturb, lambdaOld, lambdaPerturb, constants )
%GUID_NEWTON_RAPHSON Summary of this function goes here

    % get the nominal gravity vector
    g = guid_compute_grav_vec( xendnom(1:3) );
    % calculate the control at the final time
    cntrl = lambdaOld(1:3) + lambdaOld(4:6)*xendnom(end); % calculate A + B*tf
    % calculate the original error vector
    E0 = compute_error_vec( r_req, v_req, h_req, xendnom(1:3), xendnom(4:6), cntrl, lambdaOld(4:6), g);
    
    % loop through and compute error vectors for each perturbation
    [numPerturb,~] = size(xendperturb);
    for kk = 1:numPerturb
       
        x = xendperturb(kk,:);
        
        g = guid_compute_grav_vec( x(1:3) );
        lambdaTest = lambdaOld + lambdaPerturb(kk,:);
        cntrl = lambdaTest(1:3) + lambdaTest(4:6) * x(end); % calc A + B*tf
        
        E(kk,:) = compute_error_vec( r_req, v_req, h_req, x(1:3), x(4:6), cntrl, lambdaTest(4:6), g );
        
    end
    
    
    % create the jacobian
    J = guid_form_jacobian( E0', E', lambdaPerturb );
    
    % use golden ratio search to find the gamma which minimizes E
    lambdaNew = guid_gamma_loop( J, E0, r_req, v_req, h_req, xcurr, lambdaOld, constants );
    
    % calculate the trajectory end with the new lambda
    x_end_new = guid_integrate_forward( xcurr, lambdaNew, constants );
    g_end_new = guid_compute_grav_vec( x_end_new(1:3) );
    cntrl_end_new = lambdaNew(1:3) + lambdaNew(4:6) * x_end_new(end);
    E0_new = compute_error_vec( r_req, v_req, h_req, x_end_new(1:3), x_end_new(4:6), cntrl_end_new, lambdaNew(4:6), g_end_new );
    E0_new_norm = norm(E0_new);
    
end

