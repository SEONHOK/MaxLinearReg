function [A_hat]=Iterative_AR_maxlinear_constraint(A_per,x_sample,y,n,p,K,MaxIter,eta, tol)   
         % x_sample -> p x n
         % y -> n x 1
         % A_per -> p x K
         

        options = optimoptions('linprog', 'Display', 'off');
        I=eye(K);
        [Acon, bcon]  =  constraint_AR(x_sample',y,n,p,K,eta);
%         track=[];
        for i=1:MaxIter
            A_prev = A_per;
            [~, idx]=MaxLinear_func(A_per,x_sample);
%             [~, idx]=max(x_sample*x_init,[],2);
%              B=[];
             theta=0;
             for j=1:n
                 theta = theta + 1/n*kron(I(:,idx(j)),x_sample(:,j));
             end
             
             f = [-1/2*theta; zeros(n,1)];
            
% .         For linprog in gurobi           
%             x_tmp=linprog_gurobi(f,Acon,bcon);
            
            x_tmp=linprog(f,Acon,bcon,[], [], [], [], options);
            x_init_vec = x_tmp(1:K*p);
            A_per=reshape(x_init_vec,size(A_per));
            ratio = norm(A_per-A_prev,'fro')/norm(A_prev,'fro');
%             track=[track ratio]
            if ratio < tol
               break; 
            end      
        end
        
        A_hat = A_per;

end




function [A_con,b_con]=constraint_AR(X,y,n,p,K,eta)
        % X -> p x n
         b_con = [kron(ones(K,1),y); zeros(n,1); eta];
         A_tmp1= [kron(eye(K),X); zeros(n,p*K)];
         A_tmp2= kron(ones(K+1,1),-eye(n));
         A_tmp3= [zeros(1,p*K) 1/n*ones(1,n)];
         A_con=[A_tmp1 A_tmp2; A_tmp3];

%          A_con = [A_tmp1 A_tmp2 A_tmp3];
%          b_con = [zeros(n,1); kron(ones(K,1),y); zeros(n*K,1)];
         
end