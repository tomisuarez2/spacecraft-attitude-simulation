%% EXAMPLE_4
%
%  Author: Tomás M. Suárez
%  Date: 2026-06-29

close;
clear;
clc;

p = genpath("..\src");
addpath(p)

%% Dynamics numerical integration with control law trying to arrest rotational motion

% Example based on "Elemental Velocity-Based Lyapunov Functions" section
% (8.3.1).

% Control law used
% ----------------
% Q = -[P]*w
%   -> [P] is a symmetric, positive-definite feedback gain matrix
%   ->  w  is the measured/estimated spacecraft angular velocity
%
% Control law guarantees globally, assimptotically stabilizing control.
% Final orientation is not a concern.

% Initial conditions
s0 = [0 0 0]'; % MRP
w0 = [-0.4 0.6 0.4]'; % Body frame angular velocity
y0 = [s0; w0];

% Dynamic parameters
I = diag([0.3 0.2 0.1]);

% Control law parameters
P = diag([0.05 0.05 0.05]);

control = @(w) -P*w;

dynamics = @(t,y) [computeMRPKinematics(y(1:3),y(4:6)); computeEulerEquations(I,y(4:6), control(y(4:6)))]; 

[tOut, yOut] = rkf45Integrator(dynamics, [0 50], y0, @(state) [switchMRP(state(1:3)); state(4:6)]);

% Animation
disp("Animation in progres...")
[v,f] = createCubeWithPanels(1);
animateAttitudeHistory(v,f,tOut,yOut,"..\img\animation_example4");
disp("Animation saved.")

% Control action plot
figure;
plot(tOut, control(yOut(4:6,:)))
title("Body frame control actions")
ylabel(" Torque [Nm]")
xlabel("Time [s]")


%%
rmpath(p)