% TO DO:
% 1. init all ss models
% 2. Convert C2D
% 3. Omschrijven cost function
% 4.

%% Initiliaze systems and get dimensions
sys = ss(est_sys_pos.A, est_sys_pos.B, est_sys_pos.C, est_sys_pos.D);
sysd = c2d(sys, h);

% sys_neg_d = c2d(ss(est_sys_neg));

dim.nx = size(sysd.A, 1); % number of states
dim.ny = size(sysd.C, 1); % number of outputs
dim.nu = size(sysd.D, 1); % number of inputs
dim.N = 0.1/h;

[P, S]=predmodgen(sysd,dim); %Generation of prediction model


Q = [0.9 0; 0 0.3];                     %Weight matrix on frequency and ROCOF 
R = 0;                                  %Weight matrix on control input
[Q_final,K,L] = idare(sysd.A,sysd.B,Q,R,[],[]); %Determining terminal cost


x0 = [0; 0];

[H,h,const]=costgen(P,S,Q,R,dim,x0)
