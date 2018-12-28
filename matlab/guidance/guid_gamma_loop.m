function [chosen_lambda, gammaUsed, E0_return] = guid_gamma_loop( J, E0, r_req, v_req, h_req, xcurr, lam_old, constants )
%GUID_GAMMA_LOOP is the inner loop of the newton-raphson integration. Loops
%through and selects an appropriate gamma value to minimize the norm of E0
%   Detailed explanation goes here
    
    % make lambda the right shape
    if all(size(lam_old) == [3 1])
        lam_old = lam_old';
    end
    
    % golded section search parameters
    % a and b must bracket the real solution
    a = 0.1;
    b = 1.2;
    maxItr = 3; % number of integration calculations: 2 + (numItr+1)*2 + 1
    itr = 0;
    rho = 1.618033988; % golden ratio, (1 + sqrt(5)) / 2;
    
    % calculate c and d
    c = b - (b-a) / rho;
    d = a + (b-a) / rho;
    
    % execute golden section search
    while itr <= maxItr
        
        % calculate the value of c
        lambda_c = ( lam_old' + pinv(J)*c*E0' )';
        x_c = guid_integrate_forward( xcurr, lambda_c, constants );
        if any( isinf(x_c) )
            E0_c = inf;
        else
            cntrl_c = lambda_c(1:3) + lambda_c(4:6) * x_c(end); % A + B*tf
            g_c = guid_compute_grav_vec( x_c(1:3) );
            E0_c = norm( compute_error_vec( r_req, v_req, h_req, x_c(1:3), x_c(4:6), cntrl_c, lambda_c(4:6), g_c) );
        end
        
        % calculate the value of d
        lambda_d = ( lam_old' + pinv(J)*d*E0' )';
        x_d = guid_integrate_forward( xcurr, lambda_d, constants );
        if any( isinf(x_d) )
            E0_d = inf;
        else
            cntrl_d = lambda_d(1:3) + lambda_d(4:6) * x_d(end); % A + B*tf
            g_d = guid_compute_grav_vec( x_d(1:3) );
            E0_d = norm( compute_error_vec( r_req, v_req, h_req, x_d(1:3), x_d(4:6), cntrl_d, lambda_d(4:6), g_d) );
        end
        
        if E0_c < E0_d
            b = d;
        else
            a = c;
        end
        
        % calculate c and d
        c = b - (b-a) / rho;
        d = a + (b-a) / rho;
        
        itr = itr + 1;
        
    end
    
    % return the middle of the search
    gammaUsed = (b + a) / 2;
    lambda_final = ( lam_old' + pinv(J)*gammaUsed*E0' )';
    x_final = guid_integrate_forward( xcurr, lambda_final, constants );
    cntrl_final = lambda_final(1:3) + lambda_final(4:6) * x_final(end); % A + B*tf
    g_final = guid_compute_grav_vec( x_final(1:3) );
    E0_return = norm( compute_error_vec( r_req, v_req, h_req, x_final(1:3), x_final(4:6), cntrl_final, lambda_d(4:6), g_final) );
    
    % return chosen lambda
    chosen_lambda = lambda_final;
    
        
end

