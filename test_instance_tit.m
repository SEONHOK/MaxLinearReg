function test_instance_tit(idx_instance,idx_param,param)


verbose = 1;
wellbalance=param.wellbalance;
size_n_list = numel(param.n_list);
idx_n = mod(idx_param-1,size_n_list)+1;
n = param.n_list(idx_n);
max_iter = param.maxiter;
n_max = max(param.n_list);
M = param.M;
K = param.K;
p = param.p;
tol = param.tol;
numFolds = param.numFolds;
cases = param.cases;
noisy = param.noisy;
  


index_set=perms(1:K);
% p = param.p_list(idx_p);

% p_max = max(param.p_list);
sigma = param.sigma;

fname = ['./Results/tmp' 'n' num2str(n) 'K' num2str(K) 'p' num2str(p) 'sigma' num2str(sigma) cases noisy '.mat'];



if exist(fname,'file')
    disp([fname ' already done']); 
    return;
    
else

    % generate groundtruth X

     rng_seed_X = mod(idx_instance*(K+p),2^32);
     rng(rng_seed_X);  

             % generate ground_truth
     tmpmat=randn(p,K);
     if wellbalance == 1
                 [U, ~, V]=svd(tmpmat(1:p,1:K));
                 Theta=U(:,1:K)*eye(K)*V';
     % size of A -> p x K
                 A=Theta;
     else
                A=zeros(p,K);
                for j=1:K
                    A(:,j)= tmpmat(:,j)/norm(tmpmat(:,j));
                end
     end
            
            
        
    
    
   
    clear tmpmat;

    % generate measurement model
    rng_seed_A = mod(idx_instance,2^32);
    rng(rng_seed_A);
    
    tmpmat = randn(p,n_max);
    x_sample = tmpmat(:,1:n); 
        
       
    clear tmpmat;

    % generate noisy measurements
    rng_seed_noise = mod(idx_instance,2^32);
    rng(rng_seed_noise);

    tmpmat = randn(1,n_max);
    [y, ~]= MaxLinear_func(A,x_sample);
    switch noisy
        
        case 'outlier'
            subindices= randperm(n,round(n*sigma));
            y_tmp=y;
            y(subindices)=-y_tmp(subindices);
            noise=y-y_tmp;
        otherwise
            
             tmpmat = randn(1,n_max);
             noise= sigma*tmpmat(1,1:n);
             y = y + noise;
         
    end    

    eta=1/n*sum(1/2*(abs(-noise)+(-noise)));
%     eta=eta;
    
    clear tmpmat;

    tmpres = [];

    %initialization
    A_per=repeated_randomAM_v2(y,x_sample,p,K,M,10);
    
    
     sum_tmp=zeros(1,size(index_set,1));          
     for kk=1:size(index_set,1)
                   sum_tmp(kk)=norm(A_per(:,index_set(kk,:))-A,'fro')^2;
     end
     tmpres.error_init = min(sum_tmp)/norm(A,'fro')^2;


   
    
    
    for idx_alg = 1:numel(param.algs)
        alg = param.algs{idx_alg};

        tic

        switch alg

           case 'am'

                % estimate 
                [est_beta, ~]=AMalgorithm_linear(x_sample,y',K,A_per,max_iter);            

            case 'am_lad'
                
                [est_beta, ~]=AMalgorithm_LAD(x_sample,y',K,A_per,max_iter);
               
           case 'ar'

                est_beta = Iterative_AR_maxlinear_constraint(A_per,x_sample,y',n,p,K,1,eta,tol);
                
            
           case 'iar'

                est_beta = Iterative_AR_maxlinear_constraint(A_per,x_sample,y',n,p,K,50,eta,tol);
                
           case 'cross_val'
                
                 [validation_err, estimation_err, range_eta]=cross_val_ar(A_per,x_sample,y',n,p,K,eta,tol,numFolds,A,index_set);
                

            otherwise
                error([alg ' is not supported']);

        end

        t = toc;

        
       switch cases
           
           case 'cross'
               
               tmpres.validerr=validation_err;
               
               tmpres.esterr=estimation_err;
               
               tmpres.etalist=range_eta;
               
               
           otherwise
               % error estimation    
               sum_tmp=zeros(1,size(index_set,1));          
               for kk=1:size(index_set,1)
                   sum_tmp(kk)=norm(est_beta(:,index_set(kk,:))-A,'fro')^2;
               end
               tmpres.error_2norm(idx_alg) = min(sum_tmp)/norm(A,'fro')^2;



               log10(tmpres.error_2norm(idx_alg))
               % runtime
               tmpres.runtime(idx_alg) = t;
               
       end
        
       
    end
       % save temporary file
    save(fname,'tmpres');
        
    if verbose == 1
            disp([fname ' instance' num2str(idx_instance) ' finished in ' num2str(t) ' sec']);
    end

    
end

end