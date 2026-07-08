function sigmaDot = computeMRPKinematics(sigma, omega_B)
%COMPUTEMRPKINEMATICS Compute MRP kinematics from body angular velocity.
%
%   Computes the time rate of change of an MRP rigid body attitude representation based on an instantaneous
%   body frame angular velocity vector.
%   Implements the kinematics given in Eq. (3.155) of [1].
%
%   Inputs
%   ------
%   sigma    Spacecraft MRP attitude representation [3x1]. 
%   omega_B  Spacecraft angular velocity expressed in the body frame [3x1] [rad/s].
%
%   Outputs
%   -------
%   sigmaDot Instantaneous time rate of change MRP attitude set [3x1] 
%
%   Note
%   ----
%   Assumes the body angular velocity vector is expressed in the body-fixed
%   reference frame.
%
%   Implements
%
%   σ̇ = 1/4 B(σ)ω_B
%
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
        sigma   (3,1) double {mustBeFinite}
        omega_B (3,1) double {mustBeFinite}
    end
    
    B = computeBMRPMatrix(sigma);
    sigmaDot = B*omega_B/4;

end
