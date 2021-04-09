%绘制算法A、B的平均收敛曲线
meansA = mean(dataA);
meansB = mean(dataB);
x=[1:1: 1000 ];
%绘制算法A的平均收敛曲线
plot(x,meansA,'r:+')
hold on
%绘制算法B的平均收敛曲线
plot(x,meansB,'b--x')
%显示图形标题，横坐标标题，纵坐标标题等内容
title('算法A、B的平均收敛曲线');
xlabel('迭代次数');
ylabel('迭代后最优值');