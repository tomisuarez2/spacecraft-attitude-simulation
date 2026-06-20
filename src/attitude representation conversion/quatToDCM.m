function DCM = quatToDCM(beta)
%QUATTODCM Convert Unit Quaternion attiude representation to a DCM.
%
%   Computes the Direction Cosine Matrix corresponding to a
%   unit quaternion representation (b0 b1 b2 b3) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   beta Unit Quaternion representation, scalar first convention [1x4]
%
%   Outputs
%   -------
%   DCM  Direction Cosine Matrix [3x3]
%
%   Examples
%   --------
%   DCM = quatToDCM([1 0 0 0]);
%
%   DCM = quatToDCM(1, 0, 0, 0);
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-20

    arguments
        beta (1,4) double
    end

    % Normalization
    n = norm(beta);
    if n
        beta = beta/n;
    else
        error('Zero norm quaternion.')
    end

    DCM = [beta(1)^2 + beta(2)^2 - beta(3)^2 - beta(4)^2,    2*(beta(2)*beta(3) + beta(1)*beta(4)),            2*(beta(2)*beta(4) - beta(1)*beta(3));
           2*(beta(2)*beta(3) - beta(1)*beta(4)),            beta(1)^2 - beta(2)^2 + beta(3)^2 - beta(4)^2,    2*(beta(3)*beta(4) + beta(1)*beta(2));
           2*(beta(2)*beta(4) + beta(1)*beta(3)),            2*(beta(3)*beta(4) - beta(1)*beta(2)),            beta(1)^2 - beta(2)^2 - beta(3)^2 + beta(4)^2];

end

