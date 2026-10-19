%% EXAMPLE_6
%
% Demonstrates the use of sensor models to simulate
% magnetometer and sun sensor measurements from a prescribed
% spacecraft attitude trajectory.
%
% Author: Tomás M. Suárez
% Date: 2026-07-08

% Linux OS
p = genpath("../src");
% Windows OS
%p = genpath("..\src");

addpath(p)

%% Initialization 

samplePeriod = 0.2; % [s]
simulationTime = 10; % [s]

time = 0:samplePeriod:simulationTime; % [s]

N = numel(time);

%% Inertial reference enviroment

environment = Environment([2 3 4]', [1 0 0]'); % Magnetic field and Sun orientation vector

%% Sensors

noiseCovariance = 1e-3*eye(3);

magMeasModel = MeasurementModel(noiseCovariance, [], [], []);
sunMeasModel = MeasurementModel(noiseCovariance, [], [], []);

magnetometer = Magnetometer(samplePeriod, magMeasModel, eye(3), true);
sunSensor    = SunSensor(samplePeriod, sunMeasModel, [1 0 0; 0 0 -1; 0 1 0]);

%% Spacecraft State

state = SpacecraftState();

%% Attitude trajectory

% MRPs as a function of time (maps vector from N to B)
sigma_B = @(t)[0.1*sin(0.03*t);
               0.2*cos(0.03*t);
              -0.3*sin(0.06*t)];

%% Ground truth attitude

sigmaHistory = sigma_B(time);

%% Sensor measurements

magMeasurements = zeros(3,N);
sunMeasurements = zeros(3,N);

for idx = 1:N
    state.DCM_BN = mrpToDCM(sigmaHistory(:,idx));
    [magnetometer, magMeasurements(:,idx)] = magnetometer.measure(state, environment);
    [sunSensor, sunMeasurements(:,idx)]    = sunSensor.measure(state, environment);
end

%% Plots

colors = lines();

figure('Name','Sensor Measurements');

% Magnetometer measurements

subplot(3,1,1)
hold on;
grid on;
colororder(colors(1:3,:));
plot(time, magMeasurements(1:3,:), 'Marker','o')
title("Magnetometer measurements over time")
ylabel("Components [-]")
legend('$^S \hat{m}_1$','$^S \hat{m}_2$','$^S \hat{m}_3$', 'Interpreter', 'latex', 'Location','best');

% Sun sensor measurements

subplot(3,1,2)
hold on;
grid on;
colororder(colors(1:3,:));
plot(time, sunMeasurements(1:3,:), 'Marker','o')
title("Sun Sensor measurements over time")
ylabel("Components [-]")
legend('$^S \hat{s}_1$','$^S \hat{s}_2$','$^S \hat{s}_3$', 'Interpreter', 'latex', 'Location','best');

subplot(3,1,3)
hold on;
grid on;
colororder(colors(1:3,:));
plot(time, sigmaHistory(1:3,:))
title("MRPs over time")
ylabel("Components [-]")
xlabel("Time [s]")
legend('$\sigma_1$','$\sigma_2$','$\sigma_3$', 'Interpreter', 'latex');


