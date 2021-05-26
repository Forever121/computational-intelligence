function [gbestx,gbestfitness,gbesthistory]=DE_best_2(popsize,dimension,xmax,xmin,vmax,vmin,maxiter,FuncId)
% Differential Evolution Algorithm: DE/rand/1
% popsize����Ⱥ��С
% dimension�� �����ά��
% maxiter�� ��������
% Funcid�� ���Ժ������

%% λ�ÿռ����
x=rand(popsize,dimension); %λ������
v=rand(popsize,dimension); %��������
u=rand(popsize,dimension); %��������
fitnessx= rand(1,popsize);
gbestx = rand(1,dimension); % ���ȫ������λ��

gbesthistory=rand(maxiter,1); %��¼ÿһ���������Ӧ����ֵ,���ڻ�����������

F = 0.5;
CR= 0.9;

ComputeFitness=@SimpleBenchmark;% ��Ӧ�Ȳ��Ժ����������


%% ��Ⱥ��ʼ��
for i =1:popsize
    x(i,:)=xmin+(xmax-xmin).*rand(1,dimension);
    fitnessx(i)= ComputeFitness(x(i,:),FuncId); % ������Ӧ��   
end

%%v ��ʼ��ȫ�������Ӧ�Ⱥ���Ӧλ��
[gbestfitness, id] = min(fitnessx);
gbestx = x(id,:);

%% ѭ������
iter =1;
while iter<=maxiter
    
    %******************����һ���֣� ��Ⱥ������ ****************** 
    for i =1:popsize
        
        %% 1.����iִ�б�����������ɹ�������v �������λ���Ƿ�Խ�����⣿��
        
         %���ѡ��4����ͬ��i������
          r=selectID(popsize,i,4);
          
          r1=r(1);
          r2=r(2);
          r3=r(3);
          r4=r(4);
          
        v(i,:)= gbestx(1,:) + F*(x(r1,:) - x(r2,:))+ F*(x(r3,:) - x(r4,:));
        
        %% 2.����iִ�н��������������������u
        temp =randi([1,popsize],1);
        
        for j =1:dimension
            if(rand <= CR || j==temp)
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
        
        %% 4. ��ʱ����gbest��������������˸���
        if  fitnessx(i)<= gbestfitness
            gbestfitness = fitnessx(i);
            gbestx =x(i,:);
        end
        
    end % end each individual
    
    
          %******************���ڶ����֣���¼���š� ****************** 
   
    gbesthistory(iter)=gbestfitness;
    
    fprintf("�㷨DE/best/2����%d���������Ӧ�� = %e\n",iter,gbestfitness);
    
    iter = iter+1;

end % end while

end % end function


function [r]=selectID(popsize,i,count)
% �������ܣ���[1,popsize]���������count��������i�ı˴˲��ظ�������ֵ

if count<= popsize
    
    %1.��ȥi��ֵ�������µ�����vec
    vec=[1:i-1,i+1:popsize]; 

    %2.�������count����һ������ֵ
    r=zeros(1,count);
    for j =1:count
        n = popsize-j;   %��ǰvec�������ĸ���
        t = randi(n,1,1);%����һ���������
        r(j) = vec(t);   %ȡ�����
        vec(t)=[]; %��������ɾ����ǰԪ��,����ĳ�����ٱ�ѡ��
    end
    
end

end
