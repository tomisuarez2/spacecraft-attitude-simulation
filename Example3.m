%% EXAMPLE_3
%
%  Author: Tomás M. Suárez
%  Date: 2026-06-26

close;
clear;
clc;

p = genpath("src");
addpath(p)

%% Dynamics numerical integration

% Initial conditions
s0 = [0 0 0]'; % MRP
w0 = [0.2 -0.4 -0.2]'; % Body frame angular velocity
y0 = [s0; w0];

% Parameters
I = diag([0.3 0.2 0.1]);

dynamics = @(t,y) [computeMRPKinematics(y(1:3),y(4:6)); computeEulerEquations(I,y(4:6),[0 0 0]')]; % Torque free dynamics

[tOut, yOut] = rkf45Integrator(dynamics, [0 50], y0, @(state) [switchMRP(state(1:3)); state(4:6)]);

% Animation
disp("Animation in progres...")
[v,f] = createCubeWithPanels(1);
animateAttitudeHistory(v,f,tOut,yOut,"img\animation_example3");
disp("Animation saved.")


%%
rmpath(p)