%**************************************************************
% 功能：智能优化算法测试脚本（运行程序+保存数据+输出图形）
% 作者： tsingke
% 版本： V10.0
% 时间： 2021年4月30日
% 使用： 智能优化算法专场
%****************************************************************
clc; 
clear;
close all;
format short e

% 产生随机数种子
rng('shuffle');

% 获取程序当前运行路径
AlgorithmPath= pwd;
cd(AlgorithmPath);
fprintf("开始运行程序(测试普通函数) ...\n");

AlgorithmName ={'GPSO','LPSO','wPSO','rwPSO','xPSO','DE/rand/1','DE/rand/2','DE/best/1','DE/best/2','DE/target-to-best/1','GA','DE/best/1/2', 'PSO', 'PSO/1','LPSO/1','xPSO/1'};
[~,SumAlgorithm]=size(AlgorithmName);%计算所有算法的个数
%输出所有算法名称，以便选择
disp('--------------- [A] 选择测试算法---------------');
for aid=1:SumAlgorithm
    fprintf('%d: %s\n',aid,AlgorithmName{aid});
end
disp('-----------------------------------------------');


AlgorithmCount = input('输入测试算法的总的数目(范围1~6）：'); %联合测试时用
Countnum=1;
AlgorithmVec =[];
if AlgorithmCount == 1
    AlgorithmID = input('请输入单独测试算法的编号： ');
    AlgorithmVec=AlgorithmID;
else
    % 根据提示输入要测试的算法的编号数值（可以组合任意要测试的算法）
    if AlgorithmCount==SumAlgorithm
        AlgorithmVec =1:SumAlgorithm;
    else
        while Countnum<=AlgorithmCount
            id = input('输入要测试的任意算法编号：');%这里id为整数
            while (ismember(id,AlgorithmVec) || (id > SumAlgorithm)|| (id <=0))
                id = input('！输入不重复的正确算法编号：');
            end
            AlgorithmVec =[AlgorithmVec,id];
            Countnum=Countnum+1;
        end
    end
    
end
%%
disp(['测试算法编号输入完毕,测试算法编号：',num2str(AlgorithmVec)]);
pause(0.25);
disp('-------------- [B] 选择测试函数---------------');
FunctionName={
    'sphere_func','schwefel_102','schwefel_102_noise_func',...
    'schwefel_2_21','schwefel_2_22','high_cond_elliptic_func',...
    'step_func','Schwefel_func','rosenbrock_func','quartic',...
    'griewank_func','ackley_func','rastrigin_func','rastrigin_noncont',...
    'weierstrass'};

[~,SumFunc]=size(FunctionName);%计算所有算法的个数

% 输出所有函数名称，以便选择
for fid=1:SumFunc
    fprintf('%d: %s\n',fid,FunctionName{fid});
end
disp('-----------------------------------------------');

FuncCount = input('请输入测试函数的总的数目（1~15）：');

FuncVec=[];
Countnum=1;

if FuncCount==1
    funcid = input('请输入单独测试的函数编号id = ');
    FuncVec= funcid;% 向量里只有1个数值
else
    if FuncCount==SumFunc %直接按序号赋值
        FuncVec =1:SumFunc;
    else
        % 根据提示输入要测试的算法的编号数值（可以组合任意要测试的算法）
        while Countnum<=FuncCount
            id = input('输入要测试的任意函数编号：');
            while (ismember(id,FuncVec) || id > SumFunc|| id<=0)
                id = input('！输入不重复的正确函数编号：');
            end
            FuncVec =[FuncVec,id];
            Countnum=Countnum+1;
        end
    end
end

disp(['测试函数编号输入完毕,测试函数编号：',num2str(FuncVec)]);
pause(0.25);
%     FuncVec = 1:FuncCount;% 测试连续编号的函数
%%
disp('-------------- [C] 选择测试参数---------------');

disp("设定算法参数：1-默认输入， 2-手动输入");
typeid = input("算法参数设置方式 = ");

