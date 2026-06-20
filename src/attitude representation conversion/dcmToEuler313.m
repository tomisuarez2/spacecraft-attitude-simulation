function [W, i, w] = dcmToEuler313(DCM)
%DCMTOEULER313 Convert a DCM to Euler Angles 3-1-3 sequence.
%
%   Computes 3-1-3 Euler angle sequence (W-i-w) corresponding 
%   to a Direction Cosine Matrix that transforms vector coordinates from 
%   the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   DCM    Direction Cosine Matrix [3x3]
%
%   Outputs
%   -------
%   [W i w] 3-1-3 Longitude of the ascending node (W), 
%           inclination (i) and argument of perigee (w) 
%           sequence [1x3] [rad]
%
%   Examples
%   --------
%   DCM = dcmToEuler313([0 1 0;-1 0 0;1 0 0]);
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
%   Date: 2026-06-19

    arguments
        DCM (3,3) double
    end
    
    W  = atan2(DCM(3,1), -DCM(3,2));
    i  = acos(DCM(3,3));            
    w  = atan2(DCM(1,3), DCM(2,3));  

end

