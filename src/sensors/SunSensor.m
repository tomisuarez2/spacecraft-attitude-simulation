classdef SunSensor < VectorSensor
    %SUNSENSOR Spacecraft sun sensor model.
    %
    %   This class implements a sun sensor based on the
    %   VectorSensor abstract class.
    %
    %   The sun sensor measures the sun orientation vector expressed in
    %   the sensor frame by transforming a known sun orientation reference
    %   vector from the inertial frame and applying the configured
    %   measurement model.
    %
    %       SunOrientation_S <- Unit Norm Vector
    %                        <- Measurement Model
    %                        <- DCM_SB*DCM_BN*SunOrientation_N
    %
    %   The inertial sun orientation vector is assumed to be provided by the
    %   simulation environment (constant or time-varying depending on the
    %   selected environment model).
    %
    %   Author: Tomás M. Suárez
    %   Date: 2026-07-08

    methods (Access = public)

        function obj = SunSensor(samplePeriod, ...
                                 measurementModel, ...
                                 DCM_SB)

            arguments
                samplePeriod      (1,1) double {mustBeNonnegative}
                measurementModel  (1,1) MeasurementModel
                DCM_SB            (3,3) double {mustBeDCM} = eye(3)
            end

            obj@VectorSensor( ...
                "Sun Sensor", ...
                "[-]", ...
                samplePeriod, ...
                measurementModel, ...
                DCM_SB, ...
                true);

        end
    end

    methods (Access = protected)
        function SunOrientation_S = idealMeasurement(obj, state, environment)
            %IDEALMEASUREMENT Compute ideal sun sensor measurement.
            %
            %   Computes the ideal measurement of a sun orientation vector expressed in the
            %   inertial reference frame N. The measurement is obtained by transforming
            %   the vector from the inertial frame N to the spacecraft body-fixed frame
            %   B, and then from the body-fixed frame B to the sensor frame S.
            %
            %       SunOrientation_S = DCM_SB*DCM_BN*SunOrientation_N
            %
            %   where
            %
            %       DCM_BN transforms vectors from frame N to frame B.
            %
            %       DCM_SB transforms vectors from frame B to frame S.
            %
            %   Inputs
            %   ------
            %   obj                                 Sensor object.
            %   state                               Object containing the spacecraft state. 
            %                                       Typical fields may include:
            %                                           - Attitude
            %                                           - Angular velocity
            %                                           - Position
            %                                           - Velocity
            %
            %   environment                         Object containing the external environment. 
            %                                       Typical fields may include:
            %                                           - Magnetic field
            %                                           - Sun vector
            %                                           - Atmospheric properties
            %                                           - Gravity model
            %
            %   Variables
            %   ---------
            %   state.DCM_BN                        Direction Cosine Matrix (DCM)
            %                                       transforming vectors from frame N
            %                                       to frame B [3x3].
            %   environment.SunOrientation_N        Unit vector pointing from the spacecraft toward the Sun, 
            %                                       expressed in the inertial reference frame N [3x1].
            %
            %   Outputs
            %   -------
            %   SunOrientation_S                    Unit vector pointing from the spacecraft toward the Sun, 
            %                                       expressed in the sensor reference frame S [3x1].

            arguments
                obj
                state       SpacecraftState
                environment Environment
            end
            
            SunOrientation_S = obj.DCM_SB * state.DCM_BN * environment.SunOrientation_N;

            SunOrientation_S = SunOrientation_S / norm(SunOrientation_S);
 
        end

    end

end