function n = gaussianNoise(Q,M)
%GAUSSIANNOISE Generate M zero-mean White Gaussian Noise (WGN) samples.
%
%   Generates M zero-mean Gaussian random vectors with covariance matrix Q.
%   The generated noise satisfies
%
%       n ~ N(0,Q)
%
%   where Q is a symmetric positive-definite covariance matrix.
%
%   The noise sample is generated using the Cholesky factorization
%
%       Q = L*L'
%
%   such that
%
%       n = L*r
%
%   where
%
%       r ~ N(0,I)
%
%   Inputs
%   ------
%   Q   Covariance matrix of the Gaussian noise [NxN].
%   M   Number of samples [1x1].
%
%   Outputs
%   -------
%   n   Gaussian noise samples with covariance Q [NxM].
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-03

    arguments
        Q       double
        M (1,1) double {mustBeFinite}
    end

    [QRows,QCols] = size(Q);

    assert(QRows == QCols, ...
        "Covariance matrix Q must be square.")

    mustBePositiveDefinite(Q);

    L = chol(Q,'lower');

    n = L*randn(QRows,M);

end

