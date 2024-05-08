clear; clc; close all;

run hwinit.m;

% load simout_sine_0.5.mat
%% Define initial model
params = {'Mm', 0.5; 'Mt', 0.5; 'Mcw', 0.8; 'L1', 0.33; 'L2', 0.3; 'C_alpha', 0.8};

sys = idgrey('modelDynamics',params,'c');

%% Create data:

% Sampling Time
h = 0.01;
% Simulation dureation
Tsim = 40;
% Time vector
t = [0:h:Tsim]';

% Create input signal
% amplitude = 0.3;
% omega_start = 0.4;
% omega_end = 0.1;
% 
% u = amplitude * sin(omega_start*t);

% amplitude = 0.25;
% omega_start = 0.05;
% omega_end = 0.1;
% u = amplitude* chirp(t, omega_start, Tsim, omega_end, 'linear');

u = [ones(1, 500)*0.1, ones(1, 500)*0.2, ones(1, 500)*0.3,ones(1, 500)*0.15, ones(1, 500)*0, ones(1, 500)*-0.1, ones(1, 500)*-0.1,ones(1, 501)*-0.05]';


amplitude = 0.2;
omega_start = 0.05;
omega_end = 0.1;
u_test = amplitude* chirp(t, omega_start, Tsim, omega_end, 'linear');

plot(t, u);

%%
simin= [t, u];
% simin2 = [t, zeros(size(t, 1))];
sim  helicoptertemplate

%% Gather data from output

y = simout.signals.values(:, 1);
u_measured = simout.signals.values(:,2)*(1/350);

% alpha = y(:, 1);
% omega_1 = y(:, 2);
% beta = y(:, 3);
% omega_2 = y(:, 4);

%% Create data object

data = iddata(y, u, h, 'Name', 'Heli-2d');
data.InputName = 'Percentage';
data.InputUnit = 'P';
data.OutputName = {'alpha'};
data.OutputUnit = {'rad'};
data.Tstart = 0;
data.TimeUnit = 's';

%% Grey box identification

est_sys = pem(data, sys);
%%
% y_sim = lsim(est_sys, u, t);
% figure;
% hold on;
% plot(t, y_sim);
% plot(t, y);
% legend('Simulated', 'Measured')
% hold off;

%%
figure;
opt = compareOptions('InitialCondition', 'zero');
compare(data, est_sys, sys)

pause

%%

simin= [t, u_test];
% simin2 = [t, zeros(size(t, 1))];
sim  helicoptertemplate

y_test = simout.signals.values(:, 1);
u_test_measured = simout.signals.values(:,2)*(1/350);


data = iddata(y_test, u_test, h, 'Name', 'Heli-2d');
data.InputName = 'Percentage';
data.InputUnit = 'P';
data.OutputName = {'alpha'};
data.OutputUnit = {'rad'};
data.Tstart = 0;
data.TimeUnit = 's';

compare(data, est_sys)


% y_test_sim = lsim(est_sys, u_test, t);
% figure;
% hold on;
% plot(t, y_test_sim);
% plot(t, y_test);
% legend('Simulated', 'Measured')
% hold off;




