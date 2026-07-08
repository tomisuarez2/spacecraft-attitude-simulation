classdef Environment
    %ENVIRONMENT Environmental state for spacecraft simulations.
    %
    %   This class stores the environmental quantities required by the
    %   spacecraft simulation. All vectors are expressed in the inertial
    %   reference frame (N) unless otherwise stated.
    %
    %   Properties
    %   ----------
    %   MagneticField_N Earth's magnetic field vector expressed in the inertial reference frame N [3x1] [T].
    %   SunVector_N     Unit vector pointing from the spacecraft toward the Sun, 
    %                   expressed in the inertial reference frame N [3x1].

    properties (SetAccess = public, GetAccess = public)
        MagneticField_N (3,1) double {mustBeFinite} = zeros(3,1)
        SunVector_N     (3,1) double {mustBeFinite} = [1;0;0]
    end

end