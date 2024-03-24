function [initial_A]=repeated_randomAM_v2(y,x_sample,p,K,M,itr)
    ERM_list=zeros(1,M);
    initial_list={};
    for i=1:M        
         rng_seed_X = mod((K+p)*M,2^32);
         rng(rng_seed_X);  
             % generate ground_truth
         tmpmat=randn(p,K);
         A_init=tmpmat;
         A_per=AMalgorithm_linear(x_sample,y',K,A_init,itr);
%        beta_hat_AM1=AMalgorithm_linear(x_sample,y_1,ns,A_init,itr); %initialization -> A_per 
        initial_list{i}=A_per;
        [y_hat ~]=MaxLinear_func(A_per,x_sample);
        ERM_list(i)=norm(y-y_hat);
    end
        [~,index]=min(ERM_list);
        initial_A=initial_list{index};
end