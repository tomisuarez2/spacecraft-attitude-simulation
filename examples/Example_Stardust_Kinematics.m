%% EXAMPLE_STARDUST_KINEMATICS
%
%   Author: Tomás M. Suárez
%   Date: 2026-10-14
%
%   Validates the developed framework using Stardust NASA Mission dataset.
%
%   Steps for kinematics validation
%   -------------------------------
%   (1) Dataset's Observed Angular Velocity -- (Integration) --> Integrated Attitude Quaternion
%   (2) Integrated Attitude Quaternion <-- (Comparison) --> Dataset's Observed Attitude Quaternion
%
%   Notes
%   -----
%   A python's parser was written for data extraction from [1] to csv files.
%
%   References
%   ----------
%   [1] https://pdssbn.astro.umd.edu/holdings/sdu-c-dynsci-2-wild2-v1.0/dataset.shtml

close all;
clear;
clc;

% Linux OS
p = genpath("../src");
% Windows OS
%p = genpath("..\src")

addpath(p)

%% Reading the data

% Linux OS
att = readtable("../stardust_dataset/attitude.csv");
% Windows OS
%att = readtable("..\stardust_dataset\attitude.csv");

% Data Inspection
disp(head(att));

% Check the temporal coverage
fprintf("Attitude records: %d\n", height(att));

fprintf("Attitude start: %s\n", string(att.UTC_TIME(1)));
fprintf("Attitude end: %s\n", string(att.UTC_TIME(end)));

%% Time evolution

% Time relative to the first attitude record
tAtt = seconds(att.UTC_TIME' - att.UTC_TIME(1));
[tAtt, uniqIdcs] = unique(tAtt);

%% Angular velocity evolution

% [rad/s]
wObs = [att.ATT_RAT_BF_X'; att.ATT_RAT_BF_Y'; att.ATT_RAT_BF_Z'];
wObs = wObs(:,uniqIdcs);

figure;
plot(tAtt, wObs);
xlabel("Time [s]");
ylabel("Dataset's Angular Velocity [rad/s]");
legend("\omega_x", "\omega_y", "\omega_z", "Location", "best");
title("Dataset observed angular velocity evolution");
grid on;

%% Attitude quaternion evolution

% Scalar first convention
quatObs = [att.ATT_QU_I2B_4';
           att.ATT_QU_I2B_1';
           att.ATT_QU_I2B_2';
           att.ATT_QU_I2B_3'];
quatObs = quatObs(:,uniqIdcs);

% Normalize observed quaternions
quatObs = quatObs ./ vecnorm(quatObs, 2, 1);

% Keep short rotation only
quatObs(:, quatObs(1,:) < 0) = -quatObs(:, quatObs(1,:) < 0);

%% Integrator Kinematics definition

wObs_interp = griddedInterpolant(tAtt, wObs', 'linear', 'linear')';

% MRPs integration
kinematics = @(t,y) [computeMRPKinematics(y(1:3),wObs_interp(t))];

%% Numerical integration

% Initial MRPs state
y0 = quatToMRP(quatObs(:,1));

[tOut, yOut] = rkf45Integrator(kinematics, [tAtt(1) tAtt(end)], y0, @switchMRP);

Nint = length(tOut);
quatInt = zeros(4, Nint);
for i=1:Nint
    quatInt(:,i) = mrpToQuat(yOut(:,i));
end

% Normalize integrated quaternions
quatInt = quatInt ./ vecnorm(quatInt, 2, 1);

% Observed Attitude Quaternion vs Integrated Attitude Quaternion
figure;
plot(tAtt, quatObs, 'LineStyle','-');
hold on;
plot(tOut, quatInt, 'LineStyle','--')
xlabel("Time [s]")
ylabel("Attitude Quaternion I2B [-]");
legend("$q_{obs,0}$", "$q_{obs,1}$", "$q_{obs,2}$", "$q_{obs,3}$", ...
    "$q_{int,0}$", "$q_{int,1}$", "$q_{int,2}$", "$q_{int,3}$", ...
    "Location", "best", 'Interpreter', 'latex');
title("Attitude quaternion evolution");
grid on;

%% Attitude error metrics

% Interpolate integrated attitude at observed timestamps
quatIntAtObs = interp1(tOut, quatInt', tAtt, 'linear')';

% Normalize interpolated quaternions
quatIntAtObs = quatIntAtObs ./ vecnorm(quatIntAtObs, 2, 1);

% Relative attitude error angle
Nobs = length(tAtt);
thetaErr = zeros(1,Nobs);
for i=1:Nobs
    quatRel = quatProd(quatConj(quatIntAtObs(:,i)), quatObs(:,i));
    cosHalfAngle = abs(quatRel(1));
    cosHalfAngle = min(1, max(0, cosHalfAngle));
    thetaErr(i) = 2 * acos(cosHalfAngle);
end

% Time-weighted metrics
duration = tAtt(end) - tAtt(1);

if duration <= 0
    error('The attitude dataset must cover a positive time interval.');
end

rmseTheta = sqrt(trapz(tAtt, thetaErr.^2) / duration);
meanTheta = trapz(tAtt, thetaErr) / duration;
maxTheta = max(thetaErr);

% Display results
fprintf('\nAttitude validation metrics\n');
fprintf('---------------------------\n');
fprintf('Time interval:          %.3f s\n', duration);
fprintf('Mean angular error:     %.6f deg\n', rad2deg(meanTheta));
fprintf('Angular error RMSE:     %.6f deg\n', rad2deg(rmseTheta));
fprintf('Maximum angular error:  %.6f deg\n', rad2deg(maxTheta));

% Plot angular error
figure;
plot(tAtt, rad2deg(thetaErr), 'LineWidth', 1.2);
xlabel('Time [s]');
ylabel('Angular error [deg]');
title('Attitude integration error');
grid on;

