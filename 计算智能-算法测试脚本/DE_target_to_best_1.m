function [gbestx,gbestfitness,gbesthistory]=DE_target_to_best_1(popsize,dimension,xmax,xmin,vmax,vmin,maxiter,FuncId)
% Differential Evolution Algorithm: DE/current_to_best/1/bin
% popsize����Ⱥ��С
% dimension�� �����ά��
% maxiter�� ��������
% Funcid�� ���Ժ������


%% λ�ÿռ����
x=rand(popsize,dimension); %λ������
v=rand(popsize,dimension); %��������
u=rand(popsize,dimension); %��������
pbestx = rand(popsize,dimension);%��Ÿ���ľֲ�����λ��
gbestx = rand(1,dimension); % ���ȫ������λ��

% ��Ӧ�ȿռ����
fitnessx= rand(1,popsize); % Ⱥ����Ӧ��
pbestfitness= ones(popsize,1).*realmax;%�ֲ�������Ӧ��

gbesthistory=rand(maxiter,1); %��¼ÿһ���������Ӧ����ֵ,���ڻ�����������

F = 0.6;
CR= 0.9;

ComputeFitness=@SimpleBenchmark;

%% ��Ⱥ��ʼ��
for i =1:popsize
    x(i,:)=xmin+(xmax-xmin).*rand(1,dimension);
    fitnessx(i)= ComputeFitness(x(i,:),FuncId); % ������Ӧ��
    pbestfitness(i)=fitnessx(i);
    pbestx(i,:)=x(i,:);
end

% ��ʼ��ȫ�������Ӧ�Ⱥ���Ӧλ��
[gbestfitness, id] = min(pbestfitness);
gbestx(:) = pbestx(id,:);

%% ѭ������
iter =1;

 %% ******************����һ���֣� ��Ⱥ������ ******************
while iter<=maxiter
    
    for i =1:popsize
        %% 1.����iִ�б�����������ɹ�������v �������λ���Ƿ�Խ�����⣿��
        % ���ѡ��2����ͬ��i������
        r=selectID(popsize,i,2);
        
        r1=r(1);
        r2=r(2);
        
        % v(i,:)=x(i,:)+F*(pbestx(i,:)- x(i,:))+ F*(x(r1,:) - x(r2,:));
        v(i,:)=x(i,:)+F*(gbestx(1,:)- x(i,:))+ F*(x(r1,:) - x(r2,:));
        
        %% 2.����iִ�н��������������������u
        jrand =randi([1,popsize],1);
        
        for j =1:dimension
            if(rand <= CR || j==jrand)
                u(i,j)=v(i,j);
            else
                u(i,j)=x(i,j);
            end
        end
        
        
        %% 3. ����iִ��̰��ѡ������i��Ӧ����һ����Ⱥ���漰��Ӧ��������
        ufitness = ComputeFitness(u(i,:),FuncId);
        if ufitness <= fitnessx(i)
            x(i,:) = u(i,:);      % ���¸���λ��
            fitnessx(i)=ufitness; % ������Ӧ��
        end
        
        %% 4. ���¸����ȫ������λ��
        if fitnessx(i)<= gbestfitness
            gbestfitness=fitnessx(i);
            gbestx(1,:) = x(i,:);
        end
       
        
    end % end each individual
    
    %% ******************���ڶ����֣���¼���š� ******************
    
    gbesthistory(iter)=gbestfitness;
    
    fprintf("�㷨�㷨DE/target-best/1,��%d���������Ӧ�� = %e\n",iter,gbestfitness);
    
    iter = iter+1;
    
end % end iter
end % end function

%% ---------------------------------------------------------------------

%% ѡ��ͬ�ĺ���
function [r]=selectID(popsize,i,count)
% �������ܣ���[1,popsizze]���������count��������i�ı˴˲��ظ�������ֵ
% �������أ� ������r��������ά��Ϊcount��
% ����˼�룺 ���Ѿ�ѡ���Ԫ�أ���������ȥ����
if count<= popsize
    %1.��ȥi��ֵ�������µ�����vec
    vec=[1:i-1,i+1:popsize];
    
    %2.�������count����һ������ֵ
    r=zeros(1,count);
    
    for j =1:count
        n = popsize-j;   % ��ǰvec�������ĸ���
        t = randi(n,1,1);% ����һ���������
        r(j) = vec(t);   % ȡ�����
        vec(t)=[]; %��������ɾ����ǰԪ��,��ֹĳ�����ٱ�ѡ��
    end
end
end
