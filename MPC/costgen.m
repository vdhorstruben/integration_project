function [H,h]=costgen(predmod,weight,dim)
    Qbar = blkdiag(kron(eye(dim.N), weight.Q), weight.P);
    Rbar = kron(eye(dim.N), weight.R);
    
    S = predmod.S;
    T = predmod.T;


    H= S'*Qbar*S + Rbar;   
    hx0= S'*Qbar*T;
    hxref=-S'*Qbar*kron(ones(dim.N+1,1),eye(dim.nx));
    huref=-Rbar*kron(ones(dim.N,1),eye(dim.nu));
    h=[hx0 hxref huref]; 

end