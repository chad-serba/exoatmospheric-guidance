function [r_R, v_R] = calc_required_quantities(e, nu, mu, vp, rp)
%CALC_REQUIRED_QUANTITIES Calculate the required quantites as part of the
%predictor-corrector algorithm
%   e, nu, mu are scalar values
%   vp, rp are 3 element vector values

    if length(vp) ~= 3 || length(rp) ~= 3
        error('vp, rp must both be 3-element vectors')
    end
    
    % find the semilatus rectum
    p = norm(vp)^2 * norm(rp)^2 / mu;
    
    % calculate the required radius at the time of nu
    r_R = p / (1 + e*cosd(nu));
    
    % calculate the required velocity at the time of nu
    v_R = -(1/norm(rp))*sqrt(mu/p)*sind(nu)*rp + (1 - (norm(rp)/p)*(1-cosd(nu)))*vp;
    
    
end

