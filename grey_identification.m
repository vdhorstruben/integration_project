clear; clc;
%% Define initial model
params = {'Mm', 0.5; 'Mt', 0.5; 'Mcw', 0.8; 'L1', 0.33; 'L2', 0.3};

sys = idgrey('modelDynamics',params,'c');

%% Create data:

% Sampling Time
h = 0.01;
% Simulation dureation
Tsim = 30;
% Time vector
t = [0:h:Tsim]';

% Create input signal
amplitude = 0.3;
omega_start = 0.5;
omega_end = 0.1;
u = amplitude * sin(omega_start*t);

% u = amplitude* chirp(t, omega_start, Tsim, omega_end, 'linear');

plot(t, u);
%%
simin= [t, u];
sim  helicoptertemplate

%% Gather data from output

y = simout.signals.values(:, 1);

% alpha = y(:, 1);
% omega_1 = y(:, 2);
% beta = y(:, 3);
% omega_2 = y(:, 4);

%% Create data object

data = iddata(y, u, h, 'Name', 'Heli-2d');
data.InputName = 'Percentage';
data.InputUnit = 'P';
data.OutputName = {'alpha', };
data.OutputUnit = {'rad', };
data.Tstart = 0;
data.TimeUnit = 's';

%% Grey box identification

est_sys = greyest(data, sys);


%%
y_sim = lsim(est_sys, u, t);

figure;
hold on;
plot(t, y_sim);
plot(t, y);
legend('Simulated', 'Measured')
