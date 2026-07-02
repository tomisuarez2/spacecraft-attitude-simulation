%% EXAMPLE_4
%
%  Author: Tomás M. Suárez
%  Date: 2026-06-29
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.

close;
clear;
clc;

p = genpath("..\src");
addpath(p)

% Dynamics numerical integration with control law trying to arrest rotational motion

% Example based on "Elemental Velocity-Based Lyapunov Functions" section (8.3.1) [1].

% Control law used
% ----------------
% Q = -[P]*w
%   -> [P] is a symmetric, positive-definite feedback gain matrix
%   ->  w  is the measured/estimated spacecraft angular velocity
%
% Control law guarantees globally, assimptotically stabilizing control.
% Final orientation is not a concern.

%%  Initial conditions

s0 = [0 0 0]'; % MRP
w0 = [-0.4 0.6 0.4]'; % Body frame angular velocity [rad/s]
y0 = [s0; w0];

%% Spacecraft parameters

I = diag([0.3 0.2 0.1]);

%% Control law

% Controller parameters
P = diag([0.05 0.05 0.05]);

control = @(w) -P*w;

%% Dynamics definition

dynamics = @(t,y) [computeMRPKinematics(y(1:3),y(4:6)); computeEulerEquations(I,y(4:6), control(y(4:6)))];

%% Numerical integration

[tOut, yOut] = rkf45Integrator(dynamics, [0 50], y0, @(state) [switchMRP(state(1:3)); state(4:6)]);

%% Plots

figure('Name','Control actions');
plot(tOut, control(yOut(4:6,:)))
title("Control actions about body frames")
ylabel(" Torque [Nm]")
xlabel("Time [s]")
legend('\tau_1','\tau_2','\tau_3');

%% Animation

disp("Animation in progres...")
[v,f] = createCubeWithPanels(1);
animateAttitudeHistory(v,f,tOut,yOut,[],"..\img\animation_example4");
disp("Animation saved.")
