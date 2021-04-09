%1.求30个最优值的平均值
meanA = mean(dataA(:,1000))
meanB = mean(dataB(:,1000))
%2.求30个最优值的方差
varA = var(dataA(:,1000))
varB = var(dataB(:,1000))
%3.求30个最优值的最大值
maxA = max(dataA(:,1000))
maxB = max(dataB(:,1000))
%4.求30个最优值的最小值
minA = min(dataA(:,1000))
minB = min(dataB(:,1000))
%5.求30个最优值的中位数
midA = median(dataA(:,1000))
midB = median(dataB(:,1000))