function u = unconstrainedControl(K, P, I, sigmaE, w, wr, dwr, L)
%UNCONSTRAINEDCONTROL Compute the unconstrained feedback control torque for
%spacecraft attitude tracking.
%
%   Computes the unconstrained attitude tracking control torque based on the
%   Modified Rodrigues Parameters (MRP) attitude error and the reference body
%   angular velocity profile.
%   Implements the unconstrained control law given in Eq. (8.84) of [1].
%
%   u = -K*sigmaE - P*(w - wr) + I*(dwr - skew(w)*wr) + skew(wr)*I*w - L
%
%   Inputs
%   ------
%   K      Attitude error proportional gain [1x1] [Nm]
%   P      Symmetric positive-definite rate feedback gain matrix [3x3] [Nm/(rad/s)]
%   I      Spacecraft inertia matrix expressed in the body frame [3x3] [kg m^2]
%   sigmaE MRP attitude tracking error (B -> R) [3x1]
%   w      Current body angular velocity, B frame components [3x1] [rad/s]
%   wr     Reference body angular velocity, R frame componentes [3x1] [rad/s]
%   dwr    Time derivative of the reference body angular velocity, R frame components [3x1] [rad/s^2]
%   L      External body frame torque, B frame components [3x1] [Nm]
%
%   Output
%   ------
%   u     Unconstrained control torque, B frame components [3x1] [Nm]
%
%   Note
%   ----
%   sigmaE allows us to compute BR = DCM(sigmaE) where v_B = BR * v_R.
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-29

    arguments
        K       (1,1) double {mustBeNonnegative, mustBeFinite}
        P       (3,3) double {mustBeFinite, mustBePositiveDefinite}
        I       (3,3) double {mustBeFinite, mustBePhysicalInertia}
        sigmaE (3,1) double {mustBeFinite}
        w       (3,1) double {mustBeFinite}
        wr      (3,1) double {mustBeFinite}
        dwr     (3,1) double {mustBeFinite}
        L       (3,1) double {mustBeFinite}
    end

    BR   = mrpToDCM(sigmaE);
    Bwr  = BR * wr;
    Bdwr = BR *dwr;

    u    = - K*sigmaE ...
           - P*(w - Bwr) ...
           + I*(Bdwr - skew(w)*Bwr) ...
           + skew(Bwr)*I*w ...
           - L;

end

