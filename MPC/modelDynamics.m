function [A, B, C, D] = modelDynamics(Mm, Mt, Mcw, L1, L2, C_alpha, Ts)

J = (Mt+Mm)*L2^2 + Mcw*L1^2;
g = 9.81;

A = [0, 1; -(1/J)*g*Mcw*L1*cos(-0.38), -(1/J)*C_alpha];
B= [0; (1/J)*L2];
C = [1, 0];
D = 0;
end
