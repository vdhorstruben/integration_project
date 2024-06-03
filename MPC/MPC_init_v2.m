close all; clear all;
%% Setup
est_sys_pos = open("chirp_74_right_rotor.mat");
est_sys_pos = est_sys_pos.est_sys_pos;

h = 0.01; %sampling time 
sys = ss(est_sys_pos.A, est_sys_pos.B, est_sys_pos.C, est_sys_pos.D);
sysd = c2d(sys, h);

A = sysd.A;
B = sysd.B;
C = sysd.C;

Tsim = 60; % Simulation time
T_steps = Tsim / h; %amount of time steps

%% Q and R
Q = [30,0;0,1];
R = 0.1;
[P,K,L] = idare(A,B,Q,R);
K_i = 5

%% Construct LTI sys & dimensions

%Define the LTI system
LTI.A=A;
LTI.B=B;
LTI.C=C;
LTI.x0=[0 0]'; % to be defined

%Define the dimension of the system and horizon
dim.N=20;
dim.nx=size(LTI.A,1);
dim.ny=size(LTI.C,1);
dim.nu=size(LTI.B,2);

%Define the weights for the LQR problem
weight.R=R;
weight.Q=Q;
weight.P=P;  

%% Rewrite objective to depend on u_N, for minimizing
predmod=predmodgen(LTI,dim); %gives T and S         
[H,h_cost]=costgen(predmod,weight,dim); % V = 0.5*u'*H*u+(h*x_0)'*u


%% y_ref
y_ref = -0.2;


% y_ref = -[0.2*ones(1,T_steps/4), 0.3*ones(1,T_steps/4), 0.1*ones(1,T_steps/4), 0.38*ones(1,T_steps/4),];
