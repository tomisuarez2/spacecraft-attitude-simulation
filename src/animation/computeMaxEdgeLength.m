function maxEdgeLength = computeMaxEdgeLength(vertices, faces)
    % Inicializar lista de aristas únicas
    edgeSet = [];

    % Iterar por cada cara (triángulo o polígono)
    for i = 1:size(faces, 1)
        face = faces(i, :);
        face = face(~isnan(face));  % Por si hay NaNs en caras no triangulares

        % Agregar cada arista (vértice a vértice) del polígono
        for j = 1:length(face)
            v1 = face(j);
            v2 = face(mod(j, length(face)) + 1);
            edge = sort([v1, v2]);  % Ordenar para evitar duplicados tipo [3 5] y [5 3]
            edgeSet = [edgeSet; edge];
        end
    end

    % Eliminar aristas duplicadas
    edgeSet = unique(edgeSet, 'rows');

    % Calcular longitudes
    diffs = vertices(edgeSet(:,1), :) - vertices(edgeSet(:,2), :);
    lengths = sqrt(sum(diffs.^2, 2));

    % Obtener máximo
    maxEdgeLength = max(lengths);
end
