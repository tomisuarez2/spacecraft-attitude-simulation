function sigma = dcmToMRP(DCM)
%DCMTOMRP Convert a DCM attitude representation to Modified Rodrigues Parameter.
%
%   Computes modified rodrigues parameter (s1 s2 s3) corresponding 
%   to a Direction Cosine Matrix that transforms vector coordinates from 
%   the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   DCM         Direction Cosine Matrix [3x3]
%
%   Outputs
%   -------
%   [s1 s2 s3]' Modified Rodrigues Parameter representation [3x1]
%
%   Examples
%   --------
%   DCM = dcmToMRP([0 1 0;-1 0 0;1 0 0]);
%
%   Assumption
%   ----------
%   DCM must be an orthonormal matrix, with det(DCM) == 1.
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
        DCM (3,3) double
    end

    zitta = sqrt(trace(DCM)+1);
    if zitta == 0
        beta  = dcmToQuat(DCM);
        sigma = beta(2:4)/(1 + beta(1));
    else
        sigma = [DCM(2,3)-DCM(3,2), DCM(3,1)-DCM(1,3), DCM(1,2)-DCM(2,1)];
        sigma = sigma'/(zitta*(zitta + 2));
    end
 
end
