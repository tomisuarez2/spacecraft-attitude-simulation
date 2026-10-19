function sigma = quatToMRP(beta)
%QUATTOMRP Convert Unit Quaternion attitude representation Modified Rodrigues Parameter.
%
%   Computes modified rodrigues parameter (s1 s2 s3) corresponding 
%   to a unit quaternion representation (b0 b1 b2 b3) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%   Implements method given in Eq. (3.142) of [1].
% 
%   Inputs
%   ------
%   beta Unit Quaternion representation, scalar first convention [4x1]
%
%   Outputs
%   -------
%   [s1 s2 s3]' Modified Rodrigues Parameter representation [3x1]
%
%   Examples
%   --------
%   sigma = quatToMRP([1 0 0 0]');
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       4th Edition, AIAA, 2018.
%
%   Author: Tomás M. Suárez
%   Date: 2026-10-19

    arguments
        beta (4,1) double
    end

    B = 1 + beta(1);
    sigma = beta(2:4) / B;

end
