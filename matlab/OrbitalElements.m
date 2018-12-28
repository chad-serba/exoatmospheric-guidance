function [ OE ] = OrbitalElements( r0, v0, mu )
%ORBITALELEMENTS Calculates orbital elements: a, h, i, N, Omega, e, w, theta
%   Input is initial distance, velocity, and mu

    if all(size(r0) == [1 3])
        r0 = r0';
    end
    
    if all(size(v0) == [1 3])
        v0 = v0';
    end
    
    r = sqrt(r0(1)^2 + r0(2)^2 + r0(3)^2);
    v = sqrt(v0(1)^2 + v0(2)^2 + v0(3)^2);

    vperp = (v0(1)*r0(1)+v0(2)*r0(2)+v0(3)*r0(3))/r;

    h = cross(r0, v0);
    h_ = sqrt(h(1)^2+h(2)^2+h(3)^2);

    i = acos(h(3)/h_)*180/pi;

    N = cross([0 0 1], h);
    N_ = sqrt(N(1)^2+N(2)^2+N(3)^2);

    Omega = acos(N(1)/N_)*180/pi;
    if N(2) < 0
        Omega = 360 - Omega;
    end

    e = (1/mu)*((v^2 - mu/r)*r0 - r*vperp*v0);
    e_ = sqrt(1+(h_^2/mu^2)*(v^2 - 2*mu/r));

    w = acos(N*e/(N_*e_))*180/pi;
    if e(3) < 0
        w = 360 - w;
    end

    theta = acos((1/e_)*(h_^2/(mu*r) - 1))*180/pi;
    if vperp < 0
        theta = 360 - theta;
    end

    a = (norm(h)^2/mu)*(1/(1-norm(e)^2));

    E = 2*atan(sqrt((1-e_)/(1+e_))*tan((theta*pi/180)/2));
    M0 = E - norm(e)*sin(E);

    OE.a = a;
    OE.h = h;
    OE.i = i;
    OE.N = N;
    OE.Omega = Omega;
    OE.e = e;
    OE.w = w;
    OE.theta = theta;
    OE.M0 = M0;

end

