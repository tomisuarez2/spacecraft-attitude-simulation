function mustBePositiveDefinite(A)
%MUSTBEPOSITIVEDEFINITE Validate that a matrix is positive definite.
%
%   MUSTBEPOSITIVEDEFINITE(A) throws an error if A is not a 3-by-3
%   symmetric positive definite matrix.
%
%   Example
%   -------
%       arguments
%           A (3,3) double {mustBePositiveDefinite}
%       end
%

    % Check symmetry
    if ~issymmetric(A)
        error("mustBePositiveDefinite:NotSymmetric", ...
            "Value must be a symmetric matrix.");
    end

    % Check positive definiteness using Cholesky factorization
    [~, p] = chol(A);

    if p ~= 0
        error("mustBePositiveDefinite:NotPositiveDefinite", ...
            "Value must be a positive definite matrix.");
    end

end