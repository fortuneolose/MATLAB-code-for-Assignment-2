%% Build Simulink diagram for discrete-time state-space system
% System:
% x1(k+1) = x2(k)
% x2(k+1) = x3(k)
% x3(k+1) = 180*x1(k) + 24*x2(k) - 7*x3(k) + u(k)
% y(k)    = -7*x1(k) + 13*x2(k) + 2*x3(k)

clc; clear;

modelName = 'ss_canonical_diagram';
Ts        = 1;   % sample time

% Close and delete any old version
if bdIsLoaded(modelName)
    close_system(modelName,0);
end
if exist([modelName '.slx'],'file')
    delete([modelName '.slx']);
end

%% Create new model
new_system(modelName);
open_system(modelName);

x0 = 30; y0 = 30; dx = 90; dy = 80;  % base positions for blocks

%% Add Step input
add_block('simulink/Sources/Step', [modelName '/Step'], ...
    'Position', [x0 y0+dy  x0+40  y0+dy+40], ...
    'Time', '0', 'SampleTime', num2str(Ts));

%% Add unit delays for x3, x2, x1
add_block('simulink/Discrete/Unit Delay', [modelName '/Delay_x3'], ...
    'Position', [x0+200 y0+dy  x0+260 y0+dy+40], ...
    'SampleTime', num2str(Ts));

add_block('simulink/Discrete/Unit Delay', [modelName '/Delay_x2'], ...
    'Position', [x0+350 y0+dy  x0+410 y0+dy+40], ...
    'SampleTime', num2str(Ts));

add_block('simulink/Discrete/Unit Delay', [modelName '/Delay_x1'], ...
    'Position', [x0+500 y0+dy  x0+560 y0+dy+40], ...
    'SampleTime', num2str(Ts));

% Add labels (optional)
set_param([modelName '/Delay_x3'], 'Name', 'z^-1_x3');
set_param([modelName '/Delay_x2'], 'Name', 'z^-1_x2');
set_param([modelName '/Delay_x1'], 'Name', 'z^-1_x1');

%% Gains feeding x3(k+1) sum: 180*x1, 24*x2, -7*x3
add_block('simulink/Math Operations/Gain', [modelName '/G180'], ...
    'Gain', '180', 'Position', [x0+500 y0-40 x0+540 y0]);

add_block('simulink/Math Operations/Gain', [modelName '/G24'], ...
    'Gain', '24', 'Position', [x0+350 y0-40 x0+390 y0]);

add_block('simulink/Math Operations/Gain', [modelName '/Gm7'], ...
    'Gain', '-7', 'Position', [x0+200 y0-40 x0+240 y0]);

%% Summing junction for x3(k+1)
add_block('simulink/Math Operations/Sum', [modelName '/Sum_x3'], ...
    'Inputs', '++++', ...
    'Position', [x0+120 y0+dy-10  x0+160 y0+dy+30]);

%% Gains for output equation y = -7*x1 + 13*x2 + 2*x3
add_block('simulink/Math Operations/Gain', [modelName '/Gy1'], ...
    'Gain', '-7', 'Position', [x0+600 y0+dy+80 x0+640 y0+dy+120]);

add_block('simulink/Math Operations/Gain', [modelName '/Gy2'], ...
    'Gain', '13', 'Position', [x0+450 y0+dy+80 x0+490 y0+dy+120]);

add_block('simulink/Math Operations/Gain', [modelName '/Gy3'], ...
    'Gain', '2', 'Position', [x0+300 y0+dy+80 x0+340 y0+dy+120]);

add_block('simulink/Math Operations/Sum', [modelName '/Sum_y'], ...
    'Inputs', '+++', ...
    'Position', [x0+700 y0+dy+80 x0+740 y0+dy+120]);

%% Scope for output
add_block('simulink/Sinks/Scope', [modelName '/Scope'], ...
    'Position', [x0+800 y0+dy+70 x0+840 y0+dy+130]);

%% Connect the lines

% Step to Sum_x3 (u(k))
add_line(modelName, 'Step/1', 'Sum_x3/1');

% Sum_x3 output to Delay_x3 input
add_line(modelName, 'Sum_x3/1', 'z^-1_x3/1');

% Delays chain: x3 -> x2 -> x1
add_line(modelName, 'z^-1_x3/1', 'z^-1_x2/1');
add_line(modelName, 'z^-1_x2/1', 'z^-1_x1/1');

% Tap x3, x2, x1 outputs for gains
add_line(modelName, 'z^-1_x3/1', 'Gm7/1', 'autorouting','on');
add_line(modelName, 'z^-1_x2/1', 'G24/1', 'autorouting','on');
add_line(modelName, 'z^-1_x1/1', 'G180/1', 'autorouting','on');

% Gains (for x3 equation) into Sum_x3
add_line(modelName, 'Gm7/1', 'Sum_x3/2', 'autorouting','on');
add_line(modelName, 'G24/1', 'Sum_x3/3', 'autorouting','on');
add_line(modelName, 'G180/1', 'Sum_x3/4', 'autorouting','on');

% Output equation gains: from states to Gy1,Gy2,Gy3
add_line(modelName, 'z^-1_x1/1', 'Gy1/1', 'autorouting','on');
add_line(modelName, 'z^-1_x2/1', 'Gy2/1', 'autorouting','on');
add_line(modelName, 'z^-1_x3/1', 'Gy3/1', 'autorouting','on');

% Gains to Sum_y
add_line(modelName, 'Gy1/1', 'Sum_y/1', 'autorouting','on');
add_line(modelName, 'Gy2/1', 'Sum_y/2', 'autorouting','on');
add_line(modelName, 'Gy3/1', 'Sum_y/3', 'autorouting','on');

% Sum_y to Scope
add_line(modelName, 'Sum_y/1', 'Scope/1');

%% Set simulation parameters
set_param(modelName, 'Solver', 'FixedStepDiscrete', ...
    'FixedStep', num2str(Ts), ...
    'StopTime', '50');

save_system(modelName);

disp('Simulink model created. You can now press "Run" in the Simulink window.');
