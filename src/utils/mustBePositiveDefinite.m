function mustBePositiveDefinite(A)
%MUSTBEPOSITIVEDEFINITE Validate that a matrix is positive definite.
%
%   MUSTBEPOSITIVEDEFINITE(A) throws an error if A is not a n-by-n
%   symmetric positive definite matrix.
%
%   Example
%   -------
%       arguments
%           A (n,n) double {mustBePositiveDefinite}
%       end
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-2026

    arguments
        A double {mustBeFinite}
    end

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