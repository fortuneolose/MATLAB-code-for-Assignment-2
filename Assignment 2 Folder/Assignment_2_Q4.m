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
    % (first form system with input v, then scale)
    sys_tmp = ss(Acl,B,C,D,Ts);     % v as input
    N = 1/dcgain(sys_tmp);          % choose N so dcgain from v to y is 1

    % Closed-loop system from reference r(k) to output y(k)
    sys_cl = ss(Acl,B*N,C,D,Ts);

    % Simulate closed-loop output
    [y, t, x] = lsim(sys_cl, r, k);  % zero initial condition by default

    % Recover actual control input u(k) = −K x(k) + N r(k)
    u = zeros(length(t),1);
    for j = 1:length(t)
        u(j) = -K * x(j,:).' + N * r(j);
    end

    % Plot
    subplot(2,2,i);
    stem(t, y, 'filled'); hold on;
    plot(t, u);
    if i == 4
        xlabel('sample number, k');
    end
    title(sprintf('eigenvalues at %0.1f, %0.1f, %0.1f', lam(1), lam(2), lam(3)));
    legend('output y[k]', 'input u[k]', 'Location', 'best');
end
