function [tOut, yOut] = rk4Integrator(func, tSpan, y0, stateFunc, h)
%RK4INTEGRATOR Fixed-step, fourth-order Runge-Kutta ODE integrator.
%
%   Integrates a system of first-order ordinary differential equations
%
%       dy/dt = f(t,y)
%
%   using the classical fourth-order Runge-Kutta (RK4) method.
%
%   Syntax
%   ------
%   [tOut, yOut] = rk4Integrator(func, tSpan, y0)
%   [tOut, yOut] = rk4Integrator(func, tSpan, y0, stateFunc)
%   [tOut, yOut] = rk4Integrator(func, tSpan, y0, stateFunc, h)
%
%   Inputs
%   ------
%   func        Function handle that evaluates the state derivative:
%
%                   dydt = func(t,y)
%
%   tSpan       Two-element vector [t0 tf] defining the integration
%               interval [s].
%
%   y0          Initial state vector [m x 1].
%
%   stateFunc   Function handle applied to the state after each
%               integration step.
%
%               Default: @(y) y
%
%   h           Fixed integration step size [s].
%
%               Default: 0.01
%
%   Outputs
%   -------
%   tOut        Row vector containing the integration times [s].
%
%   yOut        State history matrix [m x n]. Each column corresponds
%               to the state evaluated at the matching time in tOut.
%
%   Notes
%   -----
%   The classical RK4 method has a local truncation error of O(h^5)
%   and a global truncation error of O(h^4), assuming sufficient
%   smoothness of the solution.
%
%   The integration step is fixed, except that the final step may
%   be shortened to terminate exactly at tf.
%
%   References
%   ----------
%   [1] Curtis, H. D.
%       Orbital Mechanics for Engineering Students.
%       4th Edition, Elsevier, 2020.
%
%   Author: Tomás M. Suárez

    arguments
        func      (1,1) function_handle
        tSpan     (1,2) double {mustBeFinite}
        y0        (:,1) double {mustBeFinite}
        stateFunc (1,1) function_handle = @(y) y
        h         (1,1) double {mustBeFinite,mustBePositive} = 0.01
    end

    if tSpan(2) <= tSpan(1)
        error('rk4Integrator:InvalidTimeSpan', ...
              'tSpan must satisfy tf > t0.');
    end

    t0 = tSpan(1);
    tf = tSpan(2);

    % Initialize integration
    t = t0;
    y = y0;

    tOut = t;
    yOut = y;

    k = 1;

    while t < tf

        % Adjust the final step to terminate exactly at tf
        hi = min(h, tf - t);

        % Evaluate the four RK stages
        k1 = func(t, y);

        k2 = func(t + hi/2, ...
                  y + hi*k1/2);

        k3 = func(t + hi/2, ...
                  y + hi*k2/2);

        k4 = func(t + hi, ...
                  y + hi*k3);

        % Update the state using the fourth-order RK formula
        y = y + (hi/6)*(k1 + 2*k2 + 2*k3 + k4);

        % Apply state functionality
        y = stateFunc(y);

        % Update time
        t = t + hi;

        % Store the integration results
        k = k + 1;

        tOut(k) = t;
        yOut(:,k) = y;

    end

end
