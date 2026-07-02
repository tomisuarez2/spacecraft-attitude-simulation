function B = computeBMRPMatrix(sigma)
%COMPUTEMRPBMatrix Compute B MRP kinematics matrix.
%
%   Computes the B kinematic matrix of an MRP rigid body attitude representation that
%   transforms body frame angular velocity in MRP derivative.
%   Implements the kinematics given in Eq. (3.154) and (3.155) of [1].
%
%   σ̇ = 1/4 B(σ)ω
%
%   Inputs
%   ------
%   sigma Current MRP attitude representation [3x1] 
%
%   Outputs
%   -------
%   B     Kinematic matrix of an MRP [3x3] 
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
        sigma (3,1) {mustBeA(sigma,["double","sym"])}
    end

    s1 = sigma(1); s1Sq = s1*s1;
    s2 = sigma(2); s2Sq = s2*s2;
    s3 = sigma(3); s3Sq = s3*s3;
    oneMinusSigma2 = 1 - s1Sq - s2Sq - s3Sq;
    
    s1s2 = s1*s2;
    s2s3 = s2*s3;
    s1s3 = s1*s3;
    
    % Expanded form of B(sigma) to avoid constructing the full matrix.
    B = [oneMinusSigma2 + 2*s1Sq, 2*(s1s2 - s3), 2*(s1s3 + s2);
         2*(s1s2 + s3), oneMinusSigma2 + 2*s2Sq, 2*(s2s3 - s1);
         2*(s1s3 - s2), 2*(s2s3 + s1),oneMinusSigma2 + 2*s3Sq];

end
