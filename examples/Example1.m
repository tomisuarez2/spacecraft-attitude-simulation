%% EXAMPLE_1
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

%% Angular velocity evolution

% [rad/s]
w = @(t) [0.1*sin(0.1*t);
          0.2*sin(0.3*t);
          0.1*cos(0.1*t)];

%% Initial conditions

y0 = [0 0 0]'; % MRP

%% Kinematics definition

kinematics = @(t,y) [computeMRPKinematics(y(1:3),w(t))];

%% Numerical integration

[tOut, yOut] = rkf45Integrator(kinematics, [0 100], y0, @switchMRP);

%% Plots

subplot(2,1,1)
plot(tOut, yOut)
ylabel("MRP [-]")
subplot(2,1,2)
plot(tOut, w(tOut))
ylabel("Ang. Velocity [rad/s]")
xlabel("Time [s]")
sgtitle("State evolution over time")
