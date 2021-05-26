%**************************************************************
% ���ܣ������Ż��㷨���Խű������г���+��������+���ͼ�Σ�
% ���ߣ� tsingke
% �汾�� V10.0
% ʱ�䣺 2021��4��30��
% ʹ�ã� �����Ż��㷨ר��
%****************************************************************
clc; 
clear;
close all;
format short e

% �������������
rng('shuffle');

% ��ȡ����ǰ����·��
AlgorithmPath= pwd;
cd(AlgorithmPath);
fprintf("��ʼ���г���(������ͨ����) ...\n");

AlgorithmName ={'GPSO','LPSO','wPSO','rwPSO','xPSO','DE/rand/1','DE/rand/2','DE/best/1','DE/best/2','DE/target-to-best/1','GA','DE/best/1/2', 'PSO', 'PSO/1','LPSO/1','xPSO/1'};
[~,SumAlgorithm]=size(AlgorithmName);%���������㷨�ĸ���
%��������㷨���ƣ��Ա�ѡ��
disp('--------------- [A] ѡ������㷨---------------');
for aid=1:SumAlgorithm
    fprintf('%d: %s\n',aid,AlgorithmName{aid});
end
disp('-----------------------------------------------');


AlgorithmCount = input('��������㷨���ܵ���Ŀ(��Χ1~6����'); %���ϲ���ʱ��
Countnum=1;
AlgorithmVec =[];
if AlgorithmCount == 1
    AlgorithmID = input('�����뵥�������㷨�ı�ţ� ');
    AlgorithmVec=AlgorithmID;
else
    % ������ʾ����Ҫ���Ե��㷨�ı����ֵ�������������Ҫ���Ե��㷨��
    if AlgorithmCount==SumAlgorithm
        AlgorithmVec =1:SumAlgorithm;
    else
        while Countnum<=AlgorithmCount
            id = input('����Ҫ���Ե������㷨��ţ�');%����idΪ����
            while (ismember(id,AlgorithmVec) || (id > SumAlgorithm)|| (id <=0))
                id = input('�����벻�ظ�����ȷ�㷨��ţ�');
            end
            AlgorithmVec =[AlgorithmVec,id];
            Countnum=Countnum+1;
        end
    end
    
end
%%
disp(['�����㷨����������,�����㷨��ţ�',num2str(AlgorithmVec)]);
pause(0.25);
disp('-------------- [B] ѡ����Ժ���---------------');
FunctionName={
    'sphere_func','schwefel_102','schwefel_102_noise_func',...
    'schwefel_2_21','schwefel_2_22','high_cond_elliptic_func',...
    'step_func','Schwefel_func','rosenbrock_func','quartic',...
    'griewank_func','ackley_func','rastrigin_func','rastrigin_noncont',...
    'weierstrass'};

[~,SumFunc]=size(FunctionName);%���������㷨�ĸ���

% ������к������ƣ��Ա�ѡ��
for fid=1:SumFunc
    fprintf('%d: %s\n',fid,FunctionName{fid});
end
disp('-----------------------------------------------');

FuncCount = input('��������Ժ������ܵ���Ŀ��1~15����');

FuncVec=[];
Countnum=1;

if FuncCount==1
    funcid = input('�����뵥�����Եĺ������id = ');
    FuncVec= funcid;% ������ֻ��1����ֵ
else
    if FuncCount==SumFunc %ֱ�Ӱ���Ÿ�ֵ
        FuncVec =1:SumFunc;
    else
        % ������ʾ����Ҫ���Ե��㷨�ı����ֵ�������������Ҫ���Ե��㷨��
        while Countnum<=FuncCount
            id = input('����Ҫ���Ե����⺯����ţ�');
            while (ismember(id,FuncVec) || id > SumFunc|| id<=0)
                id = input('�����벻�ظ�����ȷ������ţ�');
            end
            FuncVec =[FuncVec,id];
            Countnum=Countnum+1;
        end
    end
end

disp(['���Ժ�������������,���Ժ�����ţ�',num2str(FuncVec)]);
pause(0.25);
%     FuncVec = 1:FuncCount;% ����������ŵĺ���
%%
disp('-------------- [C] ѡ����Բ���---------------');

disp("�趨�㷨������1-Ĭ�����룬 2-�ֶ�����");
typeid = input("�㷨�������÷�ʽ = ");

