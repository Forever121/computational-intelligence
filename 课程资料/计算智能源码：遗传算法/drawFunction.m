function h=drawFunction(funcid)
%% 函数功能：绘制指定函数的三维图形
% funcid：函数的编号

if funcid>17
    disp('函数测试总数为16个');
    pause;
end

% 1.二维空间绘图时，生成多个自变量
for func_num =funcid
    if func_num==1 x=-100:5:100;y=x; %sphere_func
    elseif func_num==2 x=-100:5:100; y=x;%schwefel_102
    elseif func_num==3 x=-10:0.5:10; y=x;%schwefel_102_noise_func
    elseif func_num==4 x=-100:5:100; y=x;%schwefel_2_21
    elseif func_num==5 x=-10:0.5:10; y=x;%schwefel_2_22
    elseif func_num==6 x=-200:10:200;y=x; %high_cond_elliptic_func
    elseif func_num==7 x=-10:0.5:10; y=x; % step_func
    elseif func_num==8 x=-500:10:500; y=x;%Schwefel_func(multimodal)
    elseif func_num==9 x=-2.048:0.05:2.048; y=x;%rosenbrock_func
    elseif func_num==10 x=-1.28:0.05:1.28;y=x; %Quartic function
    elseif func_num==11 x=-600:30:600; y=x;%griewank_func
    elseif func_num==12 x=-32:1:32; y=x;% ackley_func
    elseif func_num==13 x=-5:0.1:5; y=x;% rastrigin_func
    elseif func_num==14 x=-5:0.1:5; y=x;% rastrigin_noncont                                                                                                                 astrigin_noncont
    elseif func_num==15 x=-5:0.1:5; y=x;% weierstrass
    elseif func_num==16 x=-10:0.5:10; y=x;% tsingke
    else
        x=-100:1:100; y=x;break;
    end
    
    L=length(x);%x为搜索区间
    f=[];
    
    %2. 由自变量生成网格点，并计算各个网格点的函数值f(x,y)
    for i=1:L
        for j=1:L
            f(i,j)=benchmark_func([x(i),y(j)],func_num); % 一个点对应一个数值
        end
    end
    
    % 3. 根据网格点绘制空间图形
%     disp(['* 输出函数F',num2str(func_num),'图像 ...']);
%     figure(func_num)% 生成一份图形画布
    h=surfc(x,y,f);   % 在图形画布上绘制函数图像(带有等高线)surfC（X,Y,Z）
    %h=contour(x,y,f); % 等高线视角观看
    %view(0,90);%变换观看视角
    switch func_num
        case 1
            title('Sphere');
        case 2
            title('Schwefel-102');
        case 3
            title('Schwefel-102-noise');
        case 4
            title('Schwefel-2-21');
        case 5
            title('Schwefel-2-22');
        case 6
            title('High-cond-elliptic');
        case 7
            title('Step');
        case 8
            title('Schwefel-multimodal');
        case 9
            title('Rosenbrock');
        case 10
            title('Quartic');
        case 11
            title('Griewank');
        case 12
            title('Ackley');
        case 13
            title('Rastrigin');
        case 14
            title('Rastrigin-noncont');
        case 15
            title('Weierstrass');
        case 16
            title('tsingke');
        case 17
            title('Schaffer');
        otherwise
            title('No title function');
            
    end
    
    xlabel('x');
    ylabel('y');
    zlabel('f(x,y)');
    
    xmin=min(x);
    xmax=max(x);
    zmax=max(f(:));
    zmin=min(f(:));
    
    %axis([xmin xmax xmin xmax zmin zmax]);
    axis('auto z');
     % 4.输出并保存函数图像到指定路径下面
     filename=strcat('picture\','F',num2str(func_num));
     saveas(gcf,filename,'png');
    
end

end

