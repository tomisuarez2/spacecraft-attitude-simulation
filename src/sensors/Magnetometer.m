classdef Magnetometer < VectorSensor
    %MAGNETOMETER Spacecraft magnetometer sensor model.
    %
    %   This class implements a three-axis magnetometer sensor based on the
    %   VectorSensor abstract class.
    %
    %   The magnetometer measures the geomagnetic field vector expressed in
    %   the sensor frame by transforming a known magnetic field reference
    %   vector from the inertial frame and applying the configured
    %   measurement model.
    %
    %       MagneticField_S <- Unit Norm Vector(Optional)
    %                       <- Measurement Model
    %                       <- DCM_SB*DCM_BN*MagneticField_N
    %
    %   The inertial magnetic field vector is assumed to be provided by the
    %   simulation environment (constant or time-varying depending on the
    %   selected environment model).
    %
    %   Author: Tomás M. Suárez
    %   Date: 2026-07-05

    methods (Access = public)

        function obj = Magnetometer(samplePeriod, ...
                                    measurementModel, ...
                                    DCM_SB, ...
                                    normalizedOutput)

            arguments
                samplePeriod      (1,1) double {mustBeNonnegative}
                measurementModel  (1,1) MeasurementModel
                DCM_SB            (3,3) double {mustBeDCM} = eye(3)
                normalizedOutput  (1,1) logical = true
            end

            obj@VectorSensor( ...
                "Magnetometer", ...
                "[T]", ...
                samplePeriod, ...
                measurementModel, ...
                DCM_SB, ...
                normalizedOutput);

        end
    end

    methods (Access = protected)
        function MagneticField_S = idealMeasurement(obj, state, environment)
            %IDEALMEASUREMENT Compute ideal magnetometer measurement.
            %
            %   Computes the ideal measurement of a magnetic field vector expressed in the
            %   inertial reference frame N. The measurement is obtained by transforming
            %   the vector from the inertial frame N to the spacecraft body-fixed frame
            %   B, and then from the body-fixed frame B to the sensor frame S.
            %
            %       MagneticField_S = DCM_SB*DCM_BN*MagneticField_N
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
            %   environment.MagneticField_N         Earth's magnetic field vector expressed 
            %                                       in the inertial reference frame N [3x1] [T].
            %
            %   Outputs
            %   -------
            %   MagneticField_S                     True magnetic field vector
            %                                       expressed in frame S [3x1].

            arguments
                obj
                state       SpacecraftState
                environment Environment
            end
            
            MagneticField_S = obj.DCM_SB * state.DCM_BN * environment.MagneticField_N;

            if obj.NormalizedOutput
                MagneticField_S = MagneticField_S/norm(MagneticField_S);
            end

        end

    end

end