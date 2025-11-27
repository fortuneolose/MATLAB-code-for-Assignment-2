Gz_num = [ 0.1725, -2.07, 3.45 ];
Gz_den = [ 3.45, -0.65, -0.05, 0.0105 ];
% I need to create a transfer function of a discretized system plant with sample period T = 7
T = 7;
Gz = tf(Gz_num, Gz_den, T);
% I need to find the DC gain & poles of G(z)
DC_gain = dcgain(Gz);
p = pole(Gz);
% Display DC gain and poles with descriptive labels
fprintf('DC gain of G(z) = %.4f\n', DC_gain);
fprintf('Poles of G(z):\n');
for i = 1:length(p)
    fprintf('p%d = %.4f\n', i, p(i));
end
