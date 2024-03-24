function [initial_beta]=initialization(y,x,ns,M,n,p,true_parameter,index_set)
       [U_hat,D]=PCA_method(y,x,ns,n,p);
%        U_hat2=Specinit_Proposed(x(1:p,:)',y',1)

%       [initial_beta,val1]=randomsearch2(U_hat,x,y,M,ns,p,true_parameter,index_set);
       [initial_beta,val2]=randomsearch3(U_hat,x,y,M,ns,p,true_parameter,index_set);
%         val
        [U,S,~]=svd(true_parameter(1:p,:));
%        min(norm(norm(true_parameter(1:p,:))*U_hat-true_parameter(1:p,:)),norm(-norm(true_parameter(1:p,:))*U_hat-true_parameter(1:p,:)))
%        min(norm(norm(true_parameter(1:p,:))*U_hat2-true_parameter(1:p,:)),norm(-norm(true_parameter(1:p,:))*U_hat2-true_parameter(1:p,:)))

        U_test=U(:,1:ns);
        norm(U_hat*U_hat'-U_test*U_test','fro')^2;
%        norm((eye(size(U_hat*U_hat'))-U_hat*U_hat')*U_test*U_test')
%        norm((U_hat*U_hat')*(eye(size(U_hat*U_hat'))-U_test*U_test'),'fro')^2

end



function [U,D_test]=PCA_method(y,x,ns,n,p)
        %x is one of samples
        %ns is the number of segments
%         [d,n]=size(x);
        x=x(1:p,:);
        tmp=1/n*sum(y.*x,2);
         M=tmp*tmp'+1/n*(x*diag(y)*x'-sum(y).*eye(p)); 
%        M=tmp*tmp'+1/n*(x*diag(y)*x'); 
%         sum1=0;
%         for i=1:n
%            sum1=sum1+y(i)*x(:,i)*x(:,i)'-y(i).*eye(p);
%         end
%         1/n*sum1-1/n*(x*diag(y)*x'-sum(y).*eye(p))
        [V,D]=eig(M);
        
        [~,index]=maxk(diag(D),ns);
        U=V(:,index);
        D_test=D(:,index);
end


function [initial_beta,val]=randomsearch3(U,x,y,M,ns,d,A,index_set)
        %x is one of samples
        %ns is the number of segment
%         v = reshape(num2cell(B,1),[ns M]);
     
        V=U;
        
        val=inf;
        for m=1:M
            rng(m);
            prior_val=val;
            v_candidate=make_prmtr_v2(ns,ns,m*10-1);
            
            if prior_val>val
                candidate=v_candidate;
            end
       
            param_tmp=AMalgorithm_affine(x,y',ns,V*v_candidate,1); %initialization -> A_per 
            val=norm(y-MaxAffine_func(param_tmp,x));
            if prior_val>val
                candidate=param_tmp;
            end
        end
        
        candiate1=zeros(1,size(index_set,1));  
        c_candidate=zeros(1,size(index_set,1));
        for kk=1:size(index_set,1)
                     tmpp=candidate(:,index_set(kk,:));
                     candiate1(kk)=norm(tmpp-A,'fro')^2;
        end
        [val,idx]=min(candiate1);
        initial_beta=candidate(:,index_set(idx,:));
end

function [A]=make_prmtr_v2(d,ns,i)
        %x is one of samples
        rng(100*d+10*ns+i);
        A=rand(d,ns);  %d>ns
        
      
        
end





function [A_per, iter]=AMalgorithm_affine(x_sample,y,K,A_per,max_iter)
    for iter=1:max_iter
        prior_beta_hat_matrix=A_per;
        [~,dt]=MaxLinear_func(A_per,x_sample);     
        for j=1:K
            A=x_sample(:,(dt==j))'; % indexing
            y_tmp=y(dt==j);
            A_per(:,j)= pinv(A)*y_tmp;
        end
        
         if (norm(prior_beta_hat_matrix-A_per,'fro')/norm(prior_beta_hat_matrix,'fro'))<10^(-8)
            break; 
         end
    end
%     a=norm(prior_beta_hat_matrix-A_per,'fro')^2;
end
