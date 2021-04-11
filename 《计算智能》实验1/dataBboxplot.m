%1.绘制算法B的后十组数据收敛精度统计箱图
data_B = dataB(:,991:1000);
boxplot(data_B);
hold on
%2.绘制算法B的后十组数据的平均数
means = mean(data_B);
for i = 1:10
plot(i,means(i),'r.')
end
%3.显示图形标题，横坐标标题，纵坐标标题等内容
title('算法B的后十组数据收敛精度统计箱图模拟');
xlabel('算法B的后十组数据');
ylabel('适应度数值');
xticklabels({'data1','data2','data3','data4','data5','data6','data7','data8','data9','data10'});
%4.保存图片为png格式
saveas(gcf,'dataB-box-plot','png');