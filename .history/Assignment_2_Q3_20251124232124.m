%% tf2ss_discrete.m
% Convert a discrete-time transfer function G(z) to state-space form
% G(z) = (b0 + b1 z^-1 + ... + b_nb z^-nb) / (1 + a1 z^-1 + ... + a_na z^-na)

clc; clear; close all;

% ---- USER INPUT ----
% Numerator and denominator coefficients in descending powers of z^-1
% Example: G(z) = (0.1 + 0.2 z^-1) / (1 - 1.3 z^-1 + 0.42 z^-2), Ts = 0.05 s
num = [0.1 0.2];              % [b0 b1 ... b_nb]
den = [1 -1.3 0.42];          % [1 a1 ... a_na]
Ts  = 0.05;                   % sampling time (seconds)

% ---- NORMALIZE DENOMINATOR (if leading coeff ~= 1) ----
if den(1) ~= 1
    num = num / den(1);
    den = den / den(1);
end

% ---- BUILD DISCRETE-TIME TF OBJECT ----
Gz = tf(num, den, Ts);        % discrete-time transfer function

% ---- CONVERT TO STATE-SPACE ----
sys_ss = ss(Gz);              % default (controllable canonical form)

% Extract A, B, C, D matrices
[A, B, C, D] = ssdata(sys_ss);

% ---- DISPLAY RESULTS ----
disp('Discrete-time transfer function G(z):');
Gz

disp('State-space representation (x[k+1] = A x[k] + B u[k],  y[k] = C x[k] + D u[k]):');
disp('A ='); disp(A);
disp('B ='); disp(B);
disp('C ='); disp(C);
disp('D ='); disp(D);
disp(['Sample time Ts = ', num2str(Ts), ' seconds']);
