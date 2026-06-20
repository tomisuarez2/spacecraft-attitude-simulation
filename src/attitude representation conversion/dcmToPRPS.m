function prps = dcmToPRPS(DCM, solutions)
%DCMTOPRPS Convert a DCM to Principal Rotation Parameter Set.
%
%   Computes Principal Rotation Parameter Set values (phi,e1,e2,e3) 
%   corresponding to a Direction Cosine Matrix that transforms vector 
%   coordinates from the inertial frame N to the body frame B.  
%
%   v_B = DCM * v_N 
%
%   If they are not singular (DCM equals identity matrix), it returns all
%   zero values both in principal axis of rotation and rotation angle.
% 
%   Inputs
%   ------
%   DCM       Direction Cosine Matrix [3x3]
%   solutions Optional, default 'short' to return short rotation,
%             'all' to return all 4 possible sign variations.
%
%   Outputs
%   -------
%   prps      Principal rotation parameter set [phi,e1,e2,e3], 
%             short rotation [1x4] or all possible solutions [4x4] [rad]
%             First column corresponds to angle, the remaining columns
%             to axis components in each row.
%
%   Examples
%   --------
%   DCM = dcmToPRPS([0 1 0;-1 0 0;1 0 0]);
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
        solutions string = 'short'
    end

    phi = acos((trace(DCM) - 1)/2);

    % If the problem is not singular
    if phi ~= 0 && phi ~= pi 
        E   = [DCM(2,3) - DCM(3,2) ... 
               DCM(3,1) - DCM(1,3) ... 
               DCM(1,2) - DCM(2,1)];
        % Return all possible sets if requested
        switch solutions
            case 'short'
                % Do nothing.
            case 'all'
                phi = [phi phi-2*pi -phi -phi+2*pi];
            otherwise
                error('Use: dcmToPRPS(DCM,"short"/"all")');
        end
        s = 1 ./ (2 * sin(phi));
        axis = s'.*E';
        prps = [phi' axis'];
    else
        prps = zeros(1,4);
    end

end
