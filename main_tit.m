clear all;
clc;



% Only consider 'n'


% dimenstion "p"
p=30;
% number of segments "K"
K=6;
param.p = p;
param.K = K;
n_list = 500:500:3500;  
max_iter = 500;
M = 200; % initialization parameter
sigma=0.01; % sigma: the noise deviation. 
wellbalance = 1;
tol=10^(-5);
numFolds=5;

noisy_list={'gaussian','outlier'};
cases_list={'normal','cross'};
%% setup for Monte Carlo simulation 

% noisy=noisy_list{2};
% cases=cases_list{1};

noisy=noisy_list{1};
cases=cases_list{2};

switch cases
    
    case 'cross'
    algs = { 'cross_val'};
    
    otherwise
        
    algs = {'am','am_lad','ar','iar'};
        
end


param.cases=cases;
param.noisy=noisy;
param.numFolds=numFolds;
param.M = M;
param.wellbalance = wellbalance;
param.n_list = n_list;
param.sigma = sigma;
param.algs = algs;
param.maxiter=max_iter;
param.tol=tol;
size_n_list = numel(n_list);


flag_parallel = 0; % set flag_parallel
total_instance = 2; % 

if flag_parallel == 1
    c = parcluster('local');
    p_for = c.parpool(55); % 8 for macbook air 
end

% run monte carlo 
for idx_instance =1:total_instance

        insfname = ['./Results/res_ins' num2str(idx_instance) 'sigma' num2str(sigma) cases noisy '.mat'];
       
    
    if exist(insfname,'file')
        
        disp([insfname ' already done']);
        continue;
        
    else

        TSTART = tic;
        
        if flag_parallel == 1
            

                                              
                          parfor idx_param = 1:size_n_list               
                                test_instance_tit(idx_instance,idx_param,param)
                          end
                    

            
        else
                       
                          for idx_param = 1:size_n_list               
                                test_instance_tit(idx_instance,idx_param,param)
                          end
                    
                  
            
        end
            
        ins_t = toc(TSTART);
        
        switch cases
            
            case 'cross'
                
                ins_res = {};
                
            otherwise
        
                ins_res = cell(numel(param.algs)+1,1);   % init
        end
        
                
            
                
                
                
                   for idx_param = 1:size_n_list
                        idx_n = mod(idx_param-1,size_n_list)+1;
                        n = param.n_list(idx_n);
                     
                        tmpfname = ['./Results/tmp' 'n' num2str(n) 'K' num2str(K) 'p' num2str(p) 'sigma' num2str(sigma) cases noisy '.mat'];     
                        
                        
                        load(tmpfname,'tmpres');
                        
                        switch cases
                            
                            case 'cross'
                                
                                ins_res.validerr = tmpres.validerr;
                                ins_res.esterr = tmpres.esterr;
                                ins_res.etalist = tmpres.etalist;
                                delete(tmpfname); 
         
                            otherwise
                                ins_res{numel(param.algs)+1}.error_init(idx_n) = tmpres.error_init;
                                for idx_alg = 1:numel(param.algs)
                                    ins_res{idx_alg}.error_2norm(idx_n) = tmpres.error_2norm(idx_alg);
                                    ins_res{idx_alg}.error_runtime(idx_n) = tmpres.runtime(idx_alg);
                                end
                                delete(tmpfname); 
                        end
                   end
                
                
                                    
        save(insfname,'ins_t','ins_res'); 

    end
    
end

if flag_parallel == 1
    delete(gcp('nocreate'))
end


% combine all instance results 

 switch cases
            
            case 'cross'
                
                res = {};
                
            otherwise
        
                res = cell(numel(param.algs)+1,1); 
        end
        

arr_runtime = NaN*ones(total_instance,1); 

for idx_instance = 1:total_instance
    
    
    insfname =  ['./Results/res_ins' num2str(idx_instance) 'sigma' num2str(sigma) cases noisy '.mat'];
    
    
    switch cases
 
        case 'cross'
            
        if exist(insfname,'file')
            load(insfname,'ins_t','ins_res'); 
            for idx_alg = 1:numel(param.algs)
                res.validerr{idx_instance} = ins_res.validerr;
                res.esterr{idx_instance} = ins_res.esterr;
                res.etalist{idx_instance} = ins_res.etalist;
            end
            arr_runtime(idx_instance) = ins_t;
        else
            for idx_alg = 1:numel(param.algs)
                res.validerr{idx_instance} = {};
                res.esterr{idx_instance} = {};
                res.etalist{idx_instance} = {};
            end
            arr_runtime(idx_instance:end) = [];
            break;
        end
        
        otherwise
            
            
        if exist(insfname,'file')
            load(insfname,'ins_t','ins_res'); 
            res{numel(param.algs)+1}.error_init(idx_instance,:)=ins_res{numel(param.algs)+1}.error_init;
            for idx_alg = 1:numel(param.algs)
                res{idx_alg}.error_2norm(idx_instance,:) = ins_res{idx_alg}.error_2norm;
                res{idx_alg}.error_runtime(idx_instance,:) = ins_res{idx_alg}.error_runtime;
            end
            arr_runtime(idx_instance) = ins_t;
        else
            for idx_alg = 1:numel(param.algs)
                res{idx_alg}.error_2norm(idx_instance:end,:) = [];
                res{idx_alg}.error_runtime(idx_instance:end,:) = [];
            end
            arr_runtime(idx_instance:end) = [];
            break;
        end
            
            
    end
    
%     delete(insfname); 
end
fname = ['./Results/res_' 'sigma' num2str(sigma) cases noisy '.mat']; 

save(fname,'res','arr_runtime','param');

log10(median(res{1}.error_2norm,3))
log10(median(res{2}.error_2norm,3))
log10(median(res{3}.error_2norm,3))