function mustBeDCM(DCM)
%ISBEDCM Validate Direction Cosine Matrix (DCM).
%
%   Validates that the input is a valid 3-by-3 Direction Cosine Matrix.
%   A valid DCM must:
%
%       1. Be a real 3-by-3 matrix.
%       2. Be orthogonal.
%       3. Have determinant equal to +1.
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-03

    tolerance = 1e-10;

    if ~isequal(size(DCM),[3 3])
        error("Direction Cosine Matrix must be a 3x3 matrix.");
    end

    if ~isreal(DCM)
        error("Direction Cosine Matrix must contain real values.");
    end

    if norm(DCM'*DCM-eye(3),"fro") > tolerance
        error("Direction Cosine Matrix must be orthogonal.");
    end

    if abs(det(DCM)-1) > tolerance
        error("Direction Cosine Matrix must have determinant equal to +1.");
    end

end

