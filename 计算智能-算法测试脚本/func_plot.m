% func_plot.m
% �ű����ܣ��������в��Ժ���ͼ��
clc;
clear;

disp('------��ʼ������к���ͼ��------');
pause(0.5);

% 1.��ά�ռ��ͼʱ�����ɶ���Ա���
for func_num =1:16
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
    elseif func_num==16 x=-10:0.2:10;y=x;% schaffer
    else
        break;
    end
    
    L=length(x);
    f=[];
    
    %2. ���Ա�����������㣬��������������ĺ���ֵf(x,y)
    for i=1:L
        for j=1:L
            f(i,j)=benchmark_func([x(i),y(j)],func_num); % һ�����Ӧһ����ֵ
        end
    end
    
    % 3. �����������ƿռ�ͼ��
    disp(['* �������F',num2str(func_num),'ͼ�� ...']);
    figure(func_num)% ����һ��ͼ�λ���
    surfc(x,y,f);   % ��ͼ�λ����ϻ��ƺ���ͼ��(���еȸ���)surfC��X,Y,Z��
    
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
            title('Schaffer');
        otherwise
            title('No title function');
            
    end
    
    xlabel('x');
    ylabel('y');
    zlabel('f(x,y)');
    
    % 4.��������溯��ͼ��ָ��·������
    filename=strcat('FunctionMap\','F',num2str(func_num));
    saveas(gcf,filename,'png');
   
end


disp('------�����ϣ��س��ر�------');
pause;
clear;
clc;
close all;% �رյ�ǰ�����
