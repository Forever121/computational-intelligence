function [gbestx,gbestfitness,gbesthistory]=LPSO(popsize,dimension,xmax,xmin,vmax,vmin,maxiter,FuncId)
%% LPSO�㷨�� �ֲ�����Ⱥ�Ż��㷨������Ȩ�أ�
%% ���Ӹ�����ھ�Ϊ������λ�����ڵĸ���

% popsize   �� ��Ⱥ��С
% dimension �� ����ά��
% xmax��xmin�� λ�÷�Χ
% vman��vmin�� �ٶȷ�Χ
% maxiter��    ѭ����������
% maxrun ��    �ظ����Դ���

%������Ӧ�Ⱥ���
Fitness = @SimpleBenchmark;


% ���������ռ����
x=rand(popsize,dimension);%����洢�ռ�+��ʼ��
v=rand(popsize,dimension);%����洢�ռ�
fitness=ones(popsize,1).*realmax;  %����洢�ռ�fitne

% �ֲ����ſռ����
pbestx = rand(popsize,dimension);
pbestfitness = ones(popsize,1).*realmax;%��������

% ȫ�����ſռ����
gbestx=rand(1,dimension);
gbestfitness = realmax;%��ֵ����

gbesthistory=rand(maxiter,1); %��¼ÿһ���������Ӧ����ֵ,���ڻ�����������


%% ����һ������ʼ��������Ⱥ

 % ��ʼ�����ӵ�λ�ú��ٶ�
for i=1:popsize
    x(i,:) = xmin+(xmax-xmin).*rand(1,dimension);
    v(i,:) = vmin+(vmax-vmin).*rand(1,dimension);     
end


%% ���ڶ����� ѭ������Ѱ��ȫ������

c1=2.05;
c2=2.05;

for iter = 1:maxiter
    
   %% ��һ�������¾ֲ����ź�ȫ������
    for i=1:popsize
        
        % 1.�������ӵ���Ӧ��(����������)
        fitness(i)=Fitness(x(i,:),FuncId);
        
        % 2.�������ӵľֲ�����λ��
        if fitness(i)<= pbestfitness(i)
            pbestfitness(i)=fitness(i);
            pbestx(i,:) = x(i,:);
        end
        
        % 3. �������ӵ�ȫ������λ��
        if pbestfitness(i) <= gbestfitness
            gbestfitness = pbestfitness(i);
            gbestx(1,:) = pbestx(i,:);%������ֵ 
        end
    end
    
    
    %% �ڶ����� ����λ���������ٶ�����
    %w=0.9-0.4*(1.0*iter/maxiter);
        
    for i =1:popsize
        %-------------ѡ������i�������ھ�---------------
        t=i-1;%�������ȡģ��������0��ʼ��Ÿ�����ͳһ
        leftid = rem(t-1+popsize,popsize)+1;%����i�����ھ�
        rightid = rem(t+1+popsize,popsize)+1;%����i�����ھ�
        
        [~,lbestid] = min([pbestfitness(leftid),pbestfitness(rightid)]);
        
        %-------------�ٶȸ���-------------------
        % a.���������ٶȣ�������������
        v(i,:)= v(i,:)+c1*rand*(pbestx(i,:)-x(i,:))+c2*rand*(pbestx(lbestid,:) - x(i,:));
        %�ٶȼ��
        ov=v(i,:); ov(ov>vmax)=vmax; ov(ov<vmin)=vmin;%��ov = min{ov,vmax},ov=max(ov,vmin);
        v(i,:)= ov;
        
        %-------------λ�ø���-------------------
        % b.��������λ�ã�������������
        x(i,:)= v(i,:)+x(i,:);
        % λ�ü��
        ox = x(i,:); ox(ox>xmax)=xmax; ox(ox<xmin)=xmin;%��ox = min{ox,xmax},ox=max(ox,xmin);
        x(i,:)= ox;
    end % end for
   
    %% �������� ��¼���������Ӧ����ֵ
    gbesthistory(iter)= gbestfitness;
    
      fprintf("����F%d: LPSO�㷨,��%d���������Ӧ�� = %e\n",FuncId,iter,gbestfitness);
    
end %����ȫ������

%disp(gbestx(:)');%���ȫ�����Ž�

