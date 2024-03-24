clear all;
clc;

load('res_sigma0.1crossgaussian.mat');
% load('res_sigma0.1crossoutlier.mat');

% algs={'proxlinear','SLP'}
algs=param.algs;
lineWidth=4;
colors = [
    1 0 0;     % Red 
    0 0 1;     % Blue
    0 1 0;     % Green
    1 1 0;
    0 1 1;
];




%    matrixResult=[];
% %    subplot(1,2,1)
% %    plot_vector=(median(res{idx_alg}.error_2norm,1));
   plot(res.etalist{1},res.validerr{1},'-s','Color','blue','DisplayName','Validation Error','LineWidth',3,'MarkerSize',14);
   ylabel('Validation Error','Interpreter', 'latex','FontSize', 24);
   xlabel('$\eta$','Interpreter', 'latex','FontSize', 24);

   ylims = ylim;  % Get the current y-axis limits
line([median(res.etalist{1}) median(res.etalist{1})], ylims, 'Color', 'red', 'LineStyle', '--');  % Add the red line
            set(gca, 'TickLabelInterpreter', 'latex','fontsize',24,'fontname', 'Times New Roman');

             grid on;
            
             xtickangle(0);
               
            
            
            
            
            
%    subplot(1,2,2)
ylim([0, 0.1606]);
ylims = ylim;  % Get the current y-axis limits

   plot(res.etalist{1},res.esterr{1},'-s','Color','red','DisplayName','estimation error','LineWidth',3,'MarkerSize',14)
   ylabel('Normalized Estimation Error','Interpreter', 'latex','FontSize', 24)

% plot initial
%  ylim([ -6 1])
%             xlim([1 15])

% line([median(res.etalist{1}) median(res.etalist{1})], ylims, 'Color', 'red', 'LineStyle', '--');  % Add the red line
et=res.etalist{1};
eta_red=et(2);
line([eta_red,eta_red], ylims, 'Color', 'red', 'LineStyle', '--');  % Add the red line

            set(gca, 'TickLabelInterpreter', 'latex','fontsize',24,'fontname', 'Times New Roman');
%              ylabel('$\log_{10}\left(\mathrm{dist}(\mathbf{x}_k,\mathbf{x}_\star)\right)$', 'Interpreter', 'latex', 'FontSize', 24);
             xlabel('$\eta$','Interpreter', 'latex','FontSize', 24);
            
             grid on;
            
             xtickangle(0);
             
             
%              legend