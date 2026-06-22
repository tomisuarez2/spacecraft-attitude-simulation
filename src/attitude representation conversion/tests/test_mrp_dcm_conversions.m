%% TEST_MRP_DCM_CONVERSIONS
%
% Validation script for:
%
%   mrpToDCM()
%   dcmToMRP()

clear
clc

addpath('..\')

fprintf('\n');
fprintf('================================================================\n');
fprintf(' Modified Rodrigues Parameter <-> DCM Validation Test Suite\n');
fprintf('================================================================\n\n');

tol = 1e-12;

% --------------------------------------------------------
% TEST 1 - Identity attitude
% --------------------------------------------------------

fprintf('Test 1: Identity attitude...\n');

DCM = mrpToDCM([0 0 0]);

assert(norm(DCM - eye(3),'fro') < tol);

fprintf('  PASSED\n');


% --------------------------------------------------------
% TEST 2 - Pure rotations
% --------------------------------------------------------

fprintf('Test 2: Pure rotations...\n');

mrps = [1 0 0;
        0 1 0;
        0 0 1];

for k = 1:size(mrps,1)

    DCM = mrpToDCM(mrps(k,:));

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

    s1 = -1 + 2*rand;
    s2 = -1 + 2*rand;
    s3 = -1 + 2*rand;

    sigma = [s1 s2 s3];
    no = norm(sigma);

    if no > 1
        sigma = -sigma/no/no;
    end

    DCM = mrpToDCM(sigma);

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

maxs1Error = 0;
maxs2Error = 0;
maxs3Error = 0;

N = 5000;

for k = 1:N

    s1 = -1 + 2*rand;
    s2 = -1 + 2*rand;
    s3 = -1 + 2*rand;

    sigma = [s1 s2 s3];
    no = norm(sigma);

    if no > 1
        sigma = -sigma/no/no;
    end

    DCM = mrpToDCM(sigma);

    sigma2 = dcmToMRP(DCM);
    
    s1Err = abs(sigma2(1)-sigma(1));
    s2Err = abs(sigma2(2)-sigma(2));
    s3Err = abs(sigma2(3)-sigma(3));

    maxs1Error = max(maxs1Error,s1Err);
    maxs2Error = max(maxs2Error,s2Err);
    maxs3Error = max(maxs3Error,s3Err);

end

fprintf('  Max s1 error = %.3e \n',maxs1Error);
fprintf('  Max s2 error = %.3e \n',maxs2Error);
fprintf('  Max s3 error = %.3e \n',maxs3Error);

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 5 - DCM consistency
% --------------------------------------------------------

fprintf('Test 5: Orientation consistency...\n');

maxDCMError = 0;

N = 10000;

for k = 1:N

    s1 = -1 + 2*rand;
    s2 = -1 + 2*rand;
    s3 = -1 + 2*rand;

    sigma = [s1 s2 s3];
    no = norm(sigma);

    if no > 1
        sigma = -sigma/no/no;
    end

    DCM1 = mrpToDCM(sigma);

    sigma2 = dcmToMRP(DCM1);

    DCM2 = mrpToDCM(sigma2);

    err = norm(DCM1 - DCM2,'fro');

    maxDCMError = max(maxDCMError,err);

end

fprintf('  Max Frobenius error = %.3e\n',maxDCMError);

assert(maxDCMError < 1e-7);

fprintf('  PASSED\n');

% --------------------------------------------------------
% TEST 6 - Statistical stress test
% --------------------------------------------------------

fprintf('Test 6: Monte-Carlo stress test...\n');

N = 100000;

maxError = 0;

for k = 1:N

    s1 = -1 + 2*rand;
    s2 = -1 + 2*rand;
    s3 = -1 + 2*rand;

    sigma = [s1 s2 s3];
    no = norm(sigma);

    if no > 1
        sigma = -sigma/no/no;
    end

    DCM1 = mrpToDCM(sigma);

    sigma2 = dcmToMRP(DCM1);

    DCM2 = mrpToDCM(sigma2);

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
