Gz_num = [ 0.1725, -2.07, 3.45];
Gz_den = [ 3.45, -0.65, -0.05, 0.0105];
% I need to vreate a transfer function of a discretized system plant with sample period T = 7
T = 7;
Gz = tf(Gz_num, Gz_den, T);