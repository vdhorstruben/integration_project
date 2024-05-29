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

Tsim = 16; % Simulation time
T_steps = Tsim / h; %amount of time steps

%% Q and R
Q = [100,0;0,1];
R = 1;
[P,K,L] = idare(A,B,Q,R);

LTI.A=A;
LTI.B=B;
LTI.C=C;
LTI.x0=[0 0]'; % to be defined\
LTI.Bd=[1; 0];
LTI.Cd=[1];
LTI.d = 0;

LTI.yref = -0.1;

weight.R=R;
weight.Q=Q;
weight.P=P;  

dim.N=20;
dim.nx=size(LTI.A,1);
dim.ny=size(LTI.C,1);
dim.nu=size(LTI.B,2);
dim.nd=size(LTI.Cd, 1);

%%
rank([eye(2)-LTI.A -LTI.Bd; LTI.C, LTI.Cd])

%%

LTIe.A = [LTI.A LTI.Bd; zeros(dim.nd, dim.nx) eye(dim.nd)];
LTIe.B=[LTI.B; zeros(dim.nd,dim.nu)];
LTIe.C=[LTI.C LTI.Cd];
LTIe.x0=[LTI.x0; LTI.d];
LTIe.yref=LTI.yref;

%Definition of system dimension
dime.nx=3;     %state dimension
dime.nu=1;     %input dimension
dime.ny=1;     %output dimension
dime.N=10;      %horizon

%Definition of quadratic cost function
weighte.Q=blkdiag(weight.Q,zeros(dim.nd));            %weight on output
weighte.R=weight.R;                                   %weight on input
weighte.P=blkdiag(weight.P,zeros(dim.nd));            %terminal cost

%% Rewrite objective to depend on u_N, for minimizing
predmode=predmodgen(LTIe,dime); %gives T and S         
[He,h_coste]=costgen_delta(predmode,weighte,dime); % V = 0.5*u'*H*u+(h*x_0)'*u

%% y_ref
y_ref = -0.1;


% y_ref = -[0.2*ones(1,T_steps/4), 0.3*ones(1,T_steps/4), 0.1*ones(1,T_steps/4), 0.38*ones(1,T_steps/4),];
