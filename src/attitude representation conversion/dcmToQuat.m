function beta = dcmToQuat(DCM, solutions)
%DCMTOQUAT Convert a DCM attitude representation to Unit Quaternion.
%
%   Computes unit quaternion representation (b0 b1 b2 b3) corresponding 
%   to a Direction Cosine Matrix that transforms vector coordinates from 
%   the inertial frame N to the body frame B.
%
%   v_B = DCM * v_N 
% 
%   Inputs
%   ------
%   DCM            Direction Cosine Matrix [3x3]
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
%   DCM = dcmToQuat([0 1 0;-1 0 0;1 0 0]);
%
%   Assumption
%   ----------
%   DCM must be an orthonormal matrix, with det(DCM) == 1.
%
%   References
%   ----------
%   [1] Markley, F. Landis.
%       Unit Quaternion from Rotation Matrix.
%       JOURNAL OF GUIDANCE, CONTROL, AND DYNAMICS.
%       Vol. 31, No. 2, March-April 2008.
%       DOI: 10.2514/1.31730
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-19

    arguments
        DCM (3,3) double
        solutions string = 'short'
    end

    % Sheppard Method
    tr      = trace(DCM);
    greater = [tr DCM(1,1) DCM(2,2) DCM(3,3)];

    % Find index of greatest element
    beta     = zeros(4,1);
    greatest = greater(1);
    idx      = 1;
    for i=2:4
        if greater(i) > greatest
            greatest = greater(i);
            idx      = i;
        end
    end

    switch idx
        case 1
            beta(1) = sqrt(1 + tr)/2;
            beta(2) = (DCM(2,3) - DCM(3,2)) / (4*beta(1));
            beta(3) = (DCM(3,1) - DCM(1,3)) / (4*beta(1));
            beta(4) = (DCM(1,2) - DCM(2,1)) / (4*beta(1));
        case 2
            beta(2) = sqrt(1 + 2*DCM(1,1) - tr)/2;
            beta(1) = (DCM(2,3) - DCM(3,2)) / (4*beta(2));
            beta(3) = (DCM(1,2) + DCM(2,1)) / (4*beta(2));
            beta(4) = (DCM(3,1) + DCM(1,3)) / (4*beta(2));
        case 3
            beta(3) = sqrt(1 + 2*DCM(2,2) - tr)/2;
            beta(1) = (DCM(3,1) - DCM(1,3)) / (4*beta(3));
            beta(2) = (DCM(1,2) + DCM(2,1)) / (4*beta(3));
            beta(4) = (DCM(2,3) + DCM(3,2)) / (4*beta(3));
        case 4
            beta(4) = sqrt(1 + 2*DCM(3,3) - tr)/2;
            beta(1) = (DCM(1,2) - DCM(2,1)) / (4*beta(4));
            beta(2) = (DCM(3,1) + DCM(1,3)) / (4*beta(4));
            beta(3) = (DCM(2,3) + DCM(3,2)) / (4*beta(4));
    end
    
    % Return all quaternion sign combinations if requested
    switch solutions
        case 'short'
            % Do nothing.
        case 'long'
            beta = -beta;
        case 'all'
            beta = [beta -beta];
        otherwise
            error('Use: dcmToQuat([DCM,"short"/"long"/"all")');
    end

end
