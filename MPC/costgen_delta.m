function [H,h] = costgen_delta(predmod, weight, dim)
    Qbar = blkdiag(kron(eye(dim.N), weight.Q), weight.P);
    Rbar = kron(eye(dim.N), weight.R);
    
    S = predmod.S;
    T = predmod.T;

    % Create the differencing matrix for delta u
    Delta = kron(eye(dim.N), eye(dim.nu)) - [zeros(dim.nu, dim.N * dim.nu); kron(eye(dim.N - 1), eye(dim.nu)), zeros((dim.N - 1) * dim.nu, dim.nu)];
    
    % Adjust the cost function to penalize delta u
    H = S' * Qbar * S + Delta' * Rbar * Delta;
    hx0 = S' * Qbar * T;
    hxref = -S' * Qbar * kron(ones(dim.N + 1, 1), eye(dim.nx));
    huref = -Delta' * Rbar * kron(ones(dim.N, 1), eye(dim.nu));
    
    h = [hx0 hxref huref];
end