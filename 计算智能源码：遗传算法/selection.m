function [newpop] =selection(pop,fitness)
% 选择操作：轮盘赌的方法选择出新的种群个体

[row,~]=size(pop);
newpop = zeros(size(pop));

switch randi(2)
    case 1 %轮盘赌方法
        sumfit  = sum(fitness);
        fitnessRatio=1-fitness ./sumfit;%小转大
        % [fitnessRatio,index] = sort(fitnessRatio,'descend');
        cumfit = cumsum(fitnessRatio);%计算适应度比率的累加和
        r = rand(1,row);
        for i=1:row
            id = find(r(i)<=cumfit,1,'first');
            newpop(i,:)=pop(id,:);%注意个体转换
        end

    case 2 %竞标赛方法
        for i=1:row
            r=randperm(row);
            
            r1=min(r(1:2));
            r2=max(r(1:2));
            
            if fitness(r1) <  fitness(r2)
                newpop(i,:)=pop(r1,:);
            else
                newpop(i,:)=pop(r2,:);
            end
        end 
end % end while
end % end function