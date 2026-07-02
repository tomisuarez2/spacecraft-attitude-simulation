function animateAttitudeHistory(vertices, faces, timeVector, stateHistory, desiredStateHistory, animationFileName, framesPerSecond)
%ANIMATEATTITUDEHISTORY Generate an animation of spacecraft attitude history.
% 
%   Generates an MPEG-4 animation showing the time evolution of a rigid
%   body's attitude and angular velocity. The animation includes:
%
%       • A 3-D visualization of the body orientation.
%       • Time histories of the Modified Rodrigues Parameters (MRPs).
%       • Time histories of the body angular velocity components.
%
%   If VERTICES and FACES are empty, only the body-fixed reference frame is
%   animated. Otherwise, the supplied triangular mesh is rotated according
%   to the attitude history.
%
%   The attitude history must be represented using Modified Rodrigues
%   Parameters (MRPs).
%
%   Inputs
%   ------
%   vertices               Vertex coordinates of the body mesh [M×3]. May be empty.
%   faces                  Triangular face connectivity matrix [K×3]. May be empty.
%   timeVector             Simulation time vector [1×N] [s].
%   stateHistory           State history matrix [6×N]. May be empty.
%                           stateHistory(1:3,:)  Modified Rodrigues Parameters (MRPs)
%                           stateHistory(4:6,:)  Body angular velocity, B frame components [3x1] [rad/s]
%   desiredStateHistory    Desired state history matrix [6×N]. May be empty.
%                           desiredStateHistory(1:3,:)  Desired Modified Rodrigues Parameters (MRPs)
%                           desiredStateHistory(4:6,:)  Desired Body angular velocity, R frame components [3x1] [rad/s]
%   animationFileName      Output video file name (without extension).
%   framesPerSecond        Output video frame rate [fps].
%
%   Author: Tomás M. Suárez
%   Date: 2026-06-26

    arguments
        vertices               (:,3) double {mustBeReal}
        faces                  (:,:) {mustBeInteger,mustBePositive}
        timeVector             (1,:) double {mustBeReal}
        stateHistory           (6,:) double {mustBeReal}
        desiredStateHistory    (6,:) double {mustBeReal}
        animationFileName      (1,1) string
        framesPerSecond        (1,1) double {mustBeReal,mustBeFinite,mustBePositive} = 10;
    end
    
    assert(numel(timeVector) >= 2, 'At least two samples are required.');
    assert(all(diff(timeVector) > 0), 'timeVector must be strictly increasing.');
    assert(numel(timeVector) == size(stateHistory,2), ...
    'timeVector and stateHistory must contain the same number of samples.');
    
    reference = ~isempty(desiredStateHistory);
    if ~reference
        conditionA = size(stateHistory,1) == size(desiredStateHistory,1);
        conditionB = size(stateHistory,2) == size(desiredStateHistory,2);
        assert(conditionA && conditionB, 'stateHistory and desiredStateHistory array must be equal size.')
    end
    
    model3D = ~isempty(vertices) && ~isempty(faces);     
    if model3D
        assert(max(faces,[],"all") <= size(vertices,1), ...
        'Face indices exceed the number of vertices.');
        maxL = computeMaxEdgeLength(vertices, faces);
    else
        maxL = 1;
    end

    N    = length(timeVector);

    if reference
        dOrientation = desiredStateHistory(1:3,:);
        dWs          = desiredStateHistory(4:6,:);
    end

    orientation = stateHistory(1:3,:);
    ws          = stateHistory(4:6,:);

    figure3D = figure('Visible','off','Position',[100 100 1280 720]);
    
    subplot(2,4,[1 2 5 6]);
    axis equal;
    grid on;
    view([1 1 1]);
    xlim([-1 1]*1.75*maxL); ylim([-1 1]*1.75*maxL); zlim([-1 1]*1.75*maxL); 
    hold on;
    tittle3D = title(sprintf('Attitude History Animation\n t = %.2f s', timeVector(1)));
    
    % Draw reference frame
    drawArrow([1,0,0], 2*maxL, 'k', 'n_1');
    drawArrow([0,1,0], 2*maxL, 'k', 'n_2');
    drawArrow([0,0,1], 2*maxL, 'k', 'n_3');
    
    % Initialize patch and body axes
    NB = mrpToDCM(orientation(:,1));
    [bX, bY, bZ, iTxt, jTxt, kTxt] = drawRotatedReferenceAxes(NB, 2*maxL, 'b', 'b');
    if model3D
        satellitePatch = patch('Faces', faces, 'Vertices', (NB * vertices')', 'FaceColor', [0.8 0.8 1], 'FaceAlpha', 0.5, 'EdgeColor', 'k');
    end

     % Set plots
    colors = lines(3);

    % MRPs
    subplot(2,4,[3 4]); 
    hold on; 
    title('Modified Rodrigues Parameters');
    xlim([0 timeVector(end)])
    ylim(max(abs([orientation dOrientation]),[],'all')*[-1 1])
    for i=1:3
        o(i) = animatedline('Color', colors(i,:));
    end
    if reference
        for i=1:3
            do(i) = animatedline('Color', colors(i,:), 'LineStyle', '--');
        end
        legend('\sigma_1','\sigma_2','\sigma_3','\sigma_{r1}','\sigma_{r2}','\sigma_{r3}');
    else
        legend('\sigma_1','\sigma_2','\sigma_3');  
    end

    % Angular velocity
    subplot(2,4,[7 8]);
    hold on; 
    title('Angular Velocity [rad/s]');
    xlim([0 timeVector(end)])
    ylim(max(abs([ws dWs]),[],'all')*[-1 1])
    for i = 1:3
        w(i) = animatedline('Color', colors(i,:));
    end
    if reference
        for i = 1:3
            dw(i) = animatedline('Color', colors(i,:), 'LineStyle', '--');
        end
        legend('\omega_1','\omega_2','\omega_3','\omega_{r1}','\omega_{r2}','\omega_{r3}');        
    else
        legend('\omega_1','\omega_2','\omega_3');
    end
            
    % Animation File
    video = VideoWriter(strcat(animationFileName,'.mp4'), 'MPEG-4');
    video.FrameRate = framesPerSecond;
    open(video);        

    % Animation loop
    for k = 2:N
        % Update 3D plot
        BN = mrpToDCM(-orientation(:,k));
        updateReferenceAxes(bX, bY, bZ, iTxt, jTxt, kTxt, BN, 2*maxL);
        tittle3D.String = sprintf('Attitude History Animation\n t = %.2f s', timeVector(k));
        if model3D
            updatePatch(satellitePatch, BN, vertices);
        end
        % Update 2D plots
        for i = 1:3
            addpoints(o(i), timeVector(k), orientation(i,k));
            addpoints(w(i), timeVector(k), ws(i,k));
        end
        if reference
            for i = 1:3
                addpoints(do(i), timeVector(k), dOrientation(i,k));
                addpoints(dw(i), timeVector(k), dWs(i,k));
            end
        end
        drawnow nocallbacks;

        % Video write
        frame = getframe(figure3D);
        writeVideo(video, frame);
    end

    % Close video
    close(video);        
      
end

