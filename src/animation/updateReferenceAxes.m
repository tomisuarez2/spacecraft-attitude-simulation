function updateReferenceAxes(xArrow, yArrow, zArrow, xText, yText, zText, R, scale)
%UPDATEREFERNCEAXES Updates orientation and labels of reference axes
%   R     - DCM at current time
%   scale - scaling factor

    % Axes vectors
    xVec = R(:,1);
    yVec = R(:,2);
    zVec = R(:,3);

    % Update arrows
    updateArrow(xArrow, xText, xVec, scale);
    updateArrow(yArrow, yText, yVec, scale);
    updateArrow(zArrow, zText, zVec, scale);

end