function [newpop] =mutation(pop,pm,xmax,xmin)
%% 变异操作
% pop： 变异前的种群
% pm：  变异概率
%xmax： 搜索范围的上限
%xmin： 搜索范围的下限


% 预分配存储空间
[row,col]=size(pop);

% 直接复制得到新种群
newpop = pop;

% 执行变异
for i=1:row
    if rand<=pm
        mutePoint =ceil(rand*col); %产生一个突变点
        if rand<0.5
        newpop(i,mutePoint)= xmin+(xmax-xmin)*rand;%均匀变异
        else
        newpop(i,mutePoint)=  newpop(i,mutePoint)+1.0*randn;%高斯变异
        end
    else
        continue;
    end
    
end
end