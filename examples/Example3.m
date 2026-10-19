%% EXAMPLE_3
%
%  Author: Tomás M. Suárez
%  Date: 2026-06-26
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       2nd Edition, AIAA, 2009.

close all;
clear;
clc;

% Linux OS
p = genpath("../src");
% Windows OS
%p = genpath("..\src");

addpath(p)

%% Initial conditions

s0 = [0 0 0]'; % MRP
w0 = [0.2 -0.4 -0.2]'; % Body frame angular velocity [rad/S]
y0 = [s0; w0];

%% Spacecraft Parameters

I = diag([0.3 0.2 0.1]);

%% Dynamics definition

dynamics = @(t,y) [computeMRPKinematics(y(1:3),y(4:6)); 
                   computeEulerEquations(I,y(4:6),[0 0 0]')]; % Torque free dynamics

%% Numerical integration

[tOut, yOut] = rkf45Integrator(dynamics, [0 50], y0, @(state) [switchMRP(state(1:3)); state(4:6)]);

%% Animation

disp("Animation in progres...")
[v,f] = createCubeWithPanels(1);
animateAttitudeHistory(v,f,tOut,yOut,[],"..\img\animation_example3");
disp("Animation saved.")