clear all
clc

n=100;
K=3;
fname = ['res_' 'n' num2str(n) 'K' num2str(K) 'maxlinear' 'zero' '.mat']; 

load(fname); %or res_SNR20


algs=param.algs;
figure(1)

 for idx_alg = 1:numel(param.algs)
     
      subplot(1,numel(param.algs),idx_alg); 
      plotmtx = log10(median(res{idx_alg}.error_2norm,3));
    
     
     imagesc((flipud(plotmtx)),[-2.5 0]);
     hold on
     axis image; 
%      colormap(gray(255));  
     colormap('jet'); 
 
    set(gca,'Xtick',1+(0:1:size(plotmtx,2)),'XTickLabel',{'0','','','','','','','','','','0.1','','','','','','','','','','0.2','','','','','','','','','','0.3','','','','','','','','','','0.4'},'fontsize',24,'fontname','Times New Roman');
    set(gca,'Ytick',0.5+(0:size(plotmtx,1)/14:size(plotmtx,1)),'YTickLabels',fliplr({'100','','300','','500','','700','','900','','1100','','1300','','1500'
    }),'fontsize',24,'fontname', 'Times New Roman');  %,'750','800','850','900','950','1000'
    colorbar
 
 
     colorbar
 
     ylabel('$n$','interpreter','LaTeX');
     xlabel('$p_{fail}$','interpreter','LaTeX');
     xtickangle(0);
     
      title(algs{idx_alg}); 
  
 end


 
