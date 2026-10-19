%% EXAMPLE_5
%
%  Author: Tomás M. Suárez
%  Date: 2026-07-02
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.

% Linux OS
p = genpath("../src");
% Windows OS
%p = genpath("..\src");

addpath(p)

animation = true;

% Dynamics numerical integration with control for attitude tracking
% Example based on "Unconstrained Control Law" section (8.4.1) [1].

%% Reference attitude trajectory

t = sym('t', 'real');

% Desired MRPs as a function of time (maps vector from N to R)
sigmaRef = [0.1*sin(0.03*t);
            0.2*cos(0.03*t);
           -0.3*sin(2*0.03*t)];

reference.sigma = matlabFunction(sigmaRef, 'Vars', t);

% Desired angular velocity in R frame as a function of time, Eq. (3.158) [1].
sigmaRSq = sigmaRef'*sigmaRef;
B        = computeBMRPMatrix(sigmaRef);
wRef     = 4*B'*diff(sigmaRef, t)/(1+sigmaRSq)^2;  % [rad/s]
wRef     = simplify(wRef);

reference.w = matlabFunction(wRef, 'Vars', t);

% Desired angular acceleration in R frame as a function of time
dwRef = diff(wRef, t);
dwRef = simplify(dwRef); % [rad/s^2]

reference.dw = matlabFunction(dwRef,'Vars',t);

%% Spacecraft parameters

spacecraft.I = diag([100,75,80]); % [kg m^2]

%% Control law

% Controller gains
controller.K = 5;
controller.P = 10*eye(3);

attError = @(t, y) switchMRP(mrpComposition(y(1:3), -reference.sigma(t)));

controlAction = @(t, y) unconstrainedControl( ...
                       controller.K, ...
                       spacecraft.I, ...
                       controller.P, ...
                       attError(t, y), ... 
                       y(4:6), ... 
                       reference.w(t), ...
                       reference.dw(t), ...
                       [0 0 0]');

%% Dynamics definition

mrpRate = @(y) computeMRPKinematics(y(1:3),y(4:6));

angVelRate = @(t, y) computeEulerEquations(spacecraft.I, y(4:6), controlAction(t, y));

dynamics = @(t, y) [mrpRate(y); angVelRate(t, y)];

%% Initial conditions

s0 = [0.1 0.2 -0.1]'; % MRP
w0 = deg2rad([3 1 -2])'; % Body frame angular velocity
y0 = [s0; w0];

%% Numerical integration

stateNormalization = @(state) [switchMRP(state(1:3)); state(4:6)];

% Numerical Integration
[tOut, yOut] = rkf45Integrator(dynamics, [0 500], y0, stateNormalization);

%% Post-processing

desiredMRP = reference.sigma(tOut);
desiredWr  = reference.w(tOut);

N = size(tOut, 2);
controlTorque = zeros(3, N);
for i = 1:N
    controlTorque(:,i) = controlAction(tOut(1,i), yOut(:,i));
end

%% Plots

colors = lines(3);

% MRPs evolution
figure('Name','MRP');
hold on;
grid on;
colororder(colors(1:3,:));
plot(tOut, yOut(1:3,:))
colororder(colors(1:3,:));
plot(tOut, desiredMRP(1:3,:), 'LineStyle', '--')
title("MRPs evolution")
xlabel("Time [s]")
ylabel("MRPs [-]")
legend('\sigma_1','\sigma_2','\sigma_3','\sigma_{r1}','\sigma_{r2}','\sigma_{r3}');

% Angular velocity evolution
figure('Name','Ang. Vel.');
hold on;
grid on;
colororder(colors(1:3,:));
plot(tOut, yOut(4:6,:))
colororder(colors(1:3,:));
plot(tOut, desiredWr(1:3,:), 'LineStyle', '--')
title("Angular velocity evolution")
xlabel("Time [s]")
ylabel("Components [rad/s]")
legend('\omega_1','\omega_2','\omega_3','\omega_{r1}','\omega_{r2}','\omega_{r3}');

% Control action plot in B frame components
figure('Name', 'Control');
hold on;
grid on;
colororder(colors(1:3,:));
plot(tOut, controlTorque(1:3,:))
title("Control actions about body frames")
ylabel("Torque [Nm]")
xlabel("Time [s]")
legend('\tau_1','\tau_2','\tau_3');

%% Animation

if animation
    disp("Animation in progres...")
    [v,f] = createCubeWithPanels(1);
    animateAttitudeHistory(v, f, tOut, yOut, [desiredMRP; desiredWr] ,"..\img\animation_example5");
    disp("Animation saved.")
end