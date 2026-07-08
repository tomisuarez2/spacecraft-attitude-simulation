classdef (Abstract) VectorSensor < Sensor
    %VECTORSENSOR Abstract class for spacecraft reference vector sensor simulation.
    %   
    %   This class defines the properties and methods that a spacecraft
    %   reference vector sensor should have. 
    %
    %   This type of sensors include:
    %       - magnetometers
    %       - suntrackers
    %       - startrackers
    %       - Earth horizon sensors
    %
    %   This class models sensors that observe known inertial reference 
    %   vectors by expressing them in the sensor frame and applying 
    %   deterministic and stochastic measurement errors.
    %   
    %   The measured vector is normalized as unit vector if desired.
    %
    %       vSMeas <- Unit Norm Vector(Optional) 
    %              <- Measurement Model 
    %              <- DCM_SB*DCM_BN*referenceVector_N
    %
    %   Properties
    %   ----------
    %   DCM_SB                 Direction Cosine Matrix (DCM) transforming vectors from frame
    %                          B to frame S [3x3].
    %   NormalizedOutput       Boolean indicating whether the output vector is normalized. 
    %
    %   Author: Tomás M. Suárez
    %   Date: 2026-07-05

    properties (SetAccess = private, GetAccess = public)
        DCM_SB
    end

    % Sensor configuration
    properties (SetAccess = private, GetAccess = public)   
        NormalizedOutput
    end
    
    methods (Access = public)
        function obj = VectorSensor(name, ...
                                    unit, ...
                                    samplePeriod, ...
                                    measurementModel, ...
                                    DCM_SB, ...
                                    normalizedOutput)

            arguments
                name                  (1,1) string
                unit                  (1,1) string
                samplePeriod          (1,1) double {mustBeNonnegative}
                measurementModel      (1,1) MeasurementModel
                DCM_SB                (3,3) double {mustBeDCM} = eye(3)
                normalizedOutput      (1,1) logical = true;
            end
            
            obj@Sensor(name, unit, samplePeriod, measurementModel);

            obj.DCM_SB                  = DCM_SB;
            obj.NormalizedOutput        = normalizedOutput;
        end      
       
    end
end

