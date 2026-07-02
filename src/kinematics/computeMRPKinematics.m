function sigmaDot = computeMRPKinematics(sigma, w)
%COMPUTEMRPKINEMATICS Compute MRP kinematics from body angular velocity.
%
%   Computes the time rate of change of an MRP rigid body attitude representation based on an instantaneous
%   body frame angular velocity vector.
%   Implements the kinematics given in Eq. (3.155) of [1].
%
%   Inputs
%   ------
%   sigma    Current MRP attitude representation [3x1] 
%   w        Current body angular velocity, B frame components [3x1] [rad/s]
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
%   σ̇ = 1/4 B(σ)ω
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
        sigma (3,1) double {mustBeFinite}
        w     (3,1) double {mustBeFinite}
    end
    
    B = computeBMRPMatrix(sigma);
    sigmaDot = B*w/4;

end
