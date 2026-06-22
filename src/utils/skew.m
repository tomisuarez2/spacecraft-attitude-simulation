function S = skew(v)
%SKEW Computes skew-symmetric matrix from three element vector.
%
%   Computes skew-symmetric matrix from a thre element vector v,
%   that allow us to compute:
%   
%   vF = cross(v,v2)
%   vF = -skew(v)*v2;
% 
%   Inputs
%   ------
%   v Three element vector
%
%   Outputs
%   -------
%   S Skew-symmetric matrix from vector v
%
%   Examples
%   --------
%   S = skew([1 0 0]);
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-22

    S = [  0  -v(3) v(2);
          v(3)  0  -v(1);
         -v(2) v(1)  0];

end
