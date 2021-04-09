%绘制算法A的平均收敛曲线
meansA = mean(dataA);
x=[1:1: 1000 ];
plot(x,meansA,'r:+')
%显示图形标题，横坐标标题，纵坐标标题等内容
title('算法A的平均收敛曲线');
xlabel('迭代次数');
ylabel('迭代后最优值');