function sigmaDot = computeMRPKinematics(sigma, w)
%COMPUTEMRPKINEMATICS Compute MRP kinematics from body angular velocity.
%
%   Computes the time rate of change of an MRP rigid body attitude representation based on an instantaneous
%   body frame angular velocity vector.
%
%   Inputs
%   ------
%   sigma    Instantaneous MRP attitude set [3x1] 
%   w        Body frame angular velocity vector [3x1] [rad/s]
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
        w (3,1) double {mustBeFinite}
    end

    sigma1 = sigma(1); sigma1Sq = sigma1*sigma1;
    sigma2 = sigma(2); sigma2Sq = sigma2*sigma2;
    sigma3 = sigma(3); sigma3Sq = sigma3*sigma3;
    oneMinusSigma2 = 1 - sigma1Sq - sigma2Sq - sigma3Sq;
    
    s1s2 = sigma1*sigma2;
    s2s3 = sigma2*sigma3;
    s1s3 = sigma1*sigma3;
    
    % Expanded form of B(sigma)*w to avoid constructing the full matrix.
    sigmaDot = [
    (oneMinusSigma2 + 2*sigma1Sq)*w(1) + 2*(s1s2 - sigma3)*w(2) + 2*(s1s3 + sigma2)*w(3);
    2*(s1s2 + sigma3)*w(1) + (oneMinusSigma2 + 2*sigma2Sq)*w(2) + 2*(s2s3 - sigma1)*w(3);
    2*(s1s3 - sigma2)*w(1) + 2*(s2s3 + sigma1)*w(2) + (oneMinusSigma2 + 2*sigma3Sq)*w(3);
    ];
    sigmaDot = sigmaDot/4;

end
