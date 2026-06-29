function [v, f] = createCilinder(radius,height,n)
%CREATECILINDER Creates a cilinder for rigid body representation allign with z axis.
%
%   Generates vertices and faces for a cilinder mesh representation in 3D plots.
%    
%   Inputs
%   ------
%   radius Radius of the cilinder [1x1]
%   height Height of the cilinder [1x1]
%   n      Number of points around the circle [1x1]
%
%   Outputs
%   -------
%   v      Vertices of the cilinder mesh
%   f      Faces of the cube mesh
%

    arguments
        radius (1,1) double {mustBeFinite}
        height (1,1) double {mustBeFinite}
        n (1,1) double {mustBeFinite} = 30;
    end
    
    theta = linspace(0, 2*pi, n+1);
    theta(end) = [];  % remove duplicate
    
    x = radius * cos(theta);
    y = radius * sin(theta);
    z_top = height/2 * ones(1, n);
    z_bottom = -height/2 * ones(1, n);
    
    % Vertices: bottom ring, top ring, centers
    v = [x' y' z_bottom';     % 1 to n
         x' y' z_top';        % n+1 to 2n
         0   0   -height/2;   % 2n+1
         0   0    height/2];  % 2n+2
    
    % Indices
    bottom = 1:n;
    top = n+1:2*n;
    center_bot = 2*n+1;
    center_top = 2*n+2;
    
    f = [];
    
    % Side triangles
    for i = 1:n
        i2 = mod(i, n) + 1;
        % lower triangle
        f(end+1, :) = [bottom(i), bottom(i2), top(i)];
        % upper triangle
        f(end+1, :) = [top(i), bottom(i2), top(i2)];
    end
    
    % Bottom triangles
    for i = 1:n
        i2 = mod(i, n) + 1;
        f(end+1, :) = [bottom(i2), bottom(i), center_bot];
    end
    
    % Top triangles
    for i = 1:n
        i2 = mod(i, n) + 1;
        f(end+1, :) = [top(i), top(i2), center_top];
    end
    
end