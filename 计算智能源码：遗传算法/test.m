% 作者：tsingke
% 功能：遗传算法函数优化测试

clc;
clear;
close all;
%----------------测试参数-----------------------
popsize=40;
dimension=3;
xmax=10;
xmin=-10;
vmax=100;
vmin=-100;
maxiter=1000;
funcid=12;
%----------------运行算法-----------------------
tic;
[gbestx,gbestfitness,gbesthistory]= PSO(popsize,dimension,xmax,xmin,vmax,vmin,maxiter,funcid);
hold off;

%----------------绘制曲线-----------------------

% 绘制GA算法收敛曲线
semilogy(gbesthistory,'g-');
title('PSO convergence');
xlabel('iteration');    
ylabel('fitness value');
box on;
saveas(gcf,'PSO_curve','png');
toc;