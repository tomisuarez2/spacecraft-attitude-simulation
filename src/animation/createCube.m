function [v, f] = createCube(s)
%CREATECUBE Creates a cube for rigid body representation.
%
%   Generates vertices and faces for a cube mesh representation in 3D plots.
%    
%   Inputs
%   ------
%   s Scale (half-size) of the cube [1x1]
%
%   Outputs
%   -------
%   v Vertices of the cube mesh
%   f Faces of the cube mesh
%

    arguments
        s (1,1) double {mustBeFinite} 
    end

    v = s * [-1 -1 -1; 1 -1 -1; 1 1 -1; -1 1 -1;
             -1 -1  1; 1 -1  1; 1 1  1; -1 1  1];
    f = [1 2 3 4; 5 6 7 8; 1 2 6 5;
         2 3 7 6; 3 4 8 7; 4 1 5 8];
    
end
