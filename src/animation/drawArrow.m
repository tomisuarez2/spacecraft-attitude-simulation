function [arrowHandle, textHandle] = drawArrow(vec, scale, color, label, linestyle)
%DRAWARROW Draws an arrow and label for a vector
%   vec       - [3x1] vector to plot
%   scale     - scalar for visualization scaling
%   color     - color of arrow
%   label     - string for label (e.g., 'w' or 'wr')
%   linestyle - optional, e.g., '--' for dashed line

    if nargin < 5, linestyle = '-'; end
    components = vec * scale;
    textPos = vec * scale * 1.05;

    arrowHandle = quiver3(0, 0, 0, ...
        components(1), components(2), components(3), ...
        'Color', color, 'LineWidth', 1.5, 'MaxHeadSize', 0.5, ...
        'LineStyle', linestyle);

    textHandle = text(textPos(1), textPos(2), textPos(3), label, 'Color', color);
    
end