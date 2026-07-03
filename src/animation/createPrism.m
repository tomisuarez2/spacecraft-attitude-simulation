function [v, f] = createPrism(a,b,c)
%CREATEPRISM Creates a prism for rigid body representation allign with z axis.
%
%   Generates vertices and faces for a prism mesh representation in 3D plots.
%
%   Inputs
%   ------
%   a x longitud of the prism [1x1]
%   b y longitud of the prism [1x1]
%   c z longitud of the prism [1x1]
%
%   Outputs
%   -------
%   v Vertices of the prism mesh
%   f Faces of the prism mesh
%

    arguments
        a (1,1) double {mustBeFinite}
        b (1,1) double {mustBeFinite}
        z (1,1) double {mustBeFinite}
    end

    % Centered at origin
    x = [-a/2, a/2];
    y = [-b/2, b/2];
    z = [-c/2, c/2];
    
    [X, Y, Z] = ndgrid(x, y, z);
    v = [X(:), Y(:), Z(:)];
    
    % Define faces (standard cube connectivity)
    f = [1 3 4 2;   % bottom
         5 6 8 7;   % top
         1 2 6 5;   % front
         2 4 8 6;   % right
         4 3 7 8;   % back
         3 1 5 7];  % left

end
