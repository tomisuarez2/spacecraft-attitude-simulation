function hat_DCM_BN = TRIAD(bodyVectors, inertialVectors)
%TRIAD Attitude determination using the TRIAD algorithm.
%
%   Computes the spacecraft attitude Direction Cosine Matrix (DCM) from
%   two independent vector observations expressed in both the body and
%   inertial reference frames.
%
%   The TRIAD algorithm constructs two orthonormal bases from the vector
%   observations and determines the rotation matrix relating both frames.
%
%   Implements method given in section (3.10.2) of [1].
%
%
%   Inputs
%   ------
%   bodyVectors       Matrix containing two independent vector
%                     observations expressed in the body reference
%                         frame [3x2].
%
%   inertialVectors   Matrix containing the corresponding
%                     reference vectors expressed in the inertial
%                     reference frame [3x2].
%
%   Outputs
%   -------
%   hat_DCM_BN        Direction Cosine Matrix (DCM) representing the
%                     estimated orientation of the body frame with respect to the
%                     inertial frame [3x3].
%
%   Notes
%   -----
%       - Input vectors do not need to be normalized.
%       - The vector pairs must not be parallel (or nearly parallel).
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       4th Edition, AIAA, 2018.
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-08

    arguments
        bodyVectors     (3,2) double {mustBeFinite}
        inertialVectors (3,2) double {mustBeFinite}
    end

    tolerance = 1e-8;

    % Normalize input vectors

    bodyVectorsNorm = vecnorm(bodyVectors);
    if all(bodyVectorsNorm > tolerance)
        bodyVectors = bodyVectors ./ bodyVectorsNorm;
    else
        error('TRIAD:BodyVectorsNull', 'Body-frame vectors must not be null or nearly null.');
    end

    inertialVectorsNorm = vecnorm(inertialVectors);
    if all(inertialVectorsNorm > tolerance)
        inertialVectors = inertialVectors ./ inertialVectorsNorm;
    else
        error('TRIAD:InertialVectorsNull', 'Inertial-frame vectors must not be null or nearly null.');
    end

    % Verify vector independence

    if norm(cross(bodyVectors(:,1), bodyVectors(:,2))) < tolerance
        error('TRIAD:BodyVectorsParallel', 'Body-frame vectors must not be parallel or nearly parallel.');
    end

    if norm(cross(inertialVectors(:,1), inertialVectors(:,2))) < tolerance
        error('TRIAD:InertialVectorsParallel', 'Inertial-frame vectors must not be parallel or nearly parallel.');
    end

    % Construct body-frame orthonormal triad
    
    bodyTriad1 = bodyVectors(:,1);
    
    bodyTriad2 = cross(bodyTriad1, bodyVectors(:,2));
    bodyTriad2 = bodyTriad2 / norm(bodyTriad2);
    
    bodyTriad3 = cross(bodyTriad1, bodyTriad2);

    % Construct inertial-frame orthonormal triad
    
    inertialTriad1 = inertialVectors(:,1);
    
    inertialTriad2 = cross(inertialTriad1, inertialVectors(:,2));
    inertialTriad2 = inertialTriad2 / norm(inertialTriad2);
    
    inertialTriad3 = cross(inertialTriad1, inertialTriad2);

    % Compute attitude DCM
    
    hat_DCM_BN = [bodyTriad1 bodyTriad2 bodyTriad3] * [inertialTriad1 inertialTriad2 inertialTriad3]';

end