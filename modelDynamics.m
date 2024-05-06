function [A, B, C, D] = modelDynamics(Mm, Mt, Mcw, L1, L2, Ts)

J = (Mt+Mm)*L2^2 + Mcw*L1^2;
g = 9.81;

A = [0, 1; (1/J)*g*(Mm*L2^2 -Mt*L1^2), 0];
B= [0; 1/J];
C = [1, 0];
D = 0;
end
