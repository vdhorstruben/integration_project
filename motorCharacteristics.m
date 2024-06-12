%% Initialize sensors; check for offset:
pitchoffs = [0];
pitchgain = [1];

h = 0.01; % Time step
Tsim = 70; % Simulation duration
t_train = [0:h:Tsim]'; % Time vector

% Initialize the signal vector
u_train = -ones(size(t_train));

% Find the index corresponding to 10 seconds
idx_10s = find(t_train >= 10, 1);

% Ramp function from -1 to +1 starting from 10 seconds
u_train(idx_10s:end) = linspace(-1, 1, length(t_train(idx_10s:end)));

% Plot the signal
figure;
plot(t_train, u_train);
xlabel('Time (s)');
ylabel('Signal');
title('Input Signal');
grid on;


%%
% Prepare input data
simin = [t_train, u_train];
sim helicoptertemplate

%% simout 


y = simout.signals.values(:, 1);
u_measured = simout.signals.values(:,4)*1/355;

figure();
hold on;
plot(t_train,u_train);
plot(t_train, u_measured);
xlabel('Time (s)')
ylabel('Signal');
legend('Input Signal', 'Measured Signal')
grid on;
hold off;


%%
figure();
hold on;
plot(t_train, y);
xlabel('Time (s)')
ylabel('Angle \alpha');
grid on;
hold off;





