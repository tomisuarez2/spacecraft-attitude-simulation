classdef MeasurementModel
    %MEASUREMENTMODEL Generic sensor measurement error model.
    %
    %   This class generates simulated sensor measurements from ideal
    %   measurements according to the following generic sensor model.
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
    %   Any of the optional error sources may be omitted by passing an
    %   empty array ([]).
    %
    %   Properties
    %   ----------
    %   NoiseCovariance
    %       Covariance matrix of the additive measurement noise [NxN].
    %       May be empty.
    %
    %   SystematicErrorMatrix
    %       Matrix containing scale factor and sensor axes misalignment
    %       errors [NxN]. May be empty.
    %
    %   Bias
    %       Current sensor bias [Nx1]. May be empty.
    %
    %   BiasRandomWalkCovariance
    %       Covariance matrix of the bias random walk process [NxN].
    %       May be empty.
    %
    %   Author: Tomás M. Suárez
    %   Date: 2026-07-05

    properties (SetAccess = private, GetAccess = public)
        NoiseCovariance
        SystematicErrorMatrix
        Bias
        BiasRandomWalkCovariance
    end

    methods

        function obj = MeasurementModel( ...
                noiseCovariance,...
                systematicErrorMatrix,...
                initialBias,...
                biasRandomWalkCovariance)

            arguments
                noiseCovariance          double {mustBeFinite} = []
                systematicErrorMatrix    double {mustBeFinite} = []
                initialBias              double {mustBeFinite} = []
                biasRandomWalkCovariance double {mustBeFinite} = []
            end

            obj.NoiseCovariance            = noiseCovariance;
            obj.SystematicErrorMatrix      = systematicErrorMatrix;
            obj.Bias                       = initialBias;
            obj.BiasRandomWalkCovariance   = biasRandomWalkCovariance;

        end

        function [obj,mMeas,n] = apply(obj,mTrue)
            %APPLY Apply the measurement model.
            %
            %   Applies deterministic and stochastic sensor errors to an
            %   ideal measurement.
            %
            %   Inputs
            %   ------
            %   mTrue
            %       True sensor measurement [Nx1].
            %
            %   Outputs
            %   -------
            %   mMeas
            %       Simulated sensor measurement [Nx1].
            %
            %   n
            %       Additive measurement noise [Nx1].

            arguments
                obj
                mTrue (:,1) double {mustBeFinite}
            end

            N = length(mTrue);

            % Measurement noise
            if isempty(obj.NoiseCovariance)
                n = zeros(N,1);
            else
                assert(isequal(size(obj.NoiseCovariance),[N N]), ...
                    "Noise covariance matrix must be [NxN].");
                n = gaussianNoise(obj.NoiseCovariance,1);
            end

            % Systematic errors
            if isempty(obj.SystematicErrorMatrix)
                mSystematic = mTrue;
            else
                assert(isequal(size(obj.SystematicErrorMatrix),[N N]), ...
                    "Systematic error matrix must be [NxN].");
                mSystematic = mTrue + obj.SystematicErrorMatrix*mTrue;
            end

            % Bias
            if isempty(obj.Bias)
                obj.Bias = zeros(N,1);
            else
                assert(isequal(size(obj.Bias),[N 1]), "Bias must be [Nx1].");
            end

            % Bias random walk
            if isempty(obj.BiasRandomWalkCovariance)
                w = zeros(N,1);
            else
                assert(isequal(size(obj.BiasRandomWalkCovariance),[N N]), ...
                    "Bias random walk covariance matrix must be [NxN].");
                w = gaussianNoise( ...
                    obj.BiasRandomWalkCovariance,1);
            end

            % Update bias
            obj.Bias = obj.Bias + w;

            % Final measurement
            mMeas = mSystematic + obj.Bias + n;

        end

        function obj = resetBias(obj)

            if isempty(obj.Bias)
                return;
            end

            obj.Bias = zeros(size(obj.Bias));

        end

    end

end
