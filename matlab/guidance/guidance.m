classdef guidance
    %GUIDANCE Handles the processing of a bilinear tangent guidance alg
    %   Detailed explanation goes here
    
    properties (SetAccess = public)
        % properties which are publicly accessible and can change
        A
        B
        tf
        E0
        perigee
        required
    end
    
    properties (SetAccess = public)
        % properties which are publicly accessible but cannot be changed
        constants
        target
    end
    
    properties (Access = protected)
        % properties that are internal and hidden from access
        perturbed_states
        deltaLambdas
        current_x_pred
        current_state
    end
    
    methods (Access = public)
        
        %%%%%%%%%%%%%%%%%%%%%%%
        function A = get_A(obj)
            A = obj.A;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%
        function B = get_B(obj)
            B = obj.B;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        function tf = get_tf(obj)
            tf = obj.tf;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        function E = get_E0(obj)
                E = obj.E0;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = guidance(target, initial_guess, mu, Isp, thrust, thrustOrAccel)
            %GUIDANCE Construct an instance of the guidance class
            %   Required inputs are the target, the initial guess for a
            %   solution, earth's gravitational constant, and the maximum
            %   thrust of the vehicle (this is overwritten during startup
            %   and shutdown) 
            %       The purpose of this function is to set up the constant
            %       parameters that do not change through flight
            obj.target.a = target.a;
            obj.target.e = target.e;
            obj.target.w = target.w;
            obj.A = initial_guess.A;
            obj.B = initial_guess.B;
            obj.tf = initial_guess.tf;
            obj.constants.mu = mu;
            % this is the thrust / accel the vehicle knows about, not necessarily 
            % the thrust draw
            if strcmpi(thrustOrAccel, 'thrust')
                obj.constants.thrust = thrust; 
                obj.constants.useAccel = 0;
            elseif strcmpi(thrustOrAccel, 'accel')
                obj.constants.accel = thrust;
                obj.constants.useAccel = 1;
            end
            obj.constants.Isp = Isp;
            
            
            % calculate the perigee target
            [obj.perigee.r, obj.perigee.v] = guid_perigee_target(obj.target, obj.constants.mu);
            
            % calculate the required orbit quantities
            obj.required.h = mexCross(obj.perigee.r', obj.perigee.v');
            obj.required.nu = [];
            obj.required.r = [];
            obj.required.v = [];
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function uhat = thrust_direction(obj, t)
            % t is the time from the start of the burn
            aplusbt = obj.A + obj.B*t;
            uhat = aplusbt / sqrt( aplusbt * aplusbt' ); % faster normalization
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = update( obj, current_state )
            
%             if obj.constants.useAccel == 0
%                 % using time-varying thrust and acceleration
%                 % for simplicity, calculate a current acceleration and use
%                 % that in my integrations
%                 resetUseAccel = 1;
%                 obj.constants.useAccel = 1;
%                 obj.constants.accel = obj.constants.thrust / current_state(end-1);
%                 current_state = [current_state(1:6) current_state(end)];
%             end
                
            maxItrs = 6; % maximum number of iterations. Fewer is faster
            
            % initialize some variables for speed
            lambdaNew = zeros(maxItrs+1, 7);
            E0_ = inf(maxItrs+1, 1); % internal E0 variable
%             E0_ = inf;
            lambdaNew(1,:) = [obj.A, obj.B, obj.tf]; % start with current lambda
            
            deltaE0 = inf;
            conv_threshold = 0.05;
            itr = 0;
            bestItr = 0;
            
            for itr = 1:maxItrs
%             while deltaE0 > conv_threshold && itr < maxItrs
                
%                 itr = itr + 1;
                % forward integrate current and perturbed trajectories
                [ x_perturbed, lam_perturbs ] = ...
                    guid_perturb_controls(current_state, lambdaNew(itr,:), obj.constants);
                pred_x = ...
                    guid_integrate_forward( current_state, lambdaNew(itr,:), obj.constants );
                
                % calculate the new required quantities
                obj.required.nu = calc_targeted_nu(pred_x(1:3), obj.perigee.r, obj.perigee.v);
                [ obj.required.r, obj.required.v  ] = calc_required_quantities(obj.target.e, ...
                            obj.required.nu, obj.constants.mu, obj.perigee.v, obj.perigee.r);
                
                % use Newton Raphson iteration to calculate a new Lambda
                [ lambdaNew(itr+1,:), E0_(itr+1) ] = guid_newton_raphson( obj.required.r, ...
                            obj.required.v, obj.required.h, current_state, pred_x, ...
                            x_perturbed, lambdaNew(itr,:), lam_perturbs, obj.constants );
                        
%                 if E0_new < E0_
%                     bestItr = itr+1;
%                     best_E0 = E0_new;
%                 end
%                 deltaE0 = abs( E0_new - E0_ );
%                 E0_ = E0_new;
            end
            
            % which of the iterations was the smallest? 
            % use it to update the class's A, B, tf
            [obj.E0, smallIdx] = mink(E0_, 1);
            obj.A = lambdaNew(smallIdx,1:3);
            obj.B = lambdaNew(smallIdx,4:6);
            obj.tf = lambdaNew(smallIdx,7);
%             obj.A = lambdaNew(bestItr,1:3);
%             obj.B = lambdaNew(bestItr,4:6);
%             obj.tf = lambdaNew(bestItr,7);
%             obj.E0 = best_E0;
            
        end
    end 
          
end

