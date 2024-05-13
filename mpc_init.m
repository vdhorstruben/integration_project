% TO DO:
% 1. init all ss models
% 2. Convert C2D
% 3. Omschrijven cost function
% 4.

%% Initiliaze systems and get dimensions
sys_pos = ss(est_sys_pos.A, est_sys_pos.B, est_sys_pos.C, est_sys_pos.D);
sys_neg = ss(est_sys_neg.A, est_sys_neg.B, est_sys_neg.C, est_sys_neg.D);




% sys_neg_d = c2d(ss(est_sys_neg));

dim.nx = size(sys_pos.A, 1); % number of states
dim.ny = size(sys_pos.C, 1); % number of outputs
dim.nu = size(sys_pos.D, 1); % number of inputs
dim.N = 1/h_s

