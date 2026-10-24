%% EXAMPLE_STARDUST_DYNAMICS
%
%   Author: Tomás M. Suárez
%   Date: 2026-10-19
%
%   Validates the developed framework using Stardust NASA Mission dataset.
%
%   Steps for dynamics validation
%   -------------------------------
%   (1) Dataset's Observed Thruster's firing + Dynamics model -- (Integration) --> Integrated Angular Velocity
%   (2) Integrated Angular Velocity <-- (Comparison) --> Dataset's Observed Angular Velocity
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
sff = readtable("../stardust_dataset/small_forces.csv");
% Windows OS
%att = readtable("..\stardust_dataset\attitude.csv");
%sff = readtable("..\stardust_dataset\small_forces.csv");

% Data Inspection
disp(head(att));
disp(head(sff));

% Check the temporal coverage
fprintf("Attitude records: %d\n", height(att));
fprintf("Small Forces records: %d\n", height(sff));

fprintf("Attitude start: %s\n", string(att.UTC_TIME(1)));
fprintf("Attitude end: %s\n", string(att.UTC_TIME(end)));

fprintf("Small Forces start: %s\n", string(sff.BEGIN_TIME(1)));
fprintf("Small Forces end: %s\n", string(sff.END_TIME(end)));

%% Time evolution

% Common time origin: first attitude record
t0 = att.UTC_TIME(1);

