% Clear workspace
clear; clc; close all;

% Initialize hardware

%% Initialize sensors; check for offset:
pitchoffs = [0];
pitchgain = [1];

% u_cal = zeros(501, 1);
% % Sampling Time
% h = 0.01;
% % Simulation duration
% Tsim = 5;
% % Time vector
% t = [0:h:Tsim]';
% 
% % Prepare input data
% simin = [t, u_cal];
% sim helicoptertemplate
% 
% % Gather data from output
% y_pos = simout.signals.values(:, 1);
% adinoffs(1)= pitchoffs;
% 
% disp('Offset initialization complete!')

% clear u_cal h Tsim t simin simout tout y y_pos

% Load simulation data
% load simout_sine_0.5.mat

%% Define initial model parameters
params = {'Mm', 0.5; 'Mt', 0.5; 'Mcw', 0.8; 'L1', 0.33; 'L2', 0.3; 'C_alpha', 0.8};

% Create grey-box model
sys = idgrey('modelDynamics',params,'c');

%% Create input signals

% Sampling Time
h = 0.01;
% Simulation duration
Tsim = 40;
% Time vector
t = [0:h:Tsim]';

% Define positive step input
u_pos = 2*[ones(1, 1000)*0, ones(1, 1000)*0.1, ones(1, 1000)*0.2, ones(1, 1001)*0.3]' % , ones(1, 1000)*0.15, ones(1, 1001)*0]';

% Define chirp input parameters
amplitude = 0.3;
omega_start = 0.02;
omega_end = 0.08;
offset = amplitude;

% Generate chirp input signal
u_test_pos = amplitude * -chirp(t, omega_start, Tsim, omega_end, 'linear') + offset;

% Generate negative chirp input signal
u_test_neg = -u_test_pos;
u_neg = -u_pos;

% Plot input signals
figure();
hold on;
plot(t, u_pos);
plot(t, u_test_pos);
legend('Chirp Input', 'Stairs Input');
hold off;


%%

u_cal = linspace(0, 1, numel(t))';

% Prepare input data
simin = [t, u_cal];
sim helicoptertemplate

%%

% Gather data from output
data = simout.signals.values(:,2);

t = 1:numel(data);

% Perform linear regression to obtain the slope and intercept of the linear approximation
coefficients = polyfit(t, data, 1);

% Extract the slope and intercept
slope = coefficients(1);
intercept = coefficients(2);

% Create the linear approximation using the slope and intercept
linear_approximation = slope * t;

% Plot the original data and the linear approximation
figure;
plot(t, data, 'b', t, linear_approximation, 'r');
legend('Original Data', 'Linear Approximation');
xlabel('Time');
ylabel('Measurement');
title('Linear Approximation of Time Series');
%% Simulate positive step input

% Prepare input data
simin = [t, u_pos];
sim helicoptertemplate

%%

% Gather data from output
y_pos = simout.signals.values(:, 1);
u_pos_measured = simout.signals.values(:,2)*slope;

%% Create data object for positive step input

% Create data object for positive step input
data_pos = iddata(y_pos, u_pos, h, 'Name', 'Heli-2d');
data_pos.InputName = 'Percentage';
data_pos.InputUnit = 'P';
data_pos.OutputName = {'alpha'};
data_pos.OutputUnit = {'rad'};
data_pos.Tstart = 0;
data_pos.TimeUnit = 's';

%% Perform PEM identification for positive step input

est_sys_pos = pem(data_pos, sys);

est_sys_pos_grey = greyest(data_pos,sys);
%% Compare simulation results with measured data

figure;
opt = compareOptions('InitialCondition', 'zero');
compare(data_pos, est_sys_pos, est_sys_pos_grey)
pause;

%% Simulate chirp input

simin = [t, u_test_pos];
sim helicoptertemplate
%%

% Gather data from output
y_test_pos = simout.signals.values(:, 1);
u_test_pos_measured = simout.signals.values(:,2)*(1/350);

% Create data object for chirp input
data_test_pos = iddata(y_test_pos, u_test_pos_measured, h, 'Name', 'Heli-2d');
data_test_pos.InputName = 'Percentage';
data_test_pos.InputUnit = 'P';
data_test_pos.OutputName = {'alpha'}; 
data_test_pos.OutputUnit = {'rad'};
data_test_pos.Tstart = 0;
data_test_pos.TimeUnit = 's';

% Compare simulation results with measured data for chirp input
figure;
compare(data_test_pos, est_sys_pos)

pause;

%% Start negative estimation: 
simin = [t, u_neg];
sim helicoptertemplate

% Gather data from output
y_neg = simout.signals.values(:, 1);
u_neg_measured = simout.signals.values(:,2)*(1/350);

%% Create data object for negative step input

% Create data object for negative step input
data_neg = iddata(y_neg, u_neg_measured, h, 'Name', 'Heli-2d');
data_neg.InputName = 'Percentage';
data_neg.InputUnit = 'P';
data_neg.OutputName = {'alpha'};
data_neg.OutputUnit = {'rad'};
data_neg.Tstart = 0;
data_neg.TimeUnit = 's';

%% Perform PEM identification for negative step input

est_sys_neg = pem(data_neg, sys);

figure;
opt = compareOptions('InitialCondition', 'zero');
compare(data_neg, est_sys_neg, sys)

pause

%%
simin = [t, u_test_neg];
sim helicoptertemplate

% Gather data from output
y_test_neg = simout.signals.values(:, 1);
u_test_neg_measured = simout.signals.values(:,2)*(1/350);

% Create data object for negative chirp input
data_test_neg = iddata(y_test_neg, u_test_neg_measured, h, 'Name', 'Heli-2d');
data_test_neg.InputName = 'Percentage';
data_test_neg.InputUnit = 'P';
data_test_neg.OutputName = {'alpha'};
data_test_neg.OutputUnit = {'rad'};
data_test_neg.Tstart = 0;
data_test_neg.TimeUnit = 's';

% Compare simulation results with measured data for negative chirp input
figure;
compare(data_test_neg, est_sys_neg)
