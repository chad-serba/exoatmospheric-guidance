classdef engine_thrust
    %ENGINE_THRUST Defines the thrust curve of the engine, defined by a max
    %value and a rise time. 
    %   Currently the thrust curve is just linear from zero to maximum
    %   thrust over the rise time. Could expand to be more correct, but
    %   this is a quick-and-dirty implementation.
    
    properties
        rise_time
        thust_curve
        max_thrust
    end
    
    methods
        function obj = engine_thrust(engineRiseTime, engineMaxThrust)
            %ENGINE_THRUST Construct an instance of this class
            %   Detailed explanation goes here
            obj.rise_time = engineRiseTime;
            obj.max_thrust = engineMaxThrust;
            obj.thust_curve = polyfit([0, obj.rise_time], [0, obj.max_thrust], 1);
        end
        
        function thrust = getThrust(obj,t_from_ign)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if t_from_ign < 0; error('t_from_ign cannot be negative'); end
            
            if t_from_ign < obj.rise_time
                thrust = polyval(obj.thust_curve, t_from_ign);
            else
                thrust = obj.max_thrust;
            end
        end
    end
end

