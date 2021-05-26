function [gbestx,gbestfitness,gbesthistory]=DE_rand_1(popsize,dimension,xmax,xmin,vmax,vmin,maxiter,FuncId)
% Differential Evolution Algorithm: DE/rand/1
% popsize����Ⱥ��С
% dimension�� �����ά��
% maxiter�� ��������
% Funcid�� ���Ժ������


% �ռ����

x= rand(popsize,dimension);
v=rand(popsize,dimension);
u=rand(popsize,dimension);
fitnessx= rand(1,popsize);

gbesthistory=rand(maxiter,1); %��¼ÿһ���������Ӧ����ֵ,���ڻ�����������

F = 0.5;
CR= 0.9;

ComputeFitness=@SimpleBenchmark;

% ��Ⱥ��ʼ��
for i =1:popsize
    x(i,:)=xmin+(xmax-xmin).*rand(1,dimension);
    fitnessx(i)= ComputeFitness(x(i,:),FuncId); % ������Ӧ��
end

%%v ��ʼ��ȫ�������Ӧ�Ⱥ���Ӧλ��
[gbestfitness, pos] = min(fitnessx);
gbestx = x(pos,:);

%% ѭ������
iter =1;
while iter<=maxiter
    
    for i =1:popsize
        
        %% 1.����iִ�б�����������ɹ�������v �������λ���Ƿ�Խ�����⣿��
        
        %��ʽ��vi=x1+F*(x2-x3)
        
         %���ѡ��3����ͬ��i������
          r=selectID(popsize,i,3);
          
          r1=r(1);
          r2=r(2);
          r3=r(3);
        
        v(i,:)= x(r1,:) + F*(x(r2,:) - x(r3,:));
        
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
        
    end % end each individual
    
    
         %% 4. ����ȫ������
    [gbestfitness,gbestid] = min(fitnessx);
    
    gbestx = x(gbestid,:);
    
    gbesthistory(iter)=gbestfitness;
    
    fprintf("�㷨DE/rand/1,��%d���������Ӧ�� = %e\n",iter,gbestfitness);
    
    
    iter = iter+1;
    

    
end % end iter

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
