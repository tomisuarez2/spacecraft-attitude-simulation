function [v, f] = createCubeWithPanels(s)
%CREATECUBEWITHPANELS Creates a cube with panels for rigid body representation.
%
%   Generates vertices and faces for a cube with panels mesh representation in 3D plots.
%   Creates a cube and adds two extended solar panels on ±Y sides.
%    
%   Inputs
%   ------
%   s Scale (half-size) of the cube of the cube [1x1]
%
%   Outputs
%   -------
%   v Vertices of the cube mesh
%   f Faces of the cube mesh
%
    arguments
        s (1,1) double {mustBeFinite} 
    end

    % Cube
    v_cube = s * [-1 -1 -1; 1 -1 -1; 1 1 -1; -1 1 -1;
                  -1 -1  1; 1 -1  1; 1 1  1; -1 1  1];
              
    f_cube = [1 2 3 4; 5 6 7 8; 1 2 6 5;
              2 3 7 6; 3 4 8 7; 4 1 5 8];

    % Extended panels
    panel_length = 5 * s;                 
    panel_offset = 1.5 * s;    

    % -Y Panel
    v_left = [
              s,-panel_offset , 0;
              s,-panel_offset - panel_length/2, 0;
             -s,-panel_offset - panel_length/2, 0;
             -s,-panel_offset , 0;
    ];

    % +Y Panel
    v_right = v_left;
    v_right(:,2) = -v_right(:,2); % reflejado en eje Y

    % Vertices concatenation
    v = [v_cube; v_left; v_right];

    % Faces
    f_left = 8 + [1 2 3 4];
    f_right = 8 + 4 + [1 2 3 4];

    f = [f_cube; f_left; f_right];
end
