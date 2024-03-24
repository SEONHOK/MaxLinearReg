function [validation_err, estimation_err, range_eta]=cross_val_ar(A_per,x_sample,y,n,p,K,eta,tol,numFolds,A,index_set) 
    %% x_sample -> p x n
    %% y -> n x 1
    %% A, A_per -> p x K

    cvIndices = crossvalind('Kfold', y, numFolds);
    range_eta = linspace(0.5*eta, 1.5*eta, 11);
    validation_err=zeros(length(range_eta),1);
    estimation_err=zeros(length(range_eta),1);
    
    
    
    for j=1:length(range_eta)
        eta_tmp=range_eta(j);
        
        mseList = zeros(numFolds, 1); 
        
        
        est_beta = Iterative_AR_maxlinear_constraint(A_per,x_sample,y,n,p,K,1,eta_tmp,tol);
        %% Estimation Error
        sum_tmp=zeros(1,size(index_set,1));          
        for kk=1:size(index_set,1)
                   sum_tmp(kk)=norm(est_beta(:,index_set(kk,:))-A,'fro')^2;
        end
        estimation_err(j) = min(sum_tmp)/norm(A,'fro')^2;  
        
        
        
%         estList = zeros(numFolds, 1); 
        for i = 1:numFolds
            % Split data into training and validation sets based on fold index
            train_x_sample = x_sample(:,cvIndices ~= i);
            train_y = y(cvIndices ~= i);

            val_x_sample = x_sample(:,cvIndices == i);
            val_y = y(cvIndices == i);

            % Train a model 
            est_beta = Iterative_AR_maxlinear_constraint(A_per,train_x_sample,train_y,length(train_y),p,K,1,eta_tmp,tol);

            % Prediction
            mseList(i)=mean((MaxLinear_func(est_beta,val_x_sample)-val_y').^2);

         
                  
        end
        validation_err(j)=mean(mseList);
%         estimation_err(j)=mean(estList);     
    end


end

