function dotOmega_B = computeEulerEquations(I, omega_B, torque)
%COMPUTEEULEREQUATION Compute the body angular velocity based on Euler
%equations
%
%   Computes the inertial angular velocity rate based on Euler equations of motion.
%   Implements the dynamics of Eq. (4.33a/b/c) of [1].
%
%   Inputs
%   ------
%   I           Spacecraft inertia matrix expressed in the body frame [3x3] [kg m^2].
%   omega_B     Spacecraft angular velocity expressed in the body frame [3x1] [rad/s].
%   torque      Spacecraft external body frame torque, B frame components [3x1] [Nm].
%
%   Outputs
%   -------
%   dotOmega_B  Spacecraft time derivative of the body angular velocity, B frame components [3x1] [rad/s^2]
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
        I       (3,3) double {mustBePhysicalInertia}
        omega_B (3,1) double {mustBeFinite}
        torque  (3,1) double {mustBeFinite}
    end

    dotOmega_B(1,1) = (-(I(3,3) - I(2,2))*omega_B(2)*omega_B(3) + torque(1))/I(1,1);
    dotOmega_B(2,1) = (-(I(1,1) - I(3,3))*omega_B(3)*omega_B(1) + torque(2))/I(2,2);
    dotOmega_B(3,1) = (-(I(2,2) - I(1,1))*omega_B(1)*omega_B(2) + torque(3))/I(3,3);

end
