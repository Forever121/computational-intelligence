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
maxiter=1000;
funcid=16;
%----------------运行算法-----------------------
tic;
[gbestx,gbestfitness,gbesthistory]= CI_GA(popsize,dimension,xmax,xmin,maxiter,funcid);
hold off;

%----------------绘制曲线-----------------------

% 绘制GA算法收敛曲线
semilogy(gbesthistory,'g-');
title('GA convergence');
xlabel('iteration');
ylabel('fitness value');
box on;
saveas(gcf,'GA_curve','png');
toc;