switch typeid
    case {1}
        % ---------------自动参数输入----------------
        MaxRun = 10;
        MaxIter= 2000;
        PopSize = 40;
        D = 30;
        
    case {2}
        % ---------------手动参数输入----------------
        MaxRun = input('请输入重复测试次数 MaxRun = ');
        MaxIter= input('请输入每次迭代代数 MaxIter = ');
        PopSize = input('请输入种群的数目  PopSize = ');
        D = input('请输入测试维度 D = ');
        
end

%% 预分配存储空间

% 保存每次测试得到的全局最佳位置
Gbest_X=rand(MaxRun,D);

% 保存某个算法的测试结果
Gbest_Fitness=rand(MaxRun,1);%每轮测试得到的全局适应度记录（按列存储），方便统计精度，以及绘制箱图
Gbest_History=rand(MaxRun,MaxIter);% 中转矩阵，原始进化数据，用于记录某算法在每次测试中最佳适应度演化情况
Avg_History =rand(1,MaxIter);% 记录某算法在所有测试中的平均最佳适应度演化情况，方便绘制收敛曲线

% 保存所有算法的测试结果
Gbest_AllFitness=rand(MaxRun,AlgorithmCount);%每轮测试得到的全局适应度记录（按列存储）
Gbest_AllConvergence = rand(MaxIter,AlgorithmCount);%记录R次测试中每个算法在每一代搜索到的平均最佳适应度（按列存储）

% 记录算法运行时间
Time_AllCosts = zeros(1,AlgorithmCount); %记录每个算法循环测试的总时间，然后取均值作为算法测试时间

%% 算法综合测试
% *******************************************************************************
%               【第一部分】： 测试算法在测试函数的搜索优化性能
% *******************************************************************************
   % 内层循环1：函数部分
for FuncId = FuncVec % funcvec为向量，里面的向量个数决定了测试函数的数目
    
    fprintf('开始测试函数%d，点击任意键开始测试\n',FuncId);
    % 根据测试函数名称自动设置搜索区间范围，方便扩展，无需关心排序
    switch FunctionName{FuncId} %从元胞中自动获取函数的名称
        case 'sphere_func'
            xmax=100;xmin=-100;
            vmax=100;vmin=-100;
            
        case 'schwefel_102'
            xmax=100;xmin=-100;
            vmax=100;vmin=-100;
            
        case 'schwefel_102_noise_func' 
            xmax=32;xmin=-32;
            vmax=32;vmin=-32;
             
        case 'schwefel_2_21'
            xmax=5;xmin=-5;
            vmax=5;vmin=-5;
            
        case 'schwefel_2_22'
            xmax=10;xmin=-10;
            vmax=10;vmin=-10;
            
        case 'high_cond_elliptic_func'
            xmax=1;xmin=-3;
            vmax=1;vmin=-3;
            
        case 'step_func'
            xmax=10;xmin=-10;
            vmax=10;vmin=-10;
            
        case 'Schwefel_func'
            xmax=5;xmin=-2;
            vmax=5;vmin=-2;
        case 'rosenbrock_func'
            xmax=10;xmin=-10;
            vmax=10;vmin=-10;
            
        case 'Quartic_func'
            xmax=5;xmin=-2;
            vmax=5;vmin=-2;
            
        case 'griewank_func'
            xmax=600;xmin=-600;
            vmax=600;vmin=-600;
            
        case 'ackley_func'
            xmax=32;xmin=-32;
            vmax=32;vmin=-32;
            
        case 'rastrigin_func'
            xmax=5.12;xmin=-5.12;
            vmax=5.12;vmin=-5.12;
            
        case 'rastrigin_noncont'
            xmax=5.12;xmin=-5.12;
            vmax=5.12;vmin=-5.12;
            
        case 'weierstrass'
            xmax=0.5;xmin=-0.5;
            vmax=0.5;vmin=-0.5;
            
        case 'schaffer'
            xmax=100;xmin=-100;
            vmax=100;vmin=-100;
        otherwise
            xmax=100;xmin=-100;
            vmax=100;vmin=-100;
    end  
    

    % 内层循环2：算法部分
    tightid=0;
    for algorithmid = AlgorithmVec %AlgorithmVec为向量，存放要测试的算法的各个编号，可以为1个数值，也可以为多个数值构成的向量，灵活
        % 内层循环3：重复测试
        tic; % 开始计时
        tightid=tightid+1; %算法按序自然编号
        for r=1:MaxRun
            disp(['--------------------开始第 ',num2str(r),' 轮测试--------------------']);
            pause(0.25);%暂停0.5秒后，再继续运行
