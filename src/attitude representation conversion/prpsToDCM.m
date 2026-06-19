function DCM = prpsToDCM(varargin)
%PRPSTODCM Convert Principal Rotation Parameter Set to a DCM.
%
%   Computes the Direction Cosine Matrix corresponding to a
%   Principal Rotation Parameter Set (phi,e1,e2,e3) that transforms 
%   vector coordinates from the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   prps First column corresponds to angle, the remaining columns
%        to axis components in each row [1x4] [rad].
%   prps First argument corresponds to angle, the remaining
%        arguments to axis components [rad].
%
%   Outputs
%   -------
%   DCM  Direction Cosine Matrix [3x3]
%
%   Examples
%   --------
%   DCM = prpsToDCM([pi/6 1 0 0]);
%
%   DCM = prpsToDCM(pi/6,1,0,0);
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
        prps = varargin{1};
        assert(numel(prps)==4, 'The input array must have 4 elements.');
    elseif nargin == 4
        prps(1) = varargin{1};
        prps(2) = varargin{2};
        prps(3) = varargin{3};
        prps(4) = varargin{4};
    else
        error('Use: prpsToDCM([phi e1 e2 e3]) or prpsToDCM(phi,e1,e2,e3)');
    end

    % Axis of rotation normalization
    if any(prps(2:4))
        prps(2:4) = prps(2:4)/norm(prps(2:4));
    end
    
    cphi = cos(prps(1));
    sphi = sin(prps(1));

    S = 1 - cphi;

    e1 = prps(2);
    e2 = prps(3);
    e3 = prps(4);

    DCM      = zeros(3);
    DCM(1,1) = e1^2*S + cphi;
    DCM(2,1) = e1*e2*S - e3*sphi;
    DCM(3,1) = e1*e3*S + e2*sphi;
    DCM(1,2) = e1*e2*S + e3*sphi;
    DCM(2,2) = e2^2*S + cphi;
    DCM(3,2) = e2*e3*S - e1*sphi;
    DCM(3,3) = e3^2*S + cphi;
    DCM(2,3) = e2*e3*S + e1*sphi;
    DCM(1,3) = e1*e3*S - e2*sphi;
    
end
