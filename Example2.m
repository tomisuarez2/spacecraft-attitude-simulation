%% EXAMPLE_2
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
w0 = [0.2 0.4 -0.2]'; % Body frame angular velocity
y0 = [s0; w0];

% Parameters
I = diag([0.3 0.2 0.1]);

dynamics = @(t,y) [computeMRPKinematics(y(1:3),y(4:6)); computeEulerEquations(I,y(4:6),[0 0 0]')]; % Torque free dynamics

[tOut, yOut] = rkf45Integrator(dynamics, [0 100], y0, @(state) [switchMRP(state(1:3)); state(4:6)]);

% Visualization
subplot(2,1,1)
plot(tOut, yOut(1:3,:))
ylabel("MRP [-]")
subplot(2,1,2)
plot(tOut, yOut(4:6,:))
ylabel("Ang. Velocity [rad/s]")
xlabel("Time [s]")
sgtitle("State evolution over time")

%%
rmpath(p)