% Time relative to the first attitude record
tAtt = seconds(att.UTC_TIME' - t0);
[tAtt, uniqIdcs] = unique(tAtt);

%% Angular velocity evolution

% [rad/s]
wObs = [att.ATT_RAT_BF_X'; att.ATT_RAT_BF_Y'; att.ATT_RAT_BF_Z'];
wObs = wObs(:,uniqIdcs);

%% Thruster's firings evolution over time

intervalStart = seconds(sff.BEGIN_TIME' - t0);
intervalDuration = double(sff.DTIME);
nRecords = height(sff);

% Only RCS1:4 and TCM1:4 were used during the approach maneuver.
nThrusters = 4;

% Initialize pulse event arrays for RCS and TCM
pulseThrusterRCS = [];
pulseStartRCS = [];
pulseEndRCS = [];

pulseThrusterTCM = [];
pulseStartTCM = [];
pulseEndTCM = [];

for iThruster = 1:nThrusters

    fprintf("Processing RCS thruster %d...\n", iThruster);
    fprintf("Processing TCM thruster %d...\n", iThruster);

    cmdColumnRCS = sprintf("RCS%d_ACC_ON_CMDS", iThruster);
    timeColumnRCS = sprintf("RCS%d_ACC_ON_TIME", iThruster);

    cmdColumnTCM = sprintf("TCM%d_ACC_ON_CMDS", iThruster);
    timeColumnTCM = sprintf("TCM%d_ACC_ON_TIME", iThruster);

    nCmdRCS = double(sff.(cmdColumnRCS));

    nCmdTCM = double(sff.(cmdColumnTCM));

    % Accumulated on-time: milliseconds -> seconds.
    onTimeRCS = double(sff.(timeColumnRCS)) / 1000;
    onTimeTCM = double(sff.(timeColumnTCM)) / 1000;

    % RCS records
    for k = 1:nRecords

        NRCS = nCmdRCS(k);
        T_on_RCS = onTimeRCS(k);
        T_interval_RCS = intervalDuration(k);

        % Skip invalid records
        if ~isfinite(NRCS) || ~isfinite(T_on_RCS) || ~isfinite(T_interval_RCS)
            continue;
        end

        % No commands: no pulses to reconstruct
        if NRCS == 0
            continue;
        end

        % Reject physically inconsistent records
        if NRCS < 0 || NRCS ~= round(NRCS) || T_on_RCS < 0 || T_interval_RCS <= 0
            warning('Invalid RCS%d data at record %d.', iThruster, k);
            continue;
        end

        if T_on_RCS > T_interval_RCS + 1e-6
            warning('On-time exceeds interval duration for RCS%d, record %d.', ...
                iThruster, k);
            continue;
        end

        % Estimated duration of each pulse [s].
        tau = T_on_RCS / NRCS;

        % Uniform spacing between pulse slots [s].
        slotDuration = T_interval_RCS / NRCS;

        % Place each pulse at the center of its slot.
        for j = 1:NRCS

            pulseCenter = intervalStart(k) + (j - 0.5) * slotDuration;

            tPulseStart = pulseCenter - tau / 2;
            tPulseEnd = pulseCenter + tau / 2;

            % Store pulse event.
            pulseThrusterRCS(end+1, 1) = iThruster;
            pulseStartRCS(end+1, 1) = tPulseStart;
            pulseEndRCS(end+1, 1) = tPulseEnd;

        end
    end

    % TCM records
    for k = 1:nRecords

        NTCM = nCmdTCM(k);
        T_on_TCM = onTimeTCM(k);
        T_interval_TCM = intervalDuration(k);

        % Skip invalid records
        if ~isfinite(NTCM) || ~isfinite(T_on_TCM) || ~isfinite(T_interval_TCM)
            continue;
        end

        % No commands: no pulses to reconstruct
        if NTCM == 0
            continue;
        end

        % Reject physically inconsistent records
        if NTCM < 0 || NTCM ~= round(NTCM) || T_on_TCM < 0 || T_interval_TCM <= 0
            warning('Invalid TCM%d data at record %d.', iThruster, k);
            continue;
        end

        if T_on_TCM > T_interval_TCM + 1e-6
            warning('On-time exceeds interval duration for TCM%d, record %d.', ...
                iThruster, k);
            continue;
        end

        % Estimated duration of each pulse [s].
        tau = T_on_TCM / NTCM;

        % Uniform spacing between pulse slots [s].
        slotDuration = T_interval_TCM / NTCM;

        % Place each pulse at the center of its slot.
        for j = 1:NTCM

            pulseCenter = intervalStart(k) + (j - 0.5) * slotDuration;

            tPulseStart = pulseCenter - tau / 2;
            tPulseEnd = pulseCenter + tau / 2;

            % Store pulse event.
            pulseThrusterTCM(end+1, 1) = iThruster;
            pulseStartTCM(end+1, 1) = tPulseStart;
            pulseEndTCM(end+1, 1) = tPulseEnd;

        end
    end
end

% Choose the desired sampling period
dt = 0.01;  % 10 ms

timeThr_on = (0:dt:max(pulseEndRCS));

RCS_on = zeros(nThrusters, length(timeThr_on));
TCM_on = zeros(nThrusters, length(timeThr_on));

% RCS
for iThruster = 1:nThrusters

    idx = pulseThrusterRCS == iThruster;

    starts = pulseStartRCS(idx);
    ends = pulseEndRCS(idx);

    %  Mark samples during each estimated pulse
    for j = 1:length(starts)

        active = (timeThr_on >= starts(j)) & (timeThr_on < ends(j));

        RCS_on(iThruster, active) = true;

    end
end

% TCM
for iThruster = 1:nThrusters

    idx = pulseThrusterTCM == iThruster;

    starts = pulseStartTCM(idx);
    ends = pulseEndTCM(idx);

    %  Mark samples during each estimated pulse
    for j = 1:length(starts)

        active = (timeThr_on >= starts(j)) & (timeThr_on < ends(j));

        TCM_on(iThruster, active) = true;

    end
end

clear pulseStartRCS pulseStartRCS pulseThrusterRCS;
clear pulseStartTCM pulseStartTCM pulseThrusterTCM;

RCS_on_interp = griddedInterpolant(timeThr_on, RCS_on', 'previous', 'previous')';
TCM_on_interp = griddedInterpolant(timeThr_on, TCM_on', 'previous', 'previous')';

%% Spacecraft's inertial properties

% Spacecraft products and moments of inertia with respect to (w.r.t.) the 
% spacecraft coordinates translated to spacecraft center of mass, kg/meter^2.

Ixx  =  87.6748;
Iyy  = 200.2580;
Izz  = 241.1340;
Ixy  =   0.2169;
Ixz  =   4.1547;
Iyz  =  -1.4881;

I    = [Ixx Ixy Ixz; 
        Ixy Iyy Iyz; 
        Ixz Iyz Izz];

% Spacecraft center of mass w.r.t. spacecraft reference frame, meters:

CM   = [ -1.18277,    -0.000567,     0.0340397 ]';

% Spacecraft's inertia with respect its principal axes and 
% its corresponding rotation matrix.

[R_ppl, I_ppl] = eig(I);

if det(R_ppl) < 0
    R_ppl(:,1) = -R_ppl(:,1);
end

%% Torque delivered by the thrusters through time

lbf2N = 4.44822;

thrustRCS_lbf = 0.2; % [lbf]
thrustRCS_n = thrustRCS_lbf * lbf2N; % [N]

thrustTCM_lbf = 1; % [lbf]
thrustTCM_n = thrustTCM_lbf * lbf2N; % [N]

% Effective thrust direction unit vectors w.r.t. spacecraft 
% reference frame (unit vector):

dirRCS = zeros(3,4);

dirRCS(:,1) = [       0,       -0.2588,        0.9659 ]';
dirRCS(:,2) = [       0,       -0.2588,        0.9659 ]';
dirRCS(:,3) = [       0,        0.2588,        0.9659 ]';
dirRCS(:,4) = [       0,        0.2588,        0.9659 ]';

dirTCM = zeros(3,4);

dirTCM(:,1) = [ -0.1736,        0.2549,        0.9513 ]';
dirTCM(:,2) = [  0.1736,        0.2549,        0.9513 ]';
dirTCM(:,3) = [  0.1736,       -0.2549,        0.9513 ]';
dirTCM(:,4) = [ -0.1736,       -0.2549,        0.9513 ]';

% Thruster location w.r.t. spacecraft reference frame, meters:

locRCS = zeros(3,4);

locRCS(:,1) = [ -0.7176,        0.2606,       -0.5072 ]';
locRCS(:,2) = [  -1.662,        0.2606,       -0.5072 ]';
locRCS(:,3) = [  -1.662,       -0.2606,       -0.5072 ]';
locRCS(:,4) = [ -0.7176,       -0.2606,       -0.5072 ]';

locTCM = zeros(3,4);

locTCM(:,1) = [ -0.6132,         0.257,       -0.5159 ]';
locTCM(:,2) = [  -1.767,         0.257,       -0.5159 ]';
locTCM(:,3) = [  -1.767,        -0.257,       -0.5159 ]';
locTCM(:,4) = [ -0.6132,        -0.257,       -0.5159 ]';

% Effective thrust direction unit vectors w.r.t. spacecraft 
% principal inertial axes (unit vector):

dirRCS_ppl = R_ppl' * dirRCS;
dirTCM_ppl = R_ppl' * dirTCM;

% Thruster location w.r.t. spacecraft principal inertial axis, meters:

locRCS_ppl = R_ppl' * (locRCS - CM);
locTCM_ppl = R_ppl' * (locTCM - CM);

% Torque delivered by RCSs

torDirRCS = zeros(3, nThrusters);
for i = 1:nThrusters
    torDirRCS(:,i) = thrustRCS_n * cross(locRCS_ppl(:,i),dirRCS_ppl(:,i));
end

torRCS = @(t) (sum(RCS_on_interp(t) .* torDirRCS, 2));

% Torque delivered by TCMs

torDirTCM = zeros(3, nThrusters);
for i = 1:nThrusters
    torDirTCM(:,i) = thrustTCM_n * cross(locTCM_ppl(:,i),dirTCM_ppl(:,i));
end

torTCM = @(t) (sum(TCM_on_interp(t) .* torDirTCM, 2));

%% Integrator Dynamics definition

% Angular Velocity integration
torque = @(t) torRCS(t) + torTCM(t);
dynamics = @(t,y) computeEulerEquations(I_ppl, y , torque(t));

%% Numerical integration

tStart_idx = 4880;
tEnd_idx = 5380;

tStart = tAtt(tStart_idx);
tEnd = tAtt(tEnd_idx);

% Initial Angular Velocity state
y0 = R_ppl' * wObs(:,tStart_idx);

[tOut, yOut] = rk4Integrator(dynamics, [tStart tEnd], y0);

% Integrated angular velocity w.r.t. spacecraft reference frame
wInt = R_ppl * yOut;

% Observed Angular Velocity vs Integrated Angular Velocity
figure;
plot(tAtt, wObs, 'LineStyle','-');
hold on;
plot(tOut, wInt, 'LineStyle','--')
xlabel("Time [s]")
ylabel("Angular Velocity [rad/s]");
legend("$\omega_{obs,1}$", "$\omega_{obs,2}$", "$\omega_{obs,3}$", ...
    "$\omega_{int,1}$", "$\omega_{int,2}$", "$\omega_{int,3}$", ...
    "Location", "best", 'Interpreter', 'latex');
title("Angular Velocity evolution");
grid on;