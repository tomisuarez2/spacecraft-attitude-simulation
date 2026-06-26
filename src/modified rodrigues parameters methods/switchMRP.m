function sigmaS = switchMRP(sigma)
%SWITCHMRP Get MRP attitude representation short rotation.
%
%   Switch between an MPR set an its shadow set in order to get a short
%   rotation representation if nedeed.
%
%   sigmaS = -sigma/norm(sigma)^2
%
%   Inputs
%   ------
%   sigma  Modified Rodrigues Parameter representation [3x1]
%
%   Outputs
%   -------
%   sigmaS Modified Rodrigues Parameter Shadow set representation [3x1]
%
%   Examples
%   --------
%   DCM = switchMRP([1 1 1]');
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-26

    arguments
        sigma (3,1) double {mustBeFinite}
    end

    sigmaNormSq = sigma(1)*sigma(1) + sigma(2)*sigma(2) + sigma(3)*sigma(3);
    if sqrt(sigmaNormSq) > 1
        sigmaS = -sigma/sigmaNormSq;
    else
        sigmaS = sigma;
    end
end

