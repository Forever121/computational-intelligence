a = dataA(:,1000)
b = dataB(:,1000)
m = ranksum(a,b)
[h,p] = ttest(a,b)