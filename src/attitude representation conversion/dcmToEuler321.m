function [psi, theta, phi] = dcmToEuler321(DCM)
%DCMTOEULER321 Convert a DCM to Euler Angles 3-2-1 sequence.
%
%   Computes 3-2-1 Euler angle sequence (yaw-pitch-roll) corresponding 
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
%   [psi theta phi] 3-2-1 Yaw (psi), Pitch (theta) and Roll (phi) sequence [1x3] [rad]
%
%   Examples
%   --------
%   DCM = dcmToEuler321([0 1 0;-1 0 0;1 0 0]);
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-19

    psi   = atan2(DCM(1,2), DCM(1,1)); 
    theta = asin(-DCM(1,3));           
    phi   = atan2(DCM(2,3), DCM(3,3));

end
