function dw = computeEulerEquations(I, w, torque)
%COMPUTEEULEREQUATION Compute the body angular velocity based on Euler
%equations
%
%   Computes the inertial angular velocity rate based on Euler equations of motion.
%   Implements the dynamics of Eq. (4.33a/b/c) of [1].
%
%   Inputs
%   ------
%   I      Spacecraft inertia matrix expressed in the body frame [3x3] [kg m^2]
%   w      Current body angular velocity, B frame components [3x1] [rad/s]
%   torque External body frame torque, B frame components [3x1] [Nm]
%
%   Outputs
%   -------
%   dw     Time derivative of the body angular velocity, B frame components [3x1] [rad/s^2]
%
%   Notes
%   -----
%   Inertia matrix must be diagonal and physically pheasible.
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-25

    arguments
        I      (3,3) double {mustBePhysicalInertia}
        w      (3,1) double {mustBeFinite}
        torque (3,1) double {mustBeFinite}
    end

    dw(1,1) = (-(I(3,3) - I(2,2))*w(2)*w(3) + torque(1))/I(1,1);
    dw(2,1) = (-(I(1,1) - I(3,3))*w(3)*w(1) + torque(2))/I(2,2);
    dw(3,1) = (-(I(2,2) - I(1,1))*w(1)*w(2) + torque(3))/I(3,3);

end
