function [mMeas, n, b] = sensorMeasurementModel(mTrue, nQ, M, bPrev, wQ)
%SENSORMEASUREMENTMODEL Generate a sensor measurement from a true measurement.
%
%   Generates a simulated sensor measurement from a true measurement
%   according to the following generic sensor model.
%
%       mMeas = (I + M)*mTrue + b + n
%
%   where I is the identity matrix, M represents systematic sensor
%   errors, b is the sensor bias, and n is additive measurement noise
%   modeled as White Gaussian Noise (WGN).
%
%   The elements of M represent:
%
%       - diagonal terms represent scale factor errors
%       - off-diagonal terms represent sensor axes misalignment.
%
%   The sensor bias is modeled as a discrete random walk
%
%       b(k) = b(k-1) + w(k)
%
%   where
%
%       w(k) ~ N(0,Qw)
%
%   Any of the optional error sources (M, bPrev or wQ) may be omitted by
%   passing an empty array ([]).
%
%   Inputs
%   ------
%   mTrue  True sensor measurement [Nx1].
%   nQ     Covariance matrix of the measurement noise [NxN].
%   M      Systematic error matrix containing scale factor and sensor axes misalignment errors [NxN]. May be empty.
%   bPrev  Previous bias value [Nx1]. May be empty.
%   wQ     Covariance matrix of the bias random walk process [NxN]. May be empty.
%
%   Outputs
%   -------
%   mMeas  Simulated sensor measurement [Nx1].
%   b      Updated sensor bias [Nx1].
%   n      Measurement noise [Nx1].
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-2026
    
    arguments
        mTrue  double {mustBeFinite}
        nQ     double {mustBeFinite}
        M      double {mustBeFinite}
        bPrev  double {mustBeFinite}
        wQ     double {mustBeFinite}
    end

    [mTRows, mTCols] = size(mTrue);
    assert(mTCols == 1, "True sensor measurement mTrue must be a column vector.")

    assert(isequal(size(nQ),[mTRows mTRows]), "WGN covariance matrix nQ must be [NxN], N is the number o elements of mTrue.")
    n = gaussianNoise(nQ,1);

    thereInstM     = isempty(M);
    thereInstbPrev = isempty(bPrev);
    thereInstwQ    = isempty(wQ);

    if thereInstM && thereInstbPrev && thereInstwQ
        mMeas = mTrue + n;
        b     = zeros(3,1);
        return;
    end

    if thereInstM
        mSystematic = mTrue;
    else
        assert(isequal(size(M),[mTRows mTRows]), "Misalignment and scale factor matrix M must be [NxN], N is the number o elements of mTrue.")
        mSystematic = mTrue + M*mTrue;
    end

    if thereInstbPrev
        bPrev = zeros(mTRows,1); 
    else
        assert(isequal(size(bPrev),[mTRows 1]), "Previous bias value bPrev must be [Nx1], N is the number o elements of mTrue.")
    end
        
    if thereInstwQ
        w = zeros(mTRows,1);
    else
        assert(isequal(size(wQ),[mTRows mTRows]), "WGN covariance matrix wQ must be [NxN], N is the number o elements of mTrue.")
        w = gaussianNoise(wQ,1);
    end

    b = bPrev + w;

    mMeas = mSystematic + b + n;

end

