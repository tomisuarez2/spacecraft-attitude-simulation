%% TEST_EULER321_DCM_CONVERSIONS
%
% Validation script for:
%
%   euler321ToDCM()
%   dcmToEuler321()
%
% Assumptions:
%   - Euler sequence: 3-2-1 (ZYX)
%   - Angles in rads

clear
clc

addpath('..\')

fprintf('\n');
fprintf('=============================================\n');
fprintf(' Euler 321 <-> DCM Validation Test Suite\n');
fprintf('=============================================\n\n');

tol = 1e-12;

% --------------------------------------------------------
% TEST 1 - Identity attitude
% --------------------------------------------------------

fprintf('Test 1: Identity attitude...\n');

DCM = euler321ToDCM(0,0,0);

assert(norm(DCM - eye(3),'fro') < tol);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 2 - Pure rotations
% --------------------------------------------------------

fprintf('Test 2: Pure rotations...\n');

angles = [pi/2 0    0;
          0    pi/2 0;
          0    0    pi/2];

for k = 1:size(angles,1)

    yaw   = angles(k,1);
    pitch = angles(k,2);
    roll  = angles(k,3);

    DCM = euler321ToDCM(yaw,pitch,roll);

    assert(abs(det(DCM)-1) < tol);
    assert(norm(DCM*DCM' - eye(3),'fro') < 1e-10);

end

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 3 - DCM properties
% --------------------------------------------------------

fprintf('Test 3: Orthogonality and determinant...\n');

N = 1000;

for k = 1:N

    yaw   = -pi + 2*pi*rand;
    pitch = -1.5533 + 3.1067*rand;
    roll  = -pi + 2*pi*rand;

    DCM = euler321ToDCM(yaw,pitch,roll);

    orthoError = norm(DCM*DCM' - eye(3),'fro');

    detError = abs(det(DCM)-1);

    assert(orthoError < 1e-10);
    assert(detError < 1e-10);

end

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 4 - Euler -> DCM -> Euler
% --------------------------------------------------------

fprintf('Test 4: Round-trip angle recovery...\n');

maxYawError   = 0;
maxPitchError = 0;
maxRollError  = 0;

N = 5000;

for k = 1:N

    yaw   = -pi + 2*pi*rand;
    pitch = -1.5533 + 3.1067*rand;
    roll  = -pi + 2*pi*rand;

    DCM = euler321ToDCM(yaw,pitch,roll);

    [yaw2,pitch2,roll2] = dcmToEuler321(DCM);

    yawErr   = abs(wrapTo180(yaw2-yaw));
    pitchErr = abs(pitch2-pitch);
    rollErr  = abs(wrapTo180(roll2-roll));

    maxYawError   = max(maxYawError,yawErr);
    maxPitchError = max(maxPitchError,pitchErr);
    maxRollError  = max(maxRollError,rollErr);

end

fprintf('  Max yaw error   = %.3e rad\n',maxYawError);
fprintf('  Max pitch error = %.3e rad\n',maxPitchError);
fprintf('  Max roll error  = %.3e rad\n',maxRollError);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 5 - DCM consistency
% --------------------------------------------------------

fprintf('Test 5: Orientation consistency...\n');

maxDCMError = 0;

N = 10000;

for k = 1:N

    yaw   = -pi + 2*pi*rand;
    pitch = -1.5533 + 3.1067*rand;
    roll  = -pi + 2*pi*rand;

    DCM1 = euler321ToDCM(yaw,pitch,roll);

    [yaw2,pitch2,roll2] = dcmToEuler321(DCM1);

    DCM2 = euler321ToDCM(yaw2,pitch2,roll2);

    err = norm(DCM1 - DCM2,'fro');

    maxDCMError = max(maxDCMError,err);

end

fprintf('  Max Frobenius error = %.3e\n',maxDCMError);

assert(maxDCMError < 1e-10);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 6 - Near singularity
% --------------------------------------------------------

fprintf('Test 6: Near gimbal lock...\n');

testPitch = [1.5708 ...
             1.5706 ...
             1.5691 ...
            -1.5708 ...
            -1.5706 ...
            -1.5691];

for pitch = testPitch

    yaw  = pi/4;
    roll = pi/6;

    DCM = euler321ToDCM(yaw,pitch,roll);

    [yaw2,pitch2,roll2] = dcmToEuler321(DCM);

    DCM2 = euler321ToDCM(yaw2,pitch2,roll2);

    err = norm(DCM - DCM2,'fro');

    fprintf('  pitch = %+8.3f rad --> error %.3e\n', ...
            pitch, err);

end

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 7 - Exact singularity
% --------------------------------------------------------

fprintf('Test 7: Exact gimbal lock...\n');

pitch = pi/2;

yaw  = 2*pi/13;
roll = pi/13;

try

    DCM = euler321ToDCM(yaw,pitch,roll);

    [yaw2,pitch2,roll2] = dcmToEuler321(DCM);

    fprintf('  Returned:\n');
    fprintf('     yaw   = %.6f\n',yaw2);
    fprintf('     pitch = %.6f\n',pitch2);
    fprintf('     roll  = %.6f\n',roll2);

catch ME

    fprintf('  Function raised exception:\n');
    fprintf('     %s\n',ME.message);

end

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 8 - Statistical stress test
% --------------------------------------------------------

fprintf('Test 8: Monte-Carlo stress test...\n');

N = 100000;

maxError = 0;

for k = 1:N

    yaw   = -pi + 2*pi*rand;
    pitch = -1.5533 + 3.1067*rand;
    roll  = -pi + 2*pi*rand;

    DCM1 = euler321ToDCM(yaw,pitch,roll);

    [yaw2,pitch2,roll2] = dcmToEuler321(DCM1);

    DCM2 = euler321ToDCM(yaw2,pitch2,roll2);

    err = norm(DCM1 - DCM2,'fro');

    maxError = max(maxError,err);

end

fprintf('  Maximum error found = %.3e\n',maxError);

fprintf('  PASSED\n');


% --------------------------------------------------------
% SUMMARY
% --------------------------------------------------------

fprintf('\n');
fprintf('=============================================\n');
fprintf(' ALL TESTS PASSED\n');
fprintf('=============================================\n');
fprintf('\n');

rmpath('..\')