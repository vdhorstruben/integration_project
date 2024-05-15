function u = opt(P, S, Q, R, dim, x,Q_final,old,h_s)
    [H,h,const]=costgen(P,S,Q,R,dim,x);  
    cvx_begin quiet
        variable u(dim.N)
        %Objective function
        Objective = 0.5*u'*H*u+h'*u;
        minimize(Objective)    
        %Constraints
        subject to 
            norm(u,inf) <= 0.15;
            norm(u(1)-old,2) <= 0.5*h_s;              %max rate of u
%             norm(u(1:5) - u(2:6),inf) <= 0.5*h_s;   %deze verneukt het
%             maar die andere doet goed en blijft binnen de bounds.
            
    cvx_end
    
end