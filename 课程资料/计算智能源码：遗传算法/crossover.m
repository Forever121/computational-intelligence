function [newpop] =crossover(pop,pc)
%% 交叉操作（两点交叉）
[row,col]=size(pop);%行位个体，列为维度
newpop = rand(size(pop));

for i=1:2:row-1
    if rand < pc
        
        %-------------- 第一种方法：选择均匀交叉-----------------------------------
%         flag = randi([0,1],1,col);
%         newpop(i,:)=(1-flag).*pop(i,:)+flag.*pop(i+1,:);
%         newpop(i+1,:)=flag.*pop(i,:)+(1-flag).*pop(i+1,:);
%         
        %-------------- 第二种方法：单点交叉---------------------------------------
        
%         % 1.随机选择一个点
%         c = randi([1,col-1]);
%         % 2.交叉生成两个新个体
%         newpop(i,:)= [pop(i,1:c),pop(i+1,c+1:end)];
%         newpop(i+1,:)= [pop(i+1,1:c),pop(i,c+1:end)];
%         
%         
        %---------------第三种方法：两点交叉----------------------------------
        
                %1.选择两个随机交叉点（或采用其他交叉方式）
                while true
                    v = randi([1,col-1],1,2);%注意：基于列维度生成随机交叉位置,randperm很耗时
                    c1 = min(v(1:2));
                    c2 = max(v(1:2));
                    if c1~=c2
                        break;
                    end
                end
        
                % 2.交叉生成两个新个体
                newpop(i,:)= [pop(i,1:c1),pop(i+1,c1+1:c2),pop(i,c2+1:end)];
                newpop(i+1,:)= [pop(i+1,1:c1),pop(i,c1+1:c2),pop(i+1,c2+1:end)];
        %-------------------------------------------------
    else
        % 不交叉，复制得到两个新个体
        newpop(i,:) = pop(i,:);
        newpop(i+1,:) = pop(i+1,:);
    end
    
end


%-------------------------------映射交叉(TSP问题常用)----------------------------------
% for i=1:2:row
%     if rand <= pc  %执行PMX交叉
%         % 1.选择两个随机交叉点（或采用其他交叉方式）
%         while true
%             v = randi([1,col-1],1,2);%注意：基于列维度生成随机交叉位置,randperm很耗时
%             c1 = min(v(1:2));
%             c2 = max(v(1:2));
%             if c1~=c2
%                 break;
%             end
%         end
%         % 2.映射交叉操作（元素映射替换操作）
%         child1 = pop(i,:); %转成向量再操作更简洁
%         child2 = pop(i+1,:);%转成向量再操作更简洁
%         for j = c1:c2
%             if child1(j)~= child2(j)
%                 % 子串1元素映射替换
%                 child1(child1==child2(j))=child1(j);
%                 child1(j)=child2(j);
%                 
%                 % 子串2元素映射替换
%                 child2(child2==child1(j))=child2(j);
%                 child2(j)=child1(j);
%             end
%         end
%         newpop(i,:)  = child1;
%         newpop(i+1,:) = child2;
%     else
%         % 不交叉，复制得到两个新个体
%         newpop(i,:) = pop(i,:);
%         newpop(i+1,:) = pop(i+1,:);
%     end
% end%for

end