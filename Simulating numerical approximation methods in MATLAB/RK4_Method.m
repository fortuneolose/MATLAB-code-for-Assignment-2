%% RK4_visualisation.m
% Visualise one Runge–Kutta (RK4) step on a continuous function

clear; clc; close all;

% ODE: dx/dt = -2x,   x(0) = 1
f  = @(t,x) -2*x;
x0 = 1;
t0 = 0;
tf = 2;

h  = 0.4;                   % fixed step size
N  = round((tf - t0)/h);    % number of RK4 steps

t = zeros(N+1,1);
x = zeros(N+1,1);
t(1) = t0;
x(1) = x0;

%% RK4 integration loop
for n = 1:N
    tn = t(n);
    xn = x(n);

    % Runge–Kutta 4 stages
    k1 = f(tn,            xn);
    k2 = f(tn + 0.5*h,    xn + 0.5*h*k1);
    k3 = f(tn + 0.5*h,    xn + 0.5*h*k2);
    k4 = f(tn + h,        xn + h*k3);

    % RK4 update
    x(n+1) = xn + h/6 * (k1 + 2*k2 + 2*k3 + k4);
    t(n+1) = tn + h;
end

%% Exact continuous solution for comparison
tt      = linspace(t0, tf, 400);
x_exact = exp(-2*tt);       % since dx/dt = -2x, x(0)=1

figure(1); hold on; grid on;
plot(tt, x_exact, 'k-', 'LineWidth', 1.5);   % continuous solution
stem(t, x, 'r', 'filled');                  % RK4 points
plot(t, x, 'r--');                          % connect the RK4 points

xlabel('t'); ylabel('x(t)');
title('RK4 approximation vs exact solution');
legend('Exact solution','RK4 samples','RK4 piecewise linear');


%% Visualise k1..k4 on the FIRST step
n  = 1;        % look at step from t(1) to t(2)
tn = t(n);
xn = x(n);

% recompute k1..k4 at this step
k1 = f(tn,            xn);
k2 = f(tn + 0.5*h,    xn + 0.5*h*k1);
k3 = f(tn + 0.5*h,    xn + 0.5*h*k2);
k4 = f(tn + h,        xn + h*k3);

% exact solution just over this one step
tt_zoom = linspace(tn, tn+h, 200);
x_zoom  = exp(-2*tt_zoom);

figure(2); hold on; grid on;
plot(tt_zoom, x_zoom, 'k', 'LineWidth', 1.5);   % true curve

% four straight lines using slopes k1..k4 (just for visualisation)
plot([tn tn+h], [xn xn + h*k1], 'b-', 'LineWidth', 1.3);
plot([tn tn+h], [xn xn + h*k2], 'g-', 'LineWidth', 1.3);
plot([tn tn+h], [xn xn + h*k3], 'm-', 'LineWidth', 1.3);
plot([tn tn+h], [xn xn + h*k4], 'c-', 'LineWidth', 1.3);

% mark actual RK4 start and end points
x_next = x(n+1);    % RK4 result already computed above
plot(tn,   xn,    'ko', 'MarkerFaceColor', 'k');
plot(tn+h, x_next,'ro', 'MarkerFaceColor', 'r');

xlabel('t'); ylabel('x(t)');
title('One RK4 step: slopes k_1, k_2, k_3, k_4');
legend('Exact solution',...
       'Line with slope k_1',...
       'Line with slope k_2',...
       'Line with slope k_3',...
       'Line with slope k_4',...
       'Start (t_n,x_n)',...
       'RK4 end (t_{n+1},x_{n+1})', ...
       'Location','best');
