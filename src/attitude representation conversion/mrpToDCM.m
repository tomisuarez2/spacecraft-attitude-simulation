function DCM = mrpToDCM(sigma)
%MRPTODCM Convert Modified Rodrigues Parameters attitude representation to a DCM.
%
%   Computes the Direction Cosine Matrix corresponding to a
%   modified rodrigues parameter representation (s1 s2 s3) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   sigma Modified Rodrigues Parameter representation [3x1]
%
%   Outputs
%   -------
%   DCM   Direction Cosine Matrix [3x3]
%
%   Examples
%   --------
%   DCM = mrpToDCM([0 0 0]');
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-22

    arguments
        sigma (3,1) double
    end

    s1 = sigma(1); s2 = sigma(2); s3 = sigma(3);
    s1Squared = s1*s1;
    s2Squared = s2*s2;
    s3Squared = s3*s3;
    sSquared  = s1Squared + s2Squared + s3Squared;
    A = 1 - sSquared;
    ASquared = A*A;
    B = 1 + sSquared;
    BSquared = B*B;

    DCM = zeros(3);

    DCM(1,1) = 4*(s1Squared - s2Squared - s3Squared) + ASquared;
    DCM(2,1) = 8*s2*s1 - 4*s3*A;
    DCM(3,1) = 8*s3*s1 + 4*s2*A;

    DCM(1,2) = 8*s1*s2 + 4*s3*A;
    DCM(2,2) = 4*(-s1Squared + s2Squared - s3Squared) + ASquared;
    DCM(3,2) = 8*s3*s2 - 4*s1*A;

    DCM(1,3) = 8*s1*s3 - 4*s2*A;
    DCM(2,3) = 8*s2*s3 + 4*s1*A;
    DCM(3,3) = 4*(-s1Squared - s2Squared + s3Squared) + ASquared;
    
    DCM = DCM/BSquared;
end
