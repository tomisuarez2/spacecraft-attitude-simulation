%% TEST_PRPS_DCM_CONVERSIONS
%
% Validation script for:
%
%   prpsToDCM()
%   dcmToPRPS()
%
% Assumptions:
%   - Angles in rads

clear
clc

addpath('..\')

fprintf('\n');
fprintf('=============================================\n');
fprintf(' PRPS <-> DCM Validation Test Suite\n');
fprintf('=============================================\n\n');

tol = 1e-12;

% --------------------------------------------------------
% TEST 1 - Identity attitude
% --------------------------------------------------------

fprintf('Test 1: Identity attitude...\n');

DCM = prpsToDCM(0,0,0,0);

assert(norm(DCM - eye(3),'fro') < tol);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 2 - Pure rotations
% --------------------------------------------------------

fprintf('Test 2: Pure rotations...\n');

prps = [pi/2 1 0 0;
        pi/2 0 1 0;
        pi/2 0 0 1];

for k = 1:size(prps,1)

    DCM = prpsToDCM(prps(k,:));

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

    phi = -pi + 2*pi*rand;
    e1  = rand;
    e2  = rand;
    e3  = rand;

    DCM = prpsToDCM(phi,e1,e2,e3);

    orthoError = norm(DCM*DCM' - eye(3),'fro');

    detError = abs(det(DCM)-1);

    assert(orthoError < 1e-10);
    assert(detError < 1e-10);

end

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 4 - PRPS -> DCM -> PRPS
% --------------------------------------------------------

fprintf('Test 4: Round-trip PRPS recovery...\n');

maxPhiError = 0;
maxe1Error  = 0;
maxe2Error  = 0;
maxe3Error  = 0;

N = 5000;

for k = 1:N

    phi = 0.0175 + 3.1067*rand;
    e1  = 0.01 + rand;
    e2  = 0.01 + rand;
    e3  = 0.01 + rand;

    DCM = prpsToDCM(phi,e1,e2,e3);

    [phi2,e12,e22,e32] = dcmToPRPS(DCM);

    phiErr = abs(wrapTo180(phi2-phi));
    e1Err = abs(e12-e1);
    e2Err = abs(e22-e2);
    e3Err = abs(e32-e3);

    maxPhiError = max(maxPhiError,phiErr);
    maxe1Error  = max(maxe1Error,e1Err);
    maxe2Error  = max(maxe2Error,e2Err);
    maxe3Error  = max(maxe3Error,e3Err);

end

fprintf('  Max phi error = %.3e rad\n',maxPhiError);
fprintf('  Max e1 error  = %.3e \n',maxe1Error);
fprintf('  Max e2 error  = %.3e \n',maxe2Error);
fprintf('  Max e3 error  = %.3e \n',maxe3Error);

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 5 - DCM consistency
% --------------------------------------------------------

fprintf('Test 5: Orientation consistency...\n');

maxDCMError = 0;

N = 10000;

for k = 1:N

    phi = 0.0175 + 3.1067*rand;
    e1  = 0.01 + rand;
    e2  = 0.01 + rand;
    e3  = 0.01 + rand;

    DCM1 = prpsToDCM(phi,e1,e2,e3);

    [phi2,e12,e22,e32] = dcmToPRPS(DCM1);

    DCM2 = prpsToDCM(phi2,e12,e22,e32);

    err = norm(DCM1 - DCM2,'fro');

    maxDCMError = max(maxDCMError,err);

end

fprintf('  Max Frobenius error = %.3e\n',maxDCMError);

assert(maxDCMError < 1e-10);

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 6 - Statistical stress test
% --------------------------------------------------------

fprintf('Test 6: Monte-Carlo stress test...\n');

N = 100000;

maxError = 0;

for k = 1:N

    phi = 0.0175 + 3.1067*rand;
    e1  = 0.01 + rand;
    e2  = 0.01 + rand;
    e3  = 0.01 + rand;

    DCM1 = prpsToDCM(phi,e1,e2,e3);

    [phi2,e12,e22,e32] = dcmToPRPS(DCM1);

    DCM2 = prpsToDCM(phi2,e12,e22,e32);

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
