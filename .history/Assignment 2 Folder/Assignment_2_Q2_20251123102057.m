% Discrete-time plant G(z)
Gz_num = [0.1725, -2.07, 3.45];
Gz_den = [3.45, -0.65, -0.05, 0.0105];

T = 7;                 % sample period (seconds)
Gz = tf(Gz_num, Gz_den, T);

% DC gain and poles
DC_gain = dcgain(Gz);
p       = pole(Gz);

fprintf('DC gain of G(z) = %.4f\n', DC_gain);
fprintf('Poles of G(z):\n');
for i = 1:length(p)
    fprintf('p%d = %.6f\n', i, p(i));
end

% Number of samples to simulate
N = 25;   % adjust to match how long you want the plot

%% Unit impulse response (discrete-time)
[y_imp, t_imp] = impulse(Gz, N);   % t_imp already in seconds (k*T)

figure(1); clf
stem(t_imp, y_imp, 'r', 'filled');  % discrete samples
title('Unit Impulse Response of G(z)')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid on

%% Unit step response (discrete-time)
[y_step, t_step] = step(Gz, N);

figure(2); clf
% Reference step (green dashed)
plot(t_step, ones(size(t_step)), 'g--');
hold on
% Discrete response as stems (red)
stem(t_step, y_step, 'r', 'filled');
hold off

title('Unit Step Response of G(z)')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid on
