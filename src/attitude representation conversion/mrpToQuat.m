function beta = mrpToQuat(sigma, solutions)
%MRPTOQUAT Convert Modified Rodrigues Parameters attitude representation to Unit Quaternion.
%
%   Computes unit quaternion representation (b0 b1 b2 b3) corresponding 
%   to a modified rodrigues parameter representation (s1 s2 s3) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%   Implements method given in Eq. (3.143) of [1].
% 
%   Inputs
%   ------
%   sigma          Modified Rodrigues Parameter representation [3x1]
%   solutions      Optional, default 'short' to return short rotation,
%                  'long' to return long rotation,
%                  'all' to return both possible sign variations.
%
%   Outputs
%   -------
%   [b0 b1 b2 b3]' Unit Quaternion representation, scalar first convention, short rotation [4x1]
%                  or both possible solutions, short and large rotation [4x2]
%
%   Examples
%   --------
%   beta = mrpToQuat([0 0 0]');
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
        sigma (3,1) double
        solutions string = 'short'
    end
    
    s1 = sigma(1); s2 = sigma(2); s3 = sigma(3);
    sSquared  = s1*s1 + s2*s2 + s3*s3;
    A = 1 - sSquared;
    B = 1 + sSquared;
    
    beta = zeros(4,1);
    
    beta(1) = A / B;
    beta(2) = 2*s1 / B;
    beta(3) = 2*s2 / B;
    beta(4) = 2*s3 / B;
    
    % Return all quaternion sign combinations if requested
    switch solutions
        case 'short'
            % Do nothing.
        case 'long'
            beta = -beta;
        case 'all'
            beta = [beta -beta];
        otherwise
            error('Use: mrpToQuat([sigma,"short"/"long"/"all")');
    end

end
