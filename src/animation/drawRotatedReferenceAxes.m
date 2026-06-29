function [xArrow, yArrow, zArrow, xText, yText, zText] = drawRotatedReferenceAxes(R, scale, color, letter)
%DRAWROTATEDREFERENCEAXES Draws body axes in inertial frame
%   R      - DCM (columns are body axes)
%   scale  - arrow length scaling factor
%   color  - color of the reference frame unit vector axes
%   letter - letter of the reference frame unit vector axes

    xVec = R(:,1) * scale;
    yVec = R(:,2) * scale;
    zVec = R(:,3) * scale;

    [xArrow, xText] = drawArrow(xVec,scale, color, strcat(letter,'_1'));
    [yArrow, yText] = drawArrow(yVec,scale, color, strcat(letter,'_2'));
    [zArrow, zText] = drawArrow(zVec,scale, color, strcat(letter,'_3'));

end