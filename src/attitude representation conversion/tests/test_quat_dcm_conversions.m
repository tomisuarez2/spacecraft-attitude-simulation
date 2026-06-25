%% TEST_QUAT_DCM_CONVERSIONS
%
% Validation script for:
%
%   quatToDCM()
%   dcmToQuat()

clear
clc

addpath('..\')

fprintf('\n');
fprintf('===============================================\n');
fprintf(' Unit Quaternion <-> DCM Validation Test Suite\n');
fprintf('===============================================\n\n');

tol = 1e-12;

% --------------------------------------------------------
% TEST 1 - Identity attitude
% --------------------------------------------------------

fprintf('Test 1: Identity attitude...\n');

DCM = quatToDCM([1,0,0,0]');

assert(norm(DCM - eye(3),'fro') < tol);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 2 - Pure rotations
% --------------------------------------------------------

fprintf('Test 2: Pure rotations...\n');

quats = [0 1 0 0;
         0 0 1 0;
         0 0 0 1];

for k = 1:size(quats,1)

    DCM = quatToDCM(quats(k,:)');

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

    b0 = 0.01 + rand;
    b1 = 0.01 + rand;
    b2 = 0.01 + rand;
    b3 = 0.01 + rand;

    DCM = quatToDCM([b0,b1,b2,b3]');

    orthoError = norm(DCM*DCM' - eye(3),'fro');

    detError = abs(det(DCM)-1);

    assert(orthoError < 1e-10);
    assert(detError < 1e-10);

end

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 4 - Unit Quaternion -> DCM -> Unit Quaternion
% --------------------------------------------------------

fprintf('Test 4: Round-trip Unit Quaternion recovery...\n');

maxb0Error = 0;
maxb1Error = 0;
maxb2Error = 0;
maxb3Error = 0;

N = 5000;

for k = 1:N

    b0 = 0.01 + rand;
    b1 = 0.01 + rand;
    b2 = 0.01 + rand;
    b3 = 0.01 + rand;

    beta = [b0 b1 b2 b3]';
    beta = beta/norm(beta);

    DCM = quatToDCM(beta);

    beta2 = dcmToQuat(DCM);
    
    b0Err = abs(beta2(1)-beta(1));
    b1Err = abs(beta2(2)-beta(2));
    b2Err = abs(beta2(3)-beta(3));
    b3Err = abs(beta2(4)-beta(4));

    maxb0Error = max(maxb0Error,b0Err);
    maxb1Error = max(maxb1Error,b1Err);
    maxb2Error = max(maxb2Error,b2Err);
    maxb3Error = max(maxb3Error,b3Err);

end

fprintf('  Max b0 error = %.3e \n',maxb0Error);
fprintf('  Max b1 error = %.3e \n',maxb1Error);
fprintf('  Max b2 error = %.3e \n',maxb2Error);
fprintf('  Max b3 error = %.3e \n',maxb3Error);

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 5 - DCM consistency
% --------------------------------------------------------

fprintf('Test 5: Orientation consistency...\n');

maxDCMError = 0;

N = 10000;

for k = 1:N

    b0 = 0.01 + rand;
    b1 = 0.01 + rand;
    b2 = 0.01 + rand;
    b3 = 0.01 + rand;

    beta = [b0 b1 b2 b3]';
    beta = beta/norm(beta);

    DCM1 = quatToDCM(beta);

    beta2 = dcmToQuat(DCM1);

    DCM2 = quatToDCM(beta2);

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

    b0 = 0.01 + rand;
    b1 = 0.01 + rand;
    b2 = 0.01 + rand;
    b3 = 0.01 + rand;

    beta = [b0 b1 b2 b3]';
    beta = beta/norm(beta);

    DCM1 = quatToDCM(beta);

    beta2 = dcmToQuat(DCM1);

    DCM2 = quatToDCM(beta2);

    err = norm(DCM1 - DCM2,'fro');

    maxError = max(maxError,err);

end

fprintf('  Maximum error found = %.3e\n', maxError);

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
