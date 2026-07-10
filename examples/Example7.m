%% EXAMPLE_7
%
%   Demonstrates the use of deterministic attitude estimation methods to compute
%   the estimate attitude of a spacecraft based on sensor measurements.
%
%   Implements method given in section (3.10) of [1].
%
%   Implemented methods
%   -------------------
%
%       - TRIAD
%
%   References
%   ----------
%   [1] Schaub, H. and Junkins, J. L.
%       Analytical Mechanics of Space Systems,
%       4th Edition, AIAA, 2018.
%
%
%   Author: Tomás M. Suárez
%   Date: 2026-07-10

close;
clear;
clc;

p = genpath("..\src");
addpath(p)

%% Initialization 

samplePeriod = 0.5; % [s]
simulationTime = 100; % [s]

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

sigmaHistory   = sigma_B(time);
trueDCMHistory = zeros(3,3,N);

for idx = 1:N
    trueDCMHistory(:,:,idx) = mrpToDCM(sigmaHistory(:,idx));
end

%% Sensor measurements

magMeasurements = zeros(3,N);
sunMeasurements = zeros(3,N);

for idx = 1:N
    state.DCM_BN = trueDCMHistory(:,:,idx);
    [magnetometer, magMeasurements(:,idx)] = magnetometer.measure(state, environment);
    [sunSensor, sunMeasurements(:,idx)]    = sunSensor.measure(state, environment);
end

%% Run determination algorithms

function angle = attitudeErrorAngle(DCM)
    prps  = dcmToPRPS(DCM);
    angle = prps(end);
end

triadError = zeros(1,N);

for idx = 1:N

    bodyVectors     = [magnetometer.DCM_SB'*magMeasurements(:,idx) sunSensor.DCM_SB'*sunMeasurements(:,idx)];
    inertialVectors = [environment.MagneticField_N environment.SunOrientation_N];

    % TRIAD
    results.TRIAD.DCM = TRIAD(bodyVectors, inertialVectors);
    results.TRIAD.Error(idx) = attitudeErrorAngle(trueDCMHistory(:,:,idx)*results.TRIAD.DCM');
end

%% Plots

methods = fieldnames(results);
M = numel(methods);

colors = lines(M);

% Deterministic estimation methods errors
figure('Name','Deterministic estimation methods');

subplot(2,1,1)
hold on;
grid on;
ylim([-5 5]);
colororder(colors(1:M,:));
title("Angle error over time")
for k = 1:M
    plot(time, results.(methods{k}).Error, 'Marker','x', 'DisplayName', methods{k})
end
ylabel("Angle [rad]")
xlabel("Time [s]")
legend('show', 'Interpreter', 'latex', 'Location','best');

% MRP evolution
colors = lines();
subplot(2,1,2)
hold on;
grid on;
colororder(colors(1:3,:));
plot(time, sigmaHistory(1:3,:))
title("MRPs over time")
ylabel("Components [-]")
xlabel("Time [s]")
legend('$\sigma_1$','$\sigma_2$','$\sigma_3$', 'Interpreter', 'latex');