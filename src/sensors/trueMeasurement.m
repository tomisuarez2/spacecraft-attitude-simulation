function vS = trueMeasurement(vN, BN, SB)
%TRUEMEASUREMENT Compute the true sensor measurement.
%
%   Computes the true measurement of a physical vector expressed in the
%   inertial reference frame N. The measurement is obtained by transforming
%   the vector from the inertial frame N to the spacecraft body-fixed frame
%   B, and then from the body-fixed frame B to the sensor frame S.
%
%       vS = SB*BN*vN
%
%   where
%
%       BN transforms vectors from frame N to frame B.
%
%       SB transforms vectors from frame B to frame S.
%
%   Inputs
%   ------
%   vN   Physical vector expressed in frame N [3x1].
%   BN   Direction Cosine Matrix (DCM) transforming vectors from frame
%        N to frame B [3x3].
%   SB   Direction Cosine Matrix (DCM) transforming vectors from frame
%        B to frame S [3x3].
%
%   Outputs
%   -------
%   vS   Ideal sensor measurement expressed in frame S [3x1].
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-03

    arguments
        vN double {mustBeFinite}
        BN double {mustBeDCM}
        SB double {mustBeDCM}
    end

    assert(isequal(size(vN), [3 1]), ...
        "Physical vector vN must be a 3x1 column vector.")

    vS = SB*BN*vN;

end