switch typeid
    case {1}
        % ---------------�Զ���������----------------
        MaxRun = 10;
        MaxIter= 2000;
        PopSize = 40;
        D = 30;
        
    case {2}
        % ---------------�ֶ���������----------------
        MaxRun = input('�������ظ����Դ��� MaxRun = ');
        MaxIter= input('������ÿ�ε������� MaxIter = ');
        PopSize = input('��������Ⱥ����Ŀ  PopSize = ');
        D = input('���������ά�� D = ');
        
end

%% Ԥ����洢�ռ�

% ����ÿ�β��Եõ���ȫ�����λ��
Gbest_X=rand(MaxRun,D);

% ����ĳ���㷨�Ĳ��Խ��
Gbest_Fitness=rand(MaxRun,1);%ÿ�ֲ��Եõ���ȫ����Ӧ�ȼ�¼�����д洢��������ͳ�ƾ��ȣ��Լ�������ͼ
Gbest_History=rand(MaxRun,MaxIter);% ��ת����ԭʼ�������ݣ����ڼ�¼ĳ�㷨��ÿ�β����������Ӧ���ݻ����
Avg_History =rand(1,MaxIter);% ��¼ĳ�㷨�����в����е�ƽ�������Ӧ���ݻ���������������������

% ���������㷨�Ĳ��Խ��
Gbest_AllFitness=rand(MaxRun,AlgorithmCount);%ÿ�ֲ��Եõ���ȫ����Ӧ�ȼ�¼�����д洢��
Gbest_AllConvergence = rand(MaxIter,AlgorithmCount);%��¼R�β�����ÿ���㷨��ÿһ����������ƽ�������Ӧ�ȣ����д洢��

% ��¼�㷨����ʱ��
Time_AllCosts = zeros(1,AlgorithmCount); %��¼ÿ���㷨ѭ�����Ե���ʱ�䣬Ȼ��ȡ��ֵ��Ϊ�㷨����ʱ��

%% �㷨�ۺϲ���
% *******************************************************************************
%               ����һ���֡��� �����㷨�ڲ��Ժ����������Ż�����
% *******************************************************************************
   % �ڲ�ѭ��1����������
for FuncId = FuncVec % funcvecΪ������������������������˲��Ժ�������Ŀ
    
    fprintf('��ʼ���Ժ���%d������������ʼ����\n',FuncId);
    % ���ݲ��Ժ��������Զ������������䷶Χ��������չ�������������
    switch FunctionName{FuncId} %��Ԫ�����Զ���ȡ����������
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
    

    % �ڲ�ѭ��2���㷨����
    tightid=0;
    for algorithmid = AlgorithmVec %AlgorithmVecΪ���������Ҫ���Ե��㷨�ĸ�����ţ�����Ϊ1����ֵ��Ҳ����Ϊ�����ֵ���ɵ����������
        % �ڲ�ѭ��3���ظ�����
        tic; % ��ʼ��ʱ
        tightid=tightid+1; %�㷨������Ȼ���
        for r=1:MaxRun
            disp(['--------------------��ʼ�� ',num2str(r),' �ֲ���--------------------']);
            pause(0.25);%��ͣ0.5����ټ�������
