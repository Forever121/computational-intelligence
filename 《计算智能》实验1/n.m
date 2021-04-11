%Griewank 函数
function DrawGriewank()
clc; close all;
x=[-10:0.1:10];
y=[-10:0.1:10];
[X,Y]=meshgrid(x,y);
[row,col]=size(Y);
for l=1:col
for h=1:row
z(h,l)=Griewank([X(h,l),Y(h,l)]);
end
end
surf(X,Y,z);
shading interp
%绘制Griewank 函数
function y=Griewank(x)
[row,col]=size(x);
if row>1
error('输入的参数错误');
end
y1=1/4000*sum(x.^2);
y2=1;
for h=1:col
y2=y2*cos(x(h)/sqrt(h));
end
y=y1-y2+1;
y=-y;