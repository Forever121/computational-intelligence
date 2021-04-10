function [gbestx,gbestfitness,gbesthistory]=CI_GA(popsize,dimension,xmax,xmin,maxiter,FuncId)
%% GA算法: 遗传算法（实数优化版本）
%------------------------------------
%       算法参数信息说明
%------------------------------------
% popsize   ： 种群大小
% dimension ： 搜索维度，或染色体的长度
% xmax，xmin： 位置范围
% maxiter   ： 循环迭代次数
% pc：交叉概率
% pm: 变异概率

% 测试函数
Fitness = @benchmark_func;


%% 准备工作
workpath = pwd;

% 1.预分配存储空间
pop=rand(popsize,dimension);   %上一代种群
newpop=rand(popsize,dimension);%下一代种群

% 2.个体适应度
fitness=rand(1,popsize);   %上一代种群适应度
newfitness=rand(1,popsize);%下一代种群适应度

% 3.全局最优信息
gbestfitness= inf; %全局最佳适应度初始化为最大（针对最小优化问题）
gbestx = rand(1,dimension);%全局最优位置向量
gbesthistory = rand(1,maxiter);%记录各迭代最佳数值

% 4.算法基本参数
pc = 0.8;  %交叉概率
pm = 0.2; %变异概率

% 5.绘制当前函数测试图形
if dimension<4  
    drawFunction(FuncId);
     hold on;
end

% -------------------------------------------------------------------------

%% 第一步： 种群初始化
for i = 1:popsize
    %初始化个体的位置和适应度
    pop(i,:)= xmin+(xmax-xmin)*rand(1,dimension);
    fitness(i)=Fitness(pop(i,:),FuncId);  
    %更新全局最优
    if fitness(i)<gbestfitness
        gbestfitness = fitness(i);
        gbestx(:)=pop(i,:);
    end
end


%显示初始种群分布
if dimension ==2
    h=plot(pop(:,1),pop(:,2),'ro');
elseif dimension ==3
    h=plot3(pop(:,1),pop(:,2),fitness','ro','MarkerSize',8,'MarkerFaceColor','r');
end


%% 第二步：循环迭代
for iter =1:maxiter
    %----------------------【1】遗传操作----------------------------------
    %1. 选择操作：计算个体的选择概率，并选出popsize个个体
    [newpop] =selection(pop,fitness);
    
    %2. 将新的种群按照概率pc执行交叉操作
    [newpop]= crossover(newpop,pc);
    
    %3. 将新的种群按照概率pm执行变异操作
    [newpop]= mutation(newpop,pm,xmax,xmin);
    
    %----------------------【2】适应度计算----------------------------------
    %4. 计算新种群所有个体的适应度
    for i=1:popsize
        newfitness(i)= Fitness(newpop(i,:),FuncId);
         %更新种群最优路径信息
         if  newfitness(i)<gbestfitness
             gbestfitness = newfitness(i);
             gbestx(:) = newpop(i,:);
         end
    end

        % 显示初始种群分布
    %drawFunction(FuncId);
   
    if dimension ==2
        set(h,'XData',newpop(:,1),'YData',newpop(:,1),'ZData',newfitness');
        drawnow;
         grid on;
         box on;
    elseif dimension ==3
        set(h,'XData',newpop(:,1),'YData',newpop(:,1),'ZData',newfitness');
        drawnow;
        grid on;
        box on;
        pause(0.002);
    end
    %----------------------【3】种群筛选----------------------------------
    %5. 种群合并,排序，优中选优
    mergepop=[pop;newpop];
    fit=[fitness,newfitness];
    [topfit,topindex]=sort(fit);%从小到大排列
    
    %新种群信息调整(淘汰后面个体)
    pop(1:popsize,:)=mergepop(topindex(1:popsize),:);
    fitness=topfit(1:popsize);
    
    %----------------------【4】输出最优----------------------------------
     %6.更新种群最优信息
    gbesthistory(iter)= gbestfitness;
    fprintf("GA算法迭代到第%d代，最佳适应度 = %e\n",iter,gbestfitness);

    %7.绘制当前种群的分布

end % end iter
%%
disp('-------------------------------');
disp('全局最优解向量为：  ');
for i = 1:dimension
    fprintf("x[%d] = %f\n",i,gbestx(i));
end
disp('-------------------------------');



end %end funtcion
%%



