function [gbestx,gbestfitness,gbesthistory]=LPSO(popsize,dimension,xmax,xmin,vmax,vmin,maxiter,FuncId)
%% LPSO算法： 局部粒子群优化算法（不含权重）
%% 粒子个体的邻居为其左右位置相邻的个体

% popsize   ： 种群大小
% dimension ： 搜索维度
% xmax，xmin： 位置范围
% vman，vmin： 速度范围
% maxiter：    循环迭代次数
% maxrun ：    重复测试次数

%设置适应度函数
Fitness = @SimpleBenchmark;


% 基本变量空间分配
x=rand(popsize,dimension);%分配存储空间+初始化
v=rand(popsize,dimension);%分配存储空间
fitness=ones(popsize,1).*realmax;  %分配存储空间fitne

% 局部最优空间分配
pbestx = rand(popsize,dimension);
pbestfitness = ones(popsize,1).*realmax;%向量操作

% 全局最优空间分配
gbestx=rand(1,dimension);
gbestfitness = realmax;%单值操作

gbesthistory=rand(maxiter,1); %记录每一代的最佳适应度数值,便于绘制收敛曲线


%% 【第一步】初始化粒子种群

 % 初始化粒子的位置和速度
for i=1:popsize
    x(i,:) = xmin+(xmax-xmin).*rand(1,dimension);
    v(i,:) = vmin+(vmax-vmin).*rand(1,dimension);     
end


%% 【第二步】 循环迭代寻找全局最优

c1=2.05;
c2=2.05;

for iter = 1:maxiter
    
   %% 第一步：更新局部最优和全局最优
    for i=1:popsize
        
        % 1.计算粒子的适应度(向量化操作)
        fitness(i)=Fitness(x(i,:),FuncId);
        
        % 2.更新粒子的局部最优位置
        if fitness(i)<= pbestfitness(i)
            pbestfitness(i)=fitness(i);
            pbestx(i,:) = x(i,:);
        end
        
        % 3. 更新粒子的全局最优位置
        if pbestfitness(i) <= gbestfitness
            gbestfitness = pbestfitness(i);
            gbestx(1,:) = pbestx(i,:);%向量赋值 
        end
    end
    
    
    %% 第二步： 更新位置向量和速度向量
    %w=0.9-0.4*(1.0*iter/maxiter);
        
    for i =1:popsize
        %-------------选择粒子i的最优邻居---------------
        t=i-1;%方便进行取模操作，从0开始编号更容易统一
        leftid = rem(t-1+popsize,popsize)+1;%粒子i的左邻居
        rightid = rem(t+1+popsize,popsize)+1;%粒子i的右邻居
        
        [~,lbestid] = min([pbestfitness(leftid),pbestfitness(rightid)]);
        
        %-------------速度更新-------------------
        % a.更新粒子速度（向量化操作）
        v(i,:)= v(i,:)+c1*rand*(pbestx(i,:)-x(i,:))+c2*rand*(pbestx(lbestid,:) - x(i,:));
        %速度检查
        ov=v(i,:); ov(ov>vmax)=vmax; ov(ov<vmin)=vmin;%或ov = min{ov,vmax},ov=max(ov,vmin);
        v(i,:)= ov;
        
        %-------------位置更新-------------------
        % b.更新粒子位置（向量化操作）
        x(i,:)= v(i,:)+x(i,:);
        % 位置检查
        ox = x(i,:); ox(ox>xmax)=xmax; ox(ox<xmin)=xmin;%或ox = min{ox,xmax},ox=max(ox,xmin);
        x(i,:)= ox;
    end % end for
   
    %% 第三步： 记录本代最佳适应度数值
    gbesthistory(iter)= gbestfitness;
    
      fprintf("函数F%d: LPSO算法,第%d代，最佳适应度 = %e\n",FuncId,iter,gbestfitness);
    
end %结束全部迭代

%disp(gbestx(:)');%输出全局最优解

