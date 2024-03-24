function [A_per, iter]=AMalgorithm_LAD(x_sample,y,K,A_per,max_iter)
    % y -> n x 1
    % x_sample -> n x p
    for iter=1:max_iter
        prior_beta_hat_matrix=A_per;
        [~,dt]=MaxLinear_func(A_per,x_sample);     
        for j=1:K
            A=x_sample(:,(dt==j))'; % indexing
            y_tmp=y(dt==j);
            
            A_per(:,j) = LAD_lp(A,y_tmp);
            
%             A_per(:,j)=x_hat;
        end
        
        
         if (norm(prior_beta_hat_matrix-A_per,'fro')/norm(prior_beta_hat_matrix,'fro'))<10^(-8)
            break; 
         end      
    end    
end


function y_opt = LAD_lp(A,y_tmp)

    [m, d] = size(A); 
    
    % Objective coefficients
    f = [zeros(d, 1); 1/m*ones(m, 1)]; % [y; t]

    % Constraint matrices
    %   eye(m)
    
    A_con = [ A  -eye(m); -A  -eye(m)];
    B_con = [y_tmp; -y_tmp];

    %    Solve using linprog
    options = optimoptions('linprog', 'Display', 'off');
    z_opt = linprog(f, A_con, B_con, [], [], [], [], options);
    %     z_opt = linprog(f, A_con, B_con,'Display', 'off');
    y_opt = z_opt(1:d); % Extract y values from [y; t]


end


