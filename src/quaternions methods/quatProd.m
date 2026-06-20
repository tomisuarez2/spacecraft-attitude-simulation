function quatFinal = quatProd(quat1, quat2)
%QUATPROD Computes the quaternion product.
%
%   Computes the quaternion product between quat1 and quat2 (quat1 x quat2).
%   Scalar first convention is assumed (q0 q1 q2 q3).
%   
%   Inputs
%   ------
%   quat1     Quaternion representation, scalar first convention [1x4]
%   quat2     Quaternion representation, scalar first convention [1x4]
%
%   Outputs
%   -------
%   quatFinal Quaternion representation, scalar first convention [1x4]
%
%   Examples
%   --------
%   quatFinal = quatProd([1 0 0 0],[0 1 0 0]);
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
        quat1 (1,4) double
        quat2 (1,4) double
    end

    quatFinal = (quatGMatrix(quat1)*quat2')';

end