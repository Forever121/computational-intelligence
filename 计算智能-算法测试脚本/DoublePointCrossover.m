function [o1,o2]=DoublePointCrossover(p1,p2)
%% 功能：父代p1和p2执行单点交叉，生成2个子代个体
%  作者：tsingke
%  备注：p1,p2都是行向量

% 1.随机产生两个不同的点
[r,c]=size(p1);
s=randperm(r*c);%乱序排列

r1=min(s(1),s(2));%交叉点1
r2=max(s(1),s(2));%交叉点2

%2.两点交叉,得到两个子代o1和o2

o1=[p1(1:r1) p2(r1+1:r2) p1(r2+1:end)];
o2=[p2(1:r1) p1(r1+1:r2) p2(r2+1:end)];
end