function DCM = euler313ToDCM(varargin)
%EULER313TODCM Convert Euler Angles 3-1-3 sequence to a DCM.
%
%   Computes the Direction Cosine Matrix corresponding to a
%   3-1-3 Euler angle sequence (W-i-w) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   angles 3-1-3 Longitude of the ascending node (W), 
%                inclination (i) and argument of perigee (w) 
%                sequence [1x3] [rad]
%   angles 3-1-3 Longitude of the ascending node (W), 
%                inclination (i) and argument of perigee (w) 
%                as different arguments [rad]
%
%   Outputs
%   -------
%   DCM    Direction Cosine Matrix [3x3]
%
%   Examples
%   --------
%   DCM = euler313ToDCM([pi/6 pi/18 -pi/2]);
%
%   DCM = euler313ToDCM(pi/6, pi/18, -pi/2);
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
        error('Use: euler313ToDCM([W i w]) or euler313ToDCM(W,i,w)');
    end
    
    cW = cos(angles(1));
    sW = sin(angles(1));

    ci = cos(angles(2));
    si = sin(angles(2));

    cw = cos(angles(3));
    sw = sin(angles(3));

    DCM = [ cw*cW - sw*ci*sW,   cw*sW + sw*ci*cW,  sw*si;
           -sw*cW - cw*ci*sW,  -sw*sW + cw*ci*cW,  cw*si;
            si*sW,             -si*cW,             ci];

end
