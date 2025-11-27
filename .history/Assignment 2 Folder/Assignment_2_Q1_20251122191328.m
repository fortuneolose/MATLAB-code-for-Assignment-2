%% Parameters for student ID 21455956  --------------------
b2 = 5.5;
b3 = 13;
a1 = 6.1;
a2 = 12;
a3 = 7.1;
n  = 42;      % number of sample periods
T  = 0.2;     % sampling period (seconds)

% Continuous-time plant Gp(s)
Gps = tf([b2 b3],[1 a1 a2 a3]);
% Discrete-time plant G(z) with ZOH
Gz = c2d(Gps, T, 'zoh');
% Time vector: n samples
t = 0:T:(n-1)*T;
r = ones(size(t));     % unit step input

%% Helper: function to get closed-loop system for given Kp, Ki, Kd
pid_cl = @(Kp,Ki,Kd) ...
    feedback( ...
        tf([T*Kp + 0.5*T^2*Ki + Kd, ...
            0.5*T^2*Ki - T*Kp - 2*Kd, ...
            Kd], ...
           [T -T 0], T) ...
        * Gz, ...   % <-- multiply by plant *inside* feedback
        1);

%% 1) Increasing Kp (P control, Ki = Kd = 0)  ----------------
figure(1)
Kp_vals = [1 2 3 30];
Ki = 0; Kd = 0;
for i = 1:4
    Kp = Kp_vals(i);
    SYSz = pid_cl(Kp,Ki,Kd);
    y = lsim(SYSz, r, t);

    subplot(4,1,i)
    plot(t, r, 'g--'); hold on
    stem(t, y, 'r', 'filled')
    if i < 4
        ylim([0 2]);      % only subplots 1–3
    end
    xlabel('time (seconds)')
    ylabel('r(k) & y(k)')
    title(sprintf('Kp = %.1f, Ki = %.1f, Kd = %.1f',Kp,Ki,Kd))
end

%% 2) Increasing Ki (PI control, Kd = 0)  --------------------
figure(2)
Kp = 3;
Kd = 0;
Ki_vals = [0 2 4 40];

for i = 1:4
    Ki = Ki_vals(i);
    SYSz = pid_cl(Kp,Ki,Kd);
    y = lsim(SYSz, r, t);

    subplot(4,1,i)
    plot(t, r, 'g--'); hold on
    stem(t, y, 'r', 'filled'),
    if i < 4
        ylim([0 2]);
    end
    xlabel('time (seconds)')
    ylabel('r(k) & y(k)')
    title(sprintf('Kp = %.1f, Ki = %.1f, Kd = %.1f',Kp,Ki,Kd))
end

%% 3) Increasing Kd (full PID control)  ----------------------
figure(3)
Kp = 3;
Ki = 2;
Kd_vals = [0 0.25 0.5 30
    ];

for i = 1:4
    Kd = Kd_vals(i);
    SYSz = pid_cl(Kp,Ki,Kd);
    y = lsim(SYSz, r, t);

    subplot(4,1,i)
    plot(t, r, 'g--'); hold on
    stem(t, y, 'r', 'filled')
    if i < 4
        ylim([0 2]);
    end
    xlabel('time (seconds)')
    ylabel('r(k) & y(k)')
    title(sprintf('Kp = %.1f, Ki = %.1f, Kd = %.1f',Kp,Ki,Kd))
end