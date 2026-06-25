function [tOut, yOut] = rkf45Integrator(func, tSpan, y0, tolerance, normFunc)
%RKF45INTEGRATOR Adaptive Runge-Kutta-Fehlberg 4(5) ODE integrator.
%
%   Integrates a system of first-order ordinary differential equations
%
%       dy/dt = f(t,y)
%
%   using the embedded Runge-Kutta-Fehlberg 4(5) method with adaptive
%   step-size control.
%
%   Syntax
%   ------
%   [tOut, yOut] = rkf45Integrator(func, tSpan, y0)
%   [tOut, yOut] = rkf45Integrator(func, tSpan, y0, tolerance)
%   [tOut, yOut] = rkf45Integrator(func, tSpan, y0, tolerance, normFunc)
%
%   Inputs
%   ------
%   func        Function handle that evaluates the state derivative:
%
%                   dydt = func(t,y)
%
%               where y is an [m×1] state vector.
%
%   tSpan       Two-element vector [t0 tf] defining the integration
%               interval [s].
%
%   y0          Initial state vector [m×1].
%
%   tolerance   Relative error tolerance used by the adaptive step-size
%               controller.
%
%               Default: 1e-8
%
%   normFunc    Function handle that normalizes the state after each
%               intgration step
%
%   Outputs
%   -------
%   tOut        Row vector containing the accepted integration times [s].
%
%   yOut        State history matrix [m×n]. Each column corresponds to
%               the state evaluated at the matching time in tout.
%
%   Notes
%   -----
%   The local truncation error is estimated from the difference between
%   the embedded fourth-order and fifth-order Runge-Kutta solutions.
%
%   References
%   ----------
%   [1] Curtis, H. D.
%       Orbital Mechanics for Engineering Students.
%       4th Edition, Elsevier, 2020.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-25

    arguments
        func (1,1) function_handle
        tSpan (1,2) double {mustBeFinite}
        y0 (:,1) double {mustBeFinite}
        tolerance (1,1) double {mustBeFinite,mustBePositive} = 1e-8
        normFunc (1,1) function_handle = @(y) y;
    end
    
    if tSpan(2) <= tSpan(1)
        error('rkf45Integrator:InvalidTimeSpan', 'tspan must satisfy tf > t0.');
    end

    a = [0 1/4 3/8 12/13 1 1/2];
    
    b = [   0           0          0          0         0
           1/4          0          0          0         0
           3/32        9/32        0          0         0
         1932/2197 -7200/2197  7296/2197      0         0
         439/216       -8      3680/513   -845/4104     0
          -8/27         2     -3544/2565  1859/4104  -11/40];
      
    c4 = [25/216  0  1408/2565    2197/4104   -1/5    0  ];
    
    c5 = [16/135  0  6656/12825  28561/56430  -9/50  2/55];

    t0 = tSpan(1);
    tf = tSpan(2);

    t = t0;
    y = y0;
    tOut = t;
    yOut = y;
    h = 0.01; % Assumed initial time step.

    k = 0;

    while t < tf
        k = k + 1;
        hMin = 16*eps(t);
        ti = t;
        yi = y;
        f  = zeros(length(y0),6);
        
        % Evaluate the time derivative(s) at six points within the current interval:
        for i = 1:6
            tInner = ti + a(i)*h;
            yInner = yi;
            for j = 1:i-1
                yInner = yInner + h*b(i,j)*f(:,j);
            end
            f(:,i) = func(tInner, yInner);
        end
        
        % Compute the maximum truncation error:
        te    = h*f*(c4' - c5'); % Difference between 4th and 5th order solutions
        teMax = max(abs(te));
        
        % Compute the allowable truncation error:
        yMax      = max(abs(y));
        teAllowed = tolerance*max(yMax,1.0);
        
        % Compute the fractional change in step size:
        delta = (teAllowed/(teMax + eps))^(1/5);
        
        % If the truncation error is in bounds, then update the solution:
        if teMax <= teAllowed
            h = min(h, tf-t);
            t = t + h;
            y = yi + h*f*c5';
            % Normalization
            y = normFunc(y);
            tOut(k) = t;
            yOut(k) = y;
        end

        % Update the time step:
        h = min(delta*h, 4*h);
        if h < hMin
            fprintf(['\n\n Warning: Step size fell below its minimum\n'...
                     ' allowable value (%g) at time %g.\n\n'], hMin, t)
            return
        end
    end    
end