%             if r==1
%                 cd(ProgramFilepath); % ���ص�������Ŀ¼
%             end
            
            % 1. �㷨����(������������Ӹ����㷨�Ľӿ�)
            switch AlgorithmName{algorithmid}
                %������Ӳ����㷨�������㷨��Ҫ�Ķ���ע��������ƵĴ�Сд��ʾ
                 %--------------------------------PSO���㷨-----------------------------------------------
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
                 %--------------------------------DE���㷨-----------------------------------------------
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
				%--------------------------------����㷨����λ�Դ���-----------------------------------------------
                otherwise
                    disp('�㷨ѡ���������˳�������ѡ���㷨���!');
                    pause;
                    exit;%�˳�����
            end % end switch
            
            % 2. ��¼�����㷨��������
            Gbest_X(r,:) = gbestX;%�����ÿ�д���ÿһ��ѭ���õ���ȫ����ѽ⣬��ѿռ�λ�ã�����չʾ�ã�
            Gbest_History(r,:)= gbesthistory;%�����ÿ�м�¼ÿ�β�����ÿһ�������Ӧ�ȵ���ֵ��ͳ��ƽ�����������ã�
            Gbest_Fitness(r)=gbestfitness;%��¼ÿ�εõ��������Ӧ�ȣ���ֵ��¼��ͳ�ƾ�����ֵ�ã�
            
        end  % end maxrun
        
        % ���ܼ�ʱ����
        Time_AllCosts(tightid)= (toc)/MaxRun;%ͳ���㷨��ִ��ʱ��
         if r==MaxRun 
            fprintf('%s�㷨��ѭ�����Խ�����ƽ����ʱΪ��%f�룩\n',AlgorithmName{algorithmid},Time_AllCosts(tightid));
        end
        %����ƽ�������������ݣ�����ÿ���е�ƽ�������Ӧ����ֵ
        if MaxRun>1
            Avg_History= sum(Gbest_History)./MaxRun;
        else
            Avg_History=Gbest_History;%�������������ֻ����1�ֵ��������ʱsum�����õ��ľ���1������������һ��������
        end
        
        Gbest_AllConvergence(:,tightid)=Avg_History';%������תΪ��������洢
        
        %���������������ݣ�ÿ�ֵõ���ȫ�������Ӧ����ֵ
        Gbest_AllFitness(:,tightid)=Gbest_Fitness; % ������ֵ
        
    end %% end algortimid
    
    disp('��ʼ������Ժ�����������ͼ,��ͼ, ʱ��ֱ��ͼ');
    % *********************** ���溯��FuncId���Ե������㷨ԭʼ���� *************************
    % �洢�����Ժ���F_X�ϸ����㷨��ȫ�ֺ���ʷ�������ݣ�ԭʼʵ�������ã�
    
    filename1=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\','Accuracy_F',num2str(FuncId));
    filename2=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\','Convergence_F',num2str(FuncId));
    filename3=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\','Timecosts_F',num2str(FuncId));
    
    % ����1������Ϊ.mat����
