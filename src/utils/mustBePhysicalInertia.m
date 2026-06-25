function mustBePhysicalInertia(I)
%MUSTBEPHYSICALINERTIA Condition chek for principal axis intertia matrix
%
%   Inputs
%   ------
%   I Proposed inertia matrix [3x3] [kg m^2]
%
%   Examples
%   --------
%   mustBePhysicalInertia([1 0 0;0 1 0;0 0 1]);
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-25

    arguments
        I (3,3) double
    end

    if ~isdiag(I)
        error("Inertia matrix must be diagonal.");
    end

    J = diag(I);

    if any(J <= 0)
        error("Principal moments of inertia must be positive.");
    end

    if J(1)+J(2) < J(3) || ...
       J(1)+J(3) < J(2) || ...
       J(2)+J(3) < J(1)

        error("Principal moments of inertia violate the triangle inequalities.");
    end

end

