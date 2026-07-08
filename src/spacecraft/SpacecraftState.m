classdef SpacecraftState
    %SPACECRAFTSTATE Spacecraft dynamic state container.
    %
    %   Stores the spacecraft state variables required by the simulation.
    %   This object is intended to be passed between simulation modules
    %   (e.g., dynamics, sensors, controllers and estimators) so that all
    %   components operate on a consistent representation of the spacecraft
    %   state.
    %
    %   Reference frames
    %   ----------------
    %       N : Inertial reference frame.
    %       B : Spacecraft body-fixed reference frame.
    %
    %   Properties
    %   ----------
    %   DCM_BN   Direction Cosine Matrix (DCM) transforming vectors from frame N to frame B [3x3].
    %   omega_B  Spacecraft angular velocity expressed in the body frame [3x1] [rad/s].

    properties(SetAccess = public, GetAccess = public)
        DCM_BN        double {mustBeDCM} = eye(3)
        omega_B (3,1) double {mustBeFinite} = zeros(3,1)
    end

end

