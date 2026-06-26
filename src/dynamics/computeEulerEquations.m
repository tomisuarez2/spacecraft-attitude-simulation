function dwdt = computeEulerEquations(I, w, torque)
%COMPUTEEULEREQUATION Compute the body angular velocity based on Euler
%equations
%
%   Computes the inertial angular velocity rate based on Euler equations of motion.
%
%   Inputs
%   ------
%   I      Inertia matrix [3x3] [kg m^2]
%   w      Body frame angular velocity vector [3x1] [rad/s]
%   torque External torque vector [Nm]
%
%   Outputs
%   -------
%   dwdt   Body frame angular velocity inertial derivative [3x1] [rad/s^2]
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
        I (3,3) double {mustBePhysicalInertia}
        w (3,1) double {mustBeFinite}
        torque (3,1) double {mustBeFinite}
    end

    dwdt(1,1) = (-(I(3,3) - I(2,2))*w(2)*w(3) + torque(1))/I(1,1);
    dwdt(2,1) = (-(I(1,1) - I(3,3))*w(3)*w(1) + torque(2))/I(2,2);
    dwdt(3,1) = (-(I(2,2) - I(1,1))*w(1)*w(2) + torque(3))/I(3,3);

end
