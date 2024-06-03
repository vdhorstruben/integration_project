% Clear workspace
clear; clc; close all;

% Initialize hardware

%% Initialize sensors; check for offset:
pitchoffs = [0];
pitchgain = [1];

%% Define initial model parameters
params = {'Mm', 0.5; 'Mt', 0.5; 'Mcw', 0.8; 'L1', 0.33; 'L2', 0.3; 'C_alpha', 0.8};

% Create grey-box model
sys = idgrey('modelDynamics',params,'c');


%%
h = 0.01;
% Simulation duration
Tsim_train = 70;
% Time vector
t_train = [0:h:Tsim_train]';

t_1 = [0:h:Tsim_train-10]';

u_init = -0.6*ones(1, 1000)';

amplitude = 0.1;
omega_start = 0.02;
omega_end = 0.6;
offset = -0.7;

u_train = -[u_init; amplitude * chirp(t_1, omega_start, Tsim_train, omega_end, 'linear') + offset];


Tsim_test = 60;
% Time vector
t_test = [0:h:Tsim_test]';

u_test_1 = 0.5*ones(1, 1000);
u_test_2 = 0.55*ones(1, 1000);
u_test_3 = 0.6*ones(1, 1000);
u_test_4 = 0.5*ones(1, 1000);
u_test_5 = 0.45*ones(1, 1000);
u_test_6 = 0.6*ones(1, 1001);
u_test = -[u_test_1, u_test_2, u_test_3, u_test_4, u_test_5, u_test_6]';

figure;
plot(t_train, u_train);

figure;
plot(t_test, u_test);

%%
Tsim = Tsim_train;
% Prepare input data
simin = [t_train, u_train];
sim helicoptertemplate

%%
y = simout.signals.values(:, 1);
u_measured = simout.signals.values(:,4)*1/365;


figure;
plot(t_train, y)

%% Create data object for positive step input

data_pos = iddata(y, u_train, h, 'Name', 'Heli-2d');
data_pos.InputName = 'Percentage';
data_pos.InputUnit = 'P';
data_pos.OutputName = {'alpha'};
data_pos.OutputUnit = {'rad'};
data_pos.Tstart = 0;
data_pos.TimeUnit = 's';

est_sys_pos = pem(data_pos, sys);

figure;
opt = compareOptions('InitialCondition', 'zero');
compare(data_pos, est_sys_pos)

%%
pause
Tsim = Tsim_test;

% Prepare input data
simin = [t_test, u_test];
sim helicoptertemplate

y_test = simout.signals.values(:, 1);
u_measured = simout.signals.values(:,2)*1/365;

data_test = iddata(y_test, u_test, h, 'Name', 'Heli-2d');
data_test.InputName = 'Percentage';
data_test.InputUnit = 'P';
data_test.OutputName = {'alpha'};
data_test.OutputUnit = {'rad'};
data_test.Tstart = 0;
data_test.TimeUnit = 's';

figure;
opt = compareOptions('InitialCondition', 'zero');
compare(data_test, est_sys_pos)


%% Control action initialization

sys = ss(est_sys_pos.A, est_sys_pos.B, est_sys_pos.C, est_sys_pos.D);
sysd = c2d(sys, h);

%%

[Kd, S, e] = dlqr(sysd.A, sysd.B, [100, 0; 0, 1], 0.1, [0; 0]);

%%

[Kd_i, S_i, e_i] = lqi(sysd, [100, 0, 0; 0, 1, 0; 0, 0, 100], 0.1, [0; 0; 0]);