%     save(filename1,'Gbest_AllFitness');% ÿ������������ȼ�¼
%     save(filename2,'Gbest_AllConvergence');% ȫ������������ȼ�¼
%     save(filename3,'Time_AllCosts');

    % ����2������ΪExcel���ݣ����㷨�ڸ������ϵ�ƽ������ʱ���¼
    filename1 =strcat(filename1,'.xlsx');
    filename2 =strcat(filename2,'.xlsx');
    filename3 =strcat(filename3,'.xlsx');
    
    %��� filename �����ڣ�xlswrite ���Զ�����һ����������д��Ӧλ������
    xlswrite(filename1,Gbest_AllFitness);% ÿ������������ȼ�¼
    xlswrite(filename2,Gbest_AllConvergence);% ȫ������������ȼ�¼
    xlswrite(filename3,Time_AllCosts);% ���㷨�ڸ������ϵ�ƽ������ʱ���¼
    
    % *******************************************************************************
    %               �ڶ����֣� ���ɱ�����FuncId���������� + �㷨��������
    % *******************************************************************************
  
    %% �����1�������������ߣ������������㷨�ڲ��Ժ���F_x�ϵ���������ͼ
    
    %�������ߵ����ͺ���ɫ�������߻�ͼʱ�ã�ÿ���ṹ����Ϊһ��Ԫ��Ԫ�أ�����ʱ����ʾ���Ԫ�����ƣ��кţ��кŹ�ͬ��λԪ��Ԫ�أ�
    PlotStyle={
        struct('Color',[212,8,52]/255,'LineStyle','-','MarkerStyle','s'),...%ʡ�Ժű�ʾ����
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
 
    % ��ʼ�����㷨���������ߣ������㷨���λ��ƣ�
    %     figure(FuncId);
    % ----------------------����ͼ��------------------------------
    figure('Name','�㷨��������ͼ','NumberTitle','off');
    if AlgorithmCount > 1
        % �����������ߣ�����ѡ�еĲ����㷨���������ߣ�ע���㷨���δ��������
        for tid =1:AlgorithmCount
            %semilogy(1:MaxIter,Gbest_AllConvergence(:,tid),'LineWidth',1.2,'Color',PlotStyle{1,tid}.Color,'LineStyle',PlotStyle{1,tid}.LineStyle,'Marker',PlotStyle{1,tid}.MarkerStyle,'MarkerSize',6,'MarkerFaceColor',PlotStyle{1,tid}.Color,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%�������в����㷨����������
            semilogy(1:MaxIter,Gbest_AllConvergence(:,tid),'LineWidth',1.2,'Color',PlotStyle{1,tid}.Color,'LineStyle',PlotStyle{1,tid}.LineStyle,'Marker',PlotStyle{1,tid}.MarkerStyle,'MarkerSize',6,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%�������в����㷨����������
            xlim([0 MaxIter]);
            hold on;
        end
      
    else % ֻ��һ���㷨���Ե���������ݰ�����
        %semilogy(1:MaxIter,Gbest_AllConvergence(:,1),'LineWidth',1.2,'Color',PlotStyle{1,1}.Color,'LineStyle',PlotStyle{1,1}.LineStyle,'Marker',PlotStyle{1,1}.MarkerStyle,'MarkerSize',6,'MarkerFaceColor',PlotStyle{1,1}.Color,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%ֻ�����㷨���Ϊalgorithmid����������
        semilogy(1:MaxIter,Gbest_AllConvergence(:,1),'LineWidth',1.2,'Color',PlotStyle{1,1}.Color,'LineStyle',PlotStyle{1,1}.LineStyle,'Marker',PlotStyle{1,1}.MarkerStyle,'MarkerSize',6,'MarkerIndices',1:fix(MaxIter/20):MaxIter);%ֻ�����㷨���Ϊalgorithmid����������
        hold on;
    end
    % ---------------------�������-------------------------------
    % ���ͼ����Ϣ
%     title(['���� F',num2str(FuncId),'���㷨��������ͼ']);
    title(['The convergence curve of F',num2str(FuncId)]);
    xlabel('Iteration');
    ylabel('Log(mean best fitness error)');
    %axis tight;% ����������ķ�ΧΪ���ݵķ�Χ
    
    % ���ͼ�������룩
    lgd=legend(AlgorithmName(AlgorithmVec));%lgdΪͼ������ľ����ͨ���þ������������������
    lgd.NumColumns=1; % ͼ����ʾΪ����
    lgd.Location='best';%���� ����northeast���䣬���������� ����southeast������northwest������southwest��'best'
    % legend('boxoff')%ȥ��ͼ������߿�
    
    %��ͼ����ӱ��⣨��ѡ�
    %title(lgd,'Algorithms');
   % ---------------------����ͼ��-------------------------------
    % ����1��������������ͼ��ָ��Ŀ¼
    ProgramFilepath = pwd;%���浱ǰ����Ŀ¼
    FigurePath = strcat('ExperimentFigures\',num2str(D),'D_figure');
    cd(FigurePath);
    
    saveas(gcf,['ConvergenceF',num2str(FuncId)],'png');% ������������
    
    %����2������pdf����ļ�����ֱ���������ģ�
     set(gcf,'Units','Inches');
     pos = get(gcf,'Position');
     set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
     print(gcf,['ConvergenceF',num2str(FuncId)],'-dpdf','-r0');%�������İ��pdf
     
    cd(ProgramFilepath);%�ص��㷨Ŀ¼
    
    
    %% �����2������ͳ�����ݣ� ������㷨�ڲ��Ժ���F_x�ϵ�����������ֵ
    
    % 2. ����ͳ������
    if MaxRun >1  
        
        % Ԥ����ռ�-ȫ����ʼ��Ϊ0
        PrecisionValues = ones(3,AlgorithmCount);% ͳ��3�����ݣ���ֵ�������������ֵ
        ranksum_test = ones(1,AlgorithmCount);
        t_test = ones(1,AlgorithmCount);
        
        % �������ͳ����ֵ
        allmean = mean(Gbest_AllFitness);
        allstd = std(Gbest_AllFitness);
        allmax = max(Gbest_AllFitness);
        allmin = min(Gbest_AllFitness);
        allmedian = median(Gbest_AllFitness);   
        
        % ���������ͳ�Ʒ���
        if AlgorithmCount>1
            for tid=1:AlgorithmCount  % �㷨��Ų�һ�����������Դ洢ʱҪ����ע��
                [~,ranksum_test(tid)]= ranksum(Gbest_AllFitness(:,tid),Gbest_AllFitness(:,end));%���Լ����㷨�ŵ����һ��
                %t_test(tid)=ttest2(Gbest_AllFitness(:,tid),Gbest_AllFitness(:,end));
            end
             PrecisionValues = [allmean;allstd;ranksum_test];%��ֵ�����ͳ�Ƽ���ֵ�����ں���F_x�ϵ���ֵ�����д洢�����ڷŵ�������
             fprintf('-----------------�������-------------------\n');
        else
            PrecisionValues = [allmean;allstd;];%�����ں���F_x�ϵ���ֵ
			   %�����㷨����ʱ������㷨��ͳ������ֵ
             fprintf('\n-------------------�������---------------------\n');
             fprintf('�㷨 %s ��ͳ�����ݣ�\n *��ֵ��%e \n *���%e\n *��С��%e\n *���%e\n',AlgorithmName{AlgorithmVec},allmean,allstd,allmin,allmax);
             fprintf('------------------------------------------------\n');
        end
    else
         PrecisionValues = [];%�����ں���F_x�ϵ���ֵ
        disp(['ע������Դ��� MaxRun =  ',num2str(MaxRun),' ���ݲ�����ͳ�Ʋ��Է���']);
    end
    
    % �洢����
    if ~isempty(PrecisionValues)
        %���沽��1���л�Ŀ¼
        ProgramFilepath = pwd; % ���浱ǰ����Ŀ¼
        FileName_path=strcat(AlgorithmPath,'\ExperimentData\',num2str(D),'D_result\');
        cd(FileName_path);
        
        %���沽��2����������
        precisionFilename=strcat('paper_statistic_F',num2str(FuncId),'.xlsx');
        xlswrite(precisionFilename,PrecisionValues);
        
        cd(ProgramFilepath); % ���ص�������Ŀ¼
        %save(filename_paper,'PrecisionValues','-ascii');
    end
  
    %% �����3��������ͼ�����Ƹ����㷨�ں���F_x�ϵ���ͼ
    
    if MaxRun > 1
        % 1. ������ͼ��ͼ
        figure('Name','���㷨����������ͼ','NumberTitle','off');
        boxplot(Gbest_AllFitness); % ������ͼ
        
        % 2. ���ע����Ϣ
        hd_box=gca;% ͨ�����������������������ֵ��ͨ��get(bxphd)���Բ鿴����
        hd_box.FontSize = 8;%����
        % hd_box.FontName='Century';% ������������
        
        %title(['���� F',num2str(FuncId),' ͳ����ͼ ']);
        title(['The boxplot of F',num2str(FuncId)]);
        xlabel('Algorithms');
        xticklabels(AlgorithmName(AlgorithmVec))%��ע�㷨������-��ȫ��Ӧ���ѡ��
        ylabel('Fitness Error');
        
        % 3. ������ͼ��2�ַ�ʽ��
        ProgramFilepath = pwd;%���浱ǰ����Ŀ¼
       
        % ����1��������ͨpngͼƬ
        FigureSavePath = strcat('ExperimentFigures\',num2str(D),'D_figure');
        cd(FigureSavePath);
        figureName =strcat('BoxplotF',num2str(FuncId));%ͼƬ�洢Ŀ¼
        saveas(gcf,figureName,'png');
        
        % ����2�� ����pdf����ļ�����ֱ���������ģ�
        set(gcf,'Units','Inches');
        pos = get(gcf,'Position');
        set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(gcf,['BoxplotF',num2str(FuncId)],'-dpdf','-r0');%�������İ��pdf
    end
    

    %% �����4�������㷨����ʱ��ֱ��ͼ
    % 1. ����ˮƽ��������ͼ
    figure('Name','�㷨����ʱ��Ա�ͼ','NumberTitle','off');
    if AlgorithmCount==1
        bar(Time_AllCosts(1),'LineWidth',0.4);
    else
        bar(Time_AllCosts,'LineWidth',0.4);
    end
    
    % 2. ���ע����Ϣ
    hdb=gca;%��ȡ��ͼ�������������
    hdb.FontSize=8;
    % title('�㷨����ʱ��Ƚ�');
    title('Time costs');
    xlabel('Algorithm name');
    xticklabels(AlgorithmName(AlgorithmVec))%��ע�㷨�ľ�������
    ylabel('Average Time (/s)');
    
    % axis tight;

    % 3. ��������ͼͼƬ
    %����1�� ������ͨpngͼƬ
    figureName = strcat('TimecostsF',num2str(FuncId));
    saveas(gcf,figureName,'png');
    
    %����2�� ����pdf����ļ�����ֱ���������ģ�
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(gcf,['TimecostsF',num2str(FuncId)],'-dpdf','-r0');%�������İ��pdf
    
    cd(ProgramFilepath);%�л����㷨Դ��Ŀ¼�����������㷨
    
end % end function ����ǰ����������ϣ�������ݺ�ͼ����ɱ���������

%% �㷨�������ͷ��ڴ�ռ䣬�ر�����ͼ��
disp('��ܰ��ʾ�����س����ɹر�����ͼ�񴰿ڣ�');
pause;
close all;
%clear;%��չ���������

% �������н���������1������
% for i=1:1
%     sound(sin(2*pi*25*(1:3000)/100)); %��������Ͳ���������ʾ
%     pause(1);
% end



