function updateArrow(arrowHandle, textHandle, vec, scale)
%UPDATEARROW Updates arrow direction and visibility
%   arrowHandle - handle to existing quiver3 arrow
%   textHandle  - handle to existing text
%   vec         - new [3x1] vector direction
%   scale       - scaling factor

    components = vec * scale;
    textPos = vec * scale * 1.05;

    normVec = norm(vec);
    if normVec < 1e-3
        set(arrowHandle, 'Visible', 'off');
        set(textHandle, 'Visible', 'off');
    else
        set(arrowHandle, 'UData', components(1), ...
                         'VData', components(2), ...
                         'WData', components(3), ...
                         'Visible', 'on');
        set(textHandle, 'Position', textPos, ...
                        'Visible', 'on');
    end
end