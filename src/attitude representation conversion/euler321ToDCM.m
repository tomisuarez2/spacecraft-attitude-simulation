function DCM = euler321ToDCM(varargin)
%EULER321TODCM Convert Euler Angles 3-2-1 sequence to a DCM.
%
%   Computes the Direction Cosine Matrix corresponding to a
%   3-2-1 Euler angle sequence (yaw-pitch-roll) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   angles 3-2-1 Yaw (psi), Pitch (theta) and Roll (phi) sequence [1x3] [rad]
%   angles 3-2-1 Yaw (psi), Pitch (theta) and Roll (phi) as different arguments [rad]
%
%   Outputs
%   -------
%   DCM    Direction Cosine Matrix [3x3]
%
%   Examples
%   --------
%   DCM = euler321ToDCM([pi/6 pi/18 -pi/2]);
%
%   DCM = euler321ToDCM(pi/6, pi/18, -pi/2);
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-19
    
    if nargin == 1
        angles = varargin{1};
        assert(numel(angles)==3, 'The input array must have 3 elements.');
    elseif nargin == 3
        angles(1) = varargin{1};
        angles(2) = varargin{2};
        angles(3) = varargin{3};
    else
        error('Use: euler321ToDCM([psi theta phi]) or euler321ToDCM(psi,theta,phi)');
    end
    
    cpsi = cos(angles(1));
    spsi = sin(angles(1));

    ctheta = cos(angles(2));
    stheta = sin(angles(2));

    cphi = cos(angles(3));
    sphi = sin(angles(3));

    DCM = [ctheta*cpsi,                     ctheta*spsi,                     -stheta;
           sphi*stheta*cpsi - cphi*spsi,  sphi*stheta*spsi + cphi*cpsi,  sphi*ctheta;
           cphi*stheta*cpsi + sphi*spsi,  cphi*stheta*spsi - sphi*cpsi,  cphi*ctheta];

end
