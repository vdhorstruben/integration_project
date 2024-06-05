%%
clear all; close all;
%%
est_sys_pos = open("chirp_74_right_rotor.mat");
est_sys_pos = est_sys_pos.est_sys_pos;

h = 0.01; %sampling time 
sys = ss(est_sys_pos.A, est_sys_pos.B, est_sys_pos.C, est_sys_pos.D);
sysd = c2d(sys, h);

A = sysd.A;
B = sysd.B;
C = sysd.C;


Tsim = 60;
%% LQR
[Kd, S, e] = dlqr(sysd.A, sysd.B, [50, 0; 0, 1], 0.1, [0; 0]);

%% LQI
[Kd_i, S_i, e_i] = lqi(sysd, [50, 0, 0; 0, 1, 0; 0, 0, 30], 0.1, [0; 0; 0]);
%%
results = DATA.Data;