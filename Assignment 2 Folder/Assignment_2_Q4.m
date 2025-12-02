clc; clear; close all;

% Discrete-time plant
Ts  = 1;                            % sample period
num = [2 13 -7];                    % G(z) = (2 z^-1 + 13 z^-2 - 7 z^-3) / ...
den = [1 7 -24 -180];
Gz  = tf(num,den,Ts);

% State-space model of plant
[A,B,C,D] = ssdata(Gz);

% Desired eigenvalue sets
lambda{1} = [ 0.6  0.6  0.6];       % (a)
lambda{2} = [-0.6 -0.6 -0.6];       % (b)
lambda{3} = [ 0.4  0.4  0.4];       % (c)
lambda{4} = [-0.4 -0.4 -0.4];       % (d)

% Simulation data
k  = 0:19;                          % 20 samples
r  = ones(size(k));                 % unit step reference

figure;

for i = 1:4
    lam = lambda{i};

    % State-feedback gain by pole placement
    K = acker(A,B,lam);

    % Closed-loop A matrix with state feedback u = −Kx + N r
    Acl = A - B*K;

    % Precompensator N for unit steady-state gain y/r
    sys_tmp = ss(Acl,B,C,D,Ts);     % v as input
    N = 1/dcgain(sys_tmp);          % choose N so dcgain from v to y is 1

    % Closed-loop system from reference r(k) to output y(k)
    sys_cl = ss(Acl,B*N,C,D,Ts);

    % Simulate closed-loop output (zero initial condition)
    [y, t, x] = lsim(sys_cl, r, k);

    % Plot
    subplot(2,2,i);

    % Discrete output samples in red
    stem(t, y, 'r', 'filled'); hold on;

    % Reference as green dashed line (NOT stem)
    plot(t, r, 'g--', 'LineWidth', 1.2);

    grid on;
    if i == 4
        xlabel('sample number, k');
    end
    ylabel('r(k) & y(k)');

    title(sprintf('eigenvalues at %0.1f, %0.1f, %0.1f', lam(1), lam(2), lam(3)));
    legend('System output, y(k)', 'system input, r(k)', 'Location', 'best');
end