%             if r==1
%                 cd(ProgramFilepath); % 返回到程序工作目录
%             end
            
            % 1. 算法迭代(可以在这里添加各种算法的接口)
            switch AlgorithmName{algorithmid}
                %自行添加测试算法，其他算法不要改动，注意变量名称的大小写表示
                 %--------------------------------PSO类算法-----------------------------------------------
                case 'GPSO'
                    [gbestX,gbestfitness,gbesthistory]= GPSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'renPSO'
                    [gbestX,gbestfitness,gbesthistory]= renPSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'LPSO'
                    [gbestX,gbestfitness,gbesthistory]= LPSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'wPSO'
                    [gbestX,gbestfitness,gbesthistory]= wPSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'rwPSO'
                    [gbestX,gbestfitness,gbesthistory]= rwPSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'xPSO'
                    [gbestX,gbestfitness,gbesthistory]= xPSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                 %--------------------------------DE类算法-----------------------------------------------
                case 'DE/rand/1'
                    [gbestX,gbestfitness,gbesthistory]= DE_rand_1(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'DE/rand/2'
                    [gbestX,gbestfitness,gbesthistory]= DE_rand_2(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'DE/best/1'
                    [gbestX,gbestfitness,gbesthistory]= DE_best_1(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'DE/best/2'
                    [gbestX,gbestfitness,gbesthistory]= DE_best_2(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'DE/target-to-best/1'
                    [gbestX,gbestfitness,gbesthistory]= DE_target_to_best_1(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'GA'
                    [gbestX,gbestfitness,gbesthistory]= CI_GA(PopSize,D,xmax,xmin,MaxIter,FuncId);
                case 'DE/best/1/2'
                    [gbestX,gbestfitness,gbesthistory]= DE_best_1_2(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'PSO'
                    [gbestX,gbestfitness,gbesthistory]= PSO(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'PSO/1'
                    [gbestX,gbestfitness,gbesthistory]= PSO_1(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                case 'LPSO/1'
                    [gbestX,gbestfitness,gbesthistory]= LPSO_1(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
                    case 'xPSO/1'
                    [gbestX,gbestfitness,gbesthistory]= xPSO_1(PopSize,D,xmax,xmin,vmax,vmin ,MaxIter,FuncId);
				%--------------------------------你的算法（虚位以待）-----------------------------------------------
                otherwise
                    disp('算法选择有误，请退出后重新选择算法标号!');
                    pause;
                    exit;%退出程序
            end % end switch
            
            % 2. 记录本轮算法测试数据
            Gbest_X(r,:) = gbestX;%矩阵的每行代表每一轮循环得到的全局最佳解，最佳空间位置（动画展示用）
            Gbest_History(r,:)= gbesthistory;%矩阵的每行记录每次测试中每一代最佳适应度的数值（统计平均收敛曲线用）
            Gbest_Fitness(r)=gbestfitness;%记录每次得到的最佳适应度，单值记录（统计精度数值用）
            
        end  % end maxrun
        
        % 汇总计时数据
        Time_AllCosts(tightid)= (toc)/MaxRun;%统计算法的执行时间
         if r==MaxRun 
            fprintf('%s算法，循环测试结束（平均耗时为：%f秒）\n',AlgorithmName{algorithmid},Time_AllCosts(tightid));
        end
        %汇总平均收敛曲线数据：计算每代中的平均最佳适应度数值
        if MaxRun>1
            Avg_History= sum(Gbest_History)./MaxRun;
        else
            Avg_History=Gbest_History;%特殊的情况（如果只测试1轮的情况，此时sum后计算得到的就是1个数，而不是一个向量）
        end
        
        Gbest_AllConvergence(:,tightid)=Avg_History';%行向量转为列向量后存储
        
        %汇总收敛精度数据：每轮得到的全局最佳适应度数值
        Gbest_AllFitness(:,tightid)=Gbest_Fitness; % 向量赋值
        
    end %% end algortimid
    
    disp('开始输出测试函数收敛曲线图,箱图, 时间直方图');
    % *********************** 保存函数FuncId测试的所有算法原始数据 *************************
    % 存储：测试函数F_X上各个算法的全局和历史收敛数据（原始实验数据用）
    
    filename1=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\','Accuracy_F',num2str(FuncId));
    filename2=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\','Convergence_F',num2str(FuncId));
    filename3=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\','Timecosts_F',num2str(FuncId));
    
    % 方案1：保存为.mat数据
%     save(filename1,'Gbest_AllFitness');% 每轮最佳收敛精度记录
%     save(filename2,'Gbest_AllConvergence');% 全程最佳收敛精度记录
%     save(filename3,'Time_AllCosts');

    % 方案2：保存为Excel数据，各算法在各函数上的平均运行时间记录
    filename1 =strcat(filename1,'.xlsx');
    filename2 =strcat(filename2,'.xlsx');
    filename3 =strcat(filename3,'.xlsx');
    
    %如果 filename 不存在，xlswrite 将自动创建一个件，否则覆写对应位置数据
    xlswrite(filename1,Gbest_AllFitness);% 每轮最佳收敛精度记录
    xlswrite(filename2,Gbest_AllConvergence);% 全程最佳收敛精度记录
    xlswrite(filename3,Time_AllCosts);% 各算法在各函数上的平均运行时间记录
    
    % *******************************************************************************
    %               第二部分： 生成本函数FuncId的论文数据 + 算法收敛曲线
    % *******************************************************************************
  
    %% 【输出1】绘制收敛曲线：输出并保存各算法在测试函数F_x上的收敛曲线图
    
    %设置曲线的线型和颜色，多曲线绘图时用（每个结构体作为一个元胞元素，访问时与访问矩阵元素类似，行号，列号共同定位元胞元素）
    PlotStyle={
        struct('Color',[212,8,52]/255,'LineStyle','-','MarkerStyle','s'),...%省略号表示续行
        struct('Color',[236,120,9]/255,'LineStyle','-','MarkerStyle','o'),...
        struct('Color',[85,203,8]/255,'LineStyle','-','MarkerStyle','^'),...
        struct('Color',[8,118,90]/255,'LineStyle','-','MarkerStyle','d'),...%
        struct('Color',[8,36,190]/255,'LineStyle','-','MarkerStyle','p'),...%yellow
        struct('Color',[190,8,184]/255,'LineStyle','-','MarkerStyle','>'),...%pink
        struct('Color',[0,1,1],'LineStyle','-','MarkerStyle','<'),...
        struct('Color',[0.5,0.5,0.5],'LineStyle','-','MarkerStyle','v'),...%gray
        struct('Color',[136,0,21]/255,'LineStyle','-','MarkerStyle','x'),...%dark red
        struct('Color',[255,127,39]/255,'LineStyle','-','MarkerStyle','*'),...%orange
        struct('Color',[0,162,232]/255,'LineStyle','-','MarkerStyle','+'),...%Turquoise
        struct('Color',[163,73,164]/255,'LineStyle','-','MarkerStyle','.'),...%purple
        struct('Color',[1,0,0],'LineStyle','--','MarkerStyle','h'),...
        struct('Color',[0,1,0],'LineStyle','--','MarkerStyle','s'),...
        struct('Color',[0,0,1],'LineStyle','--','MarkerStyle','o'),...
        struct('Color',[0,0,0],'LineStyle','--','MarkerStyle','^'),...%           struct('Color',[1,1,0],'LineStyle','--'),...%yellow
        struct('Color',[1,0,1],'LineStyle','--','MarkerStyle','d'),...%pink
        struct('Color',[0,1,1],'LineStyle','--','MarkerStyle','p'),...
        struct('Color',[0.5,0.5,0.5],'LineStyle','--','MarkerStyle','>'),...%gray
        struct('Color',[136,0,21]/255,'LineStyle','--','MarkerStyle','<'),...%dark red
        struct('Color',[255,127,39]/255,'LineStyle','--','MarkerStyle','v'),...%orange
        struct('Color',[0,162,232]/255,'LineStyle','--','MarkerStyle','x'),...%Turquoise
        struct('Color',[163,73,164]/255,'LineStyle','--','MarkerStyle','*'),...%purple
        struct('Color',[1,0,0],'LineStyle','-.','MarkerStyle','+'),...
        struct('Color',[0,1,0],'LineStyle','-.','MarkerStyle','.'),...
        struct('Color',[0,0,1],'LineStyle','-.','MarkerStyle','h'),...
        struct('Color',[0,0,0],'LineStyle','-.','MarkerStyle','s'),...%
        struct('Color',[1,1,0],'LineStyle',':','MarkerStyle','o'),...%yellow
        struct('Color',[1,0,1],'LineStyle','-.','MarkerStyle','^'),...%pink
        struct('Color',[0,1,1],'LineStyle','-.','MarkerStyle','d'),...
        struct('Color',[0.5,0.5,0.5],'LineStyle','-.','MarkerStyle','p'),...%gray
        struct('Color',[136,0,21]/255,'LineStyle','-.','MarkerStyle','>'),...%dark red
        struct('Color',[255,127,39]/255,'LineStyle','-.','MarkerStyle','<'),...%orange
        struct('Color',[0,162,232]/255,'LineStyle','-.','MarkerStyle','v'),...%Turquoise
        struct('Color',[163,73,164]/255,'LineStyle','-.','MarkerStyle','x'),...%purple
        };
 
    % 开始绘制算法的收敛曲线（按照算法依次绘制）
    %     figure(FuncId);
    % ----------------------绘制图形------------------------------
    figure('Name','算法收敛曲线图','NumberTitle','off');
    if AlgorithmCount > 1
        % 逐条绘制曲线（绘制选中的测试算法的收敛曲线，注意算法编号未必连续）
        for tid =1:AlgorithmCount
            %semilogy(1:MaxIter,Gbest_AllConvergence(:,tid),'LineWidth',1.2,'Color',PlotStyle{1,tid}.Color,'LineStyle',PlotStyle{1,tid}.LineStyle,'Marker',PlotStyle{1,tid}.MarkerStyle,'MarkerSize',6,'MarkerFaceColor',PlotStyle{1,tid}.Color,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%绘制所有测试算法的收敛曲线
            semilogy(1:MaxIter,Gbest_AllConvergence(:,tid),'LineWidth',1.2,'Color',PlotStyle{1,tid}.Color,'LineStyle',PlotStyle{1,tid}.LineStyle,'Marker',PlotStyle{1,tid}.MarkerStyle,'MarkerSize',6,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%绘制所有测试算法的收敛曲线
            xlim([0 MaxIter]);
            hold on;
        end
      
    else % 只有一个算法测试的情况，数据按序存放
        %semilogy(1:MaxIter,Gbest_AllConvergence(:,1),'LineWidth',1.2,'Color',PlotStyle{1,1}.Color,'LineStyle',PlotStyle{1,1}.LineStyle,'Marker',PlotStyle{1,1}.MarkerStyle,'MarkerSize',6,'MarkerFaceColor',PlotStyle{1,1}.Color,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%只绘制算法编号为algorithmid的收敛曲线
        semilogy(1:MaxIter,Gbest_AllConvergence(:,1),'LineWidth',1.2,'Color',PlotStyle{1,1}.Color,'LineStyle',PlotStyle{1,1}.LineStyle,'Marker',PlotStyle{1,1}.MarkerStyle,'MarkerSize',6,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%只绘制算法编号为algorithmid的收敛曲线
        hold on;
    end
    % ---------------------添加修饰-------------------------------
    % 添加图形信息
%     title(['函数 F',num2str(FuncId),'各算法收敛曲线图']);
    title(['The convergence curve of F',num2str(FuncId)]);
    xlabel('Iteration');
    ylabel('Log(mean best fitness error)');
    %axis tight;% 设置坐标轴的范围为数据的范围
    
    % 添加图例（必须）
    lgd=legend(AlgorithmName(AlgorithmVec));%lgd为图例对象的句柄，通过该句柄可以设置其他参数
    lgd.NumColumns=1; % 图例显示为两列
    lgd.Location='best';%放在 东北northeast角落，其他可设置 东南southeast，西北northwest，西南southwest，'best'
    % legend('boxoff')%去掉图例的外边框
    
    %给图例添加标题（可选项）
    %title(lgd,'Algorithms');
   % ---------------------保持图形-------------------------------
    % 方案1：保存收敛曲线图到指定目录
    ProgramFilepath = pwd;%保存当前工作目录
    FigurePath = strcat('ExperimentFigures\',num2str(D),'D_figure');
    cd(FigurePath);
    
    saveas(gcf,['ConvergenceF',num2str(FuncId)],'png');% 保存收敛曲线
    
    %方案2：导出pdf版的文件（可直接用于论文）
     set(gcf,'Units','Inches');
     pos = get(gcf,'Position');
     set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
     print(gcf,['ConvergenceF',num2str(FuncId)],'-dpdf','-r0');%导出论文版的pdf
     
    cd(ProgramFilepath);%回到算法目录
    
    
    %% 【输出2】生成统计数据： 输出各算法在测试函数F_x上的收敛精度数值
    
    % 2. 计算统计数据
    if MaxRun >1  
        
        % 预分配空间-全部初始化为0
        PrecisionValues = ones(3,AlgorithmCount);% 统计3行数据：均值，方差，显著性数值
        ranksum_test = ones(1,AlgorithmCount);
        t_test = ones(1,AlgorithmCount);
        
        % 计算五大统计数值
        allmean = mean(Gbest_AllFitness);
        allstd = std(Gbest_AllFitness);
        allmax = max(Gbest_AllFitness);
        allmin = min(Gbest_AllFitness);
        allmedian = median(Gbest_AllFitness);   
        
        % 结果显著性统计分析
        if AlgorithmCount>1
            for tid=1:AlgorithmCount  % 算法序号不一定连续，所以存储时要格外注意
                [~,ranksum_test(tid)]= ranksum(Gbest_AllFitness(:,tid),Gbest_AllFitness(:,end));%把自己的算法放到最后一个
                %t_test(tid)=ttest2(Gbest_AllFitness(:,tid),Gbest_AllFitness(:,end));
            end
             PrecisionValues = [allmean;allstd;ranksum_test];%均值，方差，统计检验值保存在函数F_x上的数值，按行存储，便于放到论文中
             fprintf('-----------------测试完毕-------------------\n');
        else
            PrecisionValues = [allmean;allstd;];%保存在函数F_x上的数值
			   %测试算法个例时，输出算法的统计数据值
             fprintf('\n-------------------测试完毕---------------------\n');
             fprintf('算法 %s 的统计数据：\n *均值：%e \n *方差：%e\n *最小：%e\n *最大：%e\n',AlgorithmName{AlgorithmVec},allmean,allstd,allmin,allmax);
             fprintf('------------------------------------------------\n');
        end
    else
         PrecisionValues = [];%保存在函数F_x上的数值
        disp(['注：因测试次数 MaxRun =  ',num2str(MaxRun),' 故暂不进行统计测试分析']);
    end
    
    % 存储数据
    if ~isempty(PrecisionValues)
        %保存步骤1：切换目录
        ProgramFilepath = pwd; % 保存当前工作目录
        FileName_path=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\');
        cd(FileName_path);
        
        %保存步骤2：保存数据
        precisionFilename=strcat('paper_statistic_F',num2str(FuncId),'.xlsx');
        xlswrite(precisionFilename,PrecisionValues);
        
        cd(ProgramFilepath); % 返回到程序工作目录
        %save(filename_paper,'PrecisionValues','-ascii');
    end
  
    %% 【输出3】绘制箱图：绘制各个算法在函数F_x上的箱图
    
    if MaxRun > 1
        % 1. 绘制箱图箱图
        figure('Name','各算法收敛精度箱图','NumberTitle','off');
        boxplot(Gbest_AllFitness); % 绘制箱图
        
        % 2. 添加注释信息
        hd_box=gca;% 通过坐标轴句柄设置相关属性数值，通过get(bxphd)可以查看属性
        hd_box.FontSize = 8;%设置
        % hd_box.FontName='Century';% 设置字体类型
        
        %title(['函数 F',num2str(FuncId),' 统计箱图 ']);
        title(['The boxplot of F',num2str(FuncId)]);
        xlabel('Algorithms');
        xticklabels(AlgorithmName(AlgorithmVec))%标注算法的名称-完全对应最初选择
        ylabel('Fitness Error');
        
        % 3. 保存箱图（2种方式）
        ProgramFilepath = pwd;%保存当前工作目录
       
        % 方案1：导出普通png图片
        FigureSavePath = strcat('ExperimentFigures\',num2str(D),'D_figure');
        cd(FigureSavePath);
        figureName =strcat('BoxplotF',num2str(FuncId));%图片存储目录
        saveas(gcf,figureName,'png');
        
        % 方案2： 导出pdf版的文件（可直接用于论文）
        set(gcf,'Units','Inches');
        pos = get(gcf,'Position');
        set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(gcf,['BoxplotF',num2str(FuncId)],'-dpdf','-r0');%导出论文版的pdf
    end
    

    %% 【输出4】绘制算法运行时间直方图
    % 1. 绘制水平绘制条形图
    figure('Name','算法运行时间对比图','NumberTitle','off');
    if AlgorithmCount==1
        bar(Time_AllCosts(1),'LineWidth',0.4);
    else
        bar(Time_AllCosts,'LineWidth',0.4);
    end
    
    % 2. 添加注释信息
    hdb=gca;%获取箱图的坐标轴对象句柄
    hdb.FontSize=8;
    % title('算法运行时间比较');
    title('Time costs');
    xlabel('Algorithm name');
    xticklabels(AlgorithmName(AlgorithmVec))%标注算法的具体名称
    ylabel('Average Time (/s)');
    
    % axis tight;

    % 3. 导出条形图图片
    %方案1： 导出普通png图片
    figureName = strcat('TimecostsF',num2str(FuncId));
    saveas(gcf,figureName,'png');
    
    %方案2： 导出pdf版的文件（可直接用于论文）
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(gcf,['TimecostsF',num2str(FuncId)],'-dpdf','-r0');%导出论文版的pdf
    
    cd(ProgramFilepath);%切换到算法源码目录，继续运行算法
    
end % end function ，当前函数测试完毕，相关数据和图形完成保存和输出。

%% 算法结束，释放内存空间，关闭所有图形
disp('温馨提示：按回车键可关闭所有图像窗口！');
pause;
close all;
%clear;%清空工作区变量

% 程序运行结束，长滴1声提醒
% for i=1:1
%     sound(sin(2*pi*25*(1:3000)/100)); %程序结束就播放声音提示
%     pause(1);
% end



