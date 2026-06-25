%% RKF45 Integrator Validation
clear
clc
close all

addpath("..\.")

%% Problem definition
f = @(t,y) -y;

tspan = [0 10];
y0 = 1;

%% Numerical integration
[tout,yout] = rkf45Integrator(f,tspan,y0);

%% Analytical solution
yExact = exp(-tout);

%% Error
error = yout - yExact;
maxError = max(abs(error));

fprintf('Maximum absolute error = %.3e\n',maxError);

%% Plots
figure

subplot(2,1,1)
plot(tout,yout,'LineWidth',1.5)
hold on
plot(tout,yExact,'--','LineWidth',1.5)
grid on
xlabel('Time [s]')
ylabel('y')
legend('RKF45','Exact')
title('Solution Comparison')

subplot(2,1,2)
semilogy(tout,abs(error),'LineWidth',1.5)
grid on
xlabel('Time [s]')
ylabel('|Error|')
title('Absolute Error')

rmpath("..\.")