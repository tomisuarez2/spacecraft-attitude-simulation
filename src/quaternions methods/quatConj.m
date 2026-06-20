function quatStar = quatConj(quat)
%QUATCONJ Computes the quaternion conjugate.
%
%   Computes the quaternion conjugate of the argument (quat*).
%   Scalar first convention is assumed (q0 q1 q2 q3).
%   
%   Inputs
%   ------
%   quat     Quaternion representation, scalar first convention [1x4]
%
%   Outputs
%   -------
%   quatStar Quaternion representation, scalar first convention [1x4]
%
%   Examples
%   --------
%   quatStar = quatConj([1 -1 -1 -1]);
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-20

    arguments
        quat (1,4) double
    end

    quatStar = [quat(1) -quat(1,2:4)];

end