%% TEST_EULER313_DCM_CONVERSIONS
%
% Validation script for:
%
%   euler313ToDCM()
%   dcmToEuler313()
%
% Assumptions:
%   - Euler sequence: 3-1-3 (ZXZ)
%   - Angles in rads

clear
clc

addpath('..\')

fprintf('\n');
fprintf('=============================================\n');
fprintf(' Euler 313 <-> DCM Validation Test Suite\n');
fprintf('=============================================\n\n');

tol = 1e-12;

% --------------------------------------------------------
% TEST 1 - Identity attitude
% --------------------------------------------------------

fprintf('Test 1: Identity attitude...\n');

DCM = euler313ToDCM(0,0,0);

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

    W   = angles(k,1);
    inc = angles(k,2);
    w   = angles(k,3);

    DCM = euler313ToDCM(W,inc,w);

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

    W   = -pi + 2*pi*rand;
    inc = -3.1067 + 3.0892*rand;
    w  = -pi + 2*pi*rand;

    DCM = euler313ToDCM(W,inc,w);

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

maxWError   = 0;
maxIncError = 0;
maxwError   = 0;

N = 5000;

for k = 1:N

    W   = -pi + 2*pi*rand;
    inc = -3.1067 + 3.0892*rand;
    w  = -pi + 2*pi*rand;

    DCM = euler313ToDCM(W,inc,w);

    [W2,inc2,w2] = dcmToEuler313(DCM);

    WErr   = abs(wrapTo360(W2-W));
    incErr = abs(inc2-inc);
    wErr   = abs(wrapTo360(w2-w));

    maxWError   = max(maxWError,WErr);
    maxIncError = max(maxIncError,incErr);
    maxwError   = max(maxwError,wErr);

end

fprintf('  Max W error = %.3e rad\n',maxWError);
fprintf('  Max i error = %.3e rad\n',maxIncError);
fprintf('  Max w error = %.3e rad\n',maxwError);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 5 - DCM consistency
% --------------------------------------------------------

fprintf('Test 5: Orientation consistency...\n');

maxDCMError = 0;

N = 10000;

for k = 1:N

    W   = -pi + 2*pi*rand;
    inc = -3.1067 + 3.0892*rand;
    w  = -pi + 2*pi*rand;

    DCM1 = euler313ToDCM(W,inc,w);

    [W2,inc2,w2] = dcmToEuler313(DCM1);

    DCM2 = euler313ToDCM(W2,inc2,w2);

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

testInc = [3.1416 ...
           3.1414 ...
           3.1398 ...
          -3.1416 ...
          -3.1414 ...
          -3.1398];

for inc = testInc

    W = pi/4;
    w = pi/6;

    DCM = euler313ToDCM(W,inc,w);

    [W2,inc2,w2] = dcmToEuler313(DCM);

    DCM2 = euler313ToDCM(W2,inc2,w2);

    err = norm(DCM - DCM2,'fro');

    fprintf('  inc = %+8.3f rad --> error %.3e\n', ...
            inc, err);

end

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 7 - Exact singularity
% --------------------------------------------------------

fprintf('Test 7: Exact gimbal lock...\n');

inc = pi;

W   = 2*pi/13;
w   = pi/13;

try

    DCM = euler313ToDCM(W,inc,w);

    [W2,inc2,w2] = dcmToEuler313(DCM);

    fprintf('  Returned:\n');
    fprintf('     W = %.6f\n',W2);
    fprintf('     i = %.6f\n',inc2);
    fprintf('     w = %.6f\n',w2);

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

    W   = -pi + 2*pi*rand;
    inc = -3.1067 + 3.0892*rand;
    w  = -pi + 2*pi*rand;

    DCM1 = euler313ToDCM(W,inc,w);

    [W2,inc2,w2] = dcmToEuler313(DCM1);

    DCM2 = euler313ToDCM(W2,inc2,w2);

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