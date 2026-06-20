function G = quatGMatrix(quat)
%QUATGMATRIX Computes the quaternion G matrix.
%
%   Computes the quaternion G matrix of the argument quaternion, where 
%   G'*quat' = [1 0 0 0]'.
%   Scalar first convention is assumed (q0 q1 q2 q3).
%   
%   Inputs
%   ------
%   quat Quaternion representation, scalar first convention [1x4]
%
%   Outputs
%   -------
%   G    Quaternion G matrix [4x4]
%
%   Examples
%   --------
%   G = quatGMatrix([1 0 0 0]);
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

    G = [quat(1) -quat(2) -quat(3) -quat(4);
         quat(2)  quat(1) -quat(4)  quat(3);
         quat(3)  quat(4)  quat(1) -quat(2);
         quat(4) -quat(3)  quat(2)  quat(1)];

end