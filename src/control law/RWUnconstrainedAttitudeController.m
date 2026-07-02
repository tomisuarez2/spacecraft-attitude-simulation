% =========================================================================
% RWUnconstrainedAttitudeController.m
% Class for simulating unconstrained spacecraft with reaction wheels attitude controllers.
%
% Author: Tomás Suárez
% Email:  suareztomasm@gmail.com
% GitHub: https://github.com/tomisuarez2
%
% Date Created: 2025-06-13
% Last Modified: 2025-06-18
%
% Description:
%   This class inherits from the abstract base class 'AttitudeController'
%   and implements an unconstrained attitude controller based in MRPs
%   attitude representation as it is showed in 'Analytical Mechanics for Space
%   Systems' for spacecraft with reaction wheels as actuators.
% =========================================================================
classdef RWUnconstrainedAttitudeController < AttitudeController

    properties
        Gs                % [3xM] gs vector matrix of gimball frames in body frame components.
                          % In this configuration those vectors are fixed in B reference frame.

        Gt                % [3xM] gt vector matrix of gimball frames in body frame components.
                          % In this configuration those vectors are fixed in B reference frame.

        Gg                % [3xM] gg vector matrix of gimball frames in body frame components.
                          % In this configuration those vectors are fixed in B reference frame.

        Js                % [3x(3M)] reaction wheel and gimball inertia matrices in gimball frame components.

        I                 % [3x3] Inertia matrix of the spacecraft.
                          % Must be a constant symmetric positive-definite matrix.

        IRW               % [3x3] Inertia matrix of the spacecraft.
                          % Must be a constant symmetric positive-definite matrix. 

        M                 % Number of reaction wheels.

        K                 % Attitude error proportional gain constant/matrix.

        P                 % Angular velocity error proportional gain constant/matrix.

        oRefFun           % [1x3] Funtion handle of the form @(t).
                          % Desired MRP set as a function of t.

        wRefFun           % [1x3] Funtion handle of the form @(t).
                          % Desired body angular velocity as a function of t.

        dwRefFun          % [1x3] Funtion handle of the form @(t).
                          % Desired body angular acceleration as a function of t.

        controlLawHistory % [3xN] Temporal history of computed control law.
                          % Stores the required control law in each body frame axis during the simulation steps.

        oRefHistory       % [3xN] Temporal history of desired MRP set.
                          % Stores the reference MRP set during the simulation steps.

        wRefHistory       % [3xN] Temporal history of desired angular velocity.
                          % Stores the reference angular velocity in each reference frame axis during the simulation steps.

        dwRefHistory      % [3xN] Temporal history of desired angular acceleration.
                          % Stores the reference angular acceleration in each reference frame axis during the simulation steps.

        oeHistory         % [3xN] Temporal history of attitude error expressed in MRP.
                          % Stores the attitude error expresed in MRP set during the simulation steps.
    end
    
    methods
        function obj = RWUnconstrainedAttitudeController(Gs, Gt, Gg, Js, I, K, P, oRefFun, wRefFun, dwRefFun)
            % Constructor: initializes attitude controller properties.
            obj.Gs = Gs;
            obj.Gt = Gt;
            obj.Gg = Gg;
            obj.Js = Js;
            obj.I = I;
            obj.M = size(Gs,2);
            sum = zeros(3);
            for i=1:obj.M
                sum = sum + Js(2,3*i-1)*Gt(:,i)*Gt(:,i)' + Js(3,3*i)*Gg(:,i)*Gg(:,i)';
            end
            obj.IRW = obj.I + sum;
            obj.K = K;
            obj.P = P;
            obj.oRefFun = oRefFun;
            obj.wRefFun = wRefFun;
            obj.dwRefFun = dwRefFun;         
        end
        
        function us = computeTorque(obj, t, state)
            % Computes the required control law.

            o = state(1:3);
            w = state(4:6);
            Ws = state(7:end);
            or = obj.oRefFun(t);
            oe = mrp_sum(-or,o); % Attitude error.
            BR = mrp_to_dcm(oe); % Atttiude DCM.
            wr = BR*obj.wRefFun(t);
            dwr = BR*obj.dwRefFun(t);
            hs = zeros(obj.M,1);
            for i=1:obj.M
                hs(i,1) = obj.Js(1,3*i-2)*(obj.Gs(:,i)'*w + Ws(i));
            end

            Lr = obj.K*oe + obj.P*(w - wr) - obj.IRW*(dwr - skew(w)*wr) - skew(w)*(obj.IRW*w + obj.Gs*hs - wr);

            % Minimum norm inverse:
            us = obj.Gs'/(obj.Gs*obj.Gs')*Lr;
        end

        function logHistory(obj, timeVector, stateHistory)
            % Los simulation data.
            N = size(timeVector,2);
            obj.controlLawHistory = zeros(3,N);
            obj.oRefHistory = zeros(3,N);
            obj.wRefHistory = zeros(3,N);
            obj.dwRefHistory = zeros(3,N);
            obj.oeHistory = zeros(3,N);
            for i = 1:N
                obj.controlLawHistory(:,i) = obj.Gs*obj.computeTorque(timeVector(i), stateHistory(:,i));
                obj.oRefHistory(:,i) = obj.oRefFun(timeVector(i));
                obj.oeHistory(:,i) = mrp_sum(-obj.oRefHistory(:,i),stateHistory(1:3,i));
                obj.wRefHistory(:,i) = obj.wRefFun(timeVector(i));
                obj.dwRefHistory(:,i) = obj.dwRefFun(timeVector(i));
            end
        end
    end
end

