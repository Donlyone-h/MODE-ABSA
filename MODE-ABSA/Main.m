%������
clear;
clc;
%��������
load Data\Data01;
tNumber = size(Tm,2);%JNumber ������������
sNumber = size(Trm,1);%���쵥Ԫ����
maxBatch = zeros(1,tNumber);%�����������
pNumber = 0;%�ܹ�����
f0 = 0.5;%��������
cr = 0.3;%��������
for i = 1 : tNumber
    max  = 0;
    for j = 1 : length(Tm(i).m)
        if(length(Tm(i).m{j}) > max)
            max = length(Tm(i).m{j});
        end
    end
    maxBatch(i) = max;
    pNumber = pNumber + max * Tm(i).tm(1);  
end 
jNumber = sum(maxBatch);%������������

pop = 100; %��Ⱥ��С
n = 200;%����������
traceT = zeros(2,n);%ʱ������¼
traceC = zeros(2,n);%�ɱ������¼
start_time=cputime;%��¼cpuʱ��
%��ʼ����Ⱥ
[pChorm,sChorm,sIndex] = InitPop(Tm,maxBatch,pNumber,jNumber,pop);
%�����Ŀ����Ӧ��ֵ
[valRank,bSize] = Bsize_Adj(pChorm,sChorm,sIndex,Tm,Trm,jNumber,pNumber,maxBatch);
%���ٷ�֧������ ӵ���ȼ���
% [upChorm,usChorm,uvalRank,ubSize] = NonDominationSort(pChorm,sChorm,valRank,bSize);
[uvalRank,ubSize] = NonDominationSort(valRank,bSize);
%��Ӣѡ�� ǰpop��
[pChorm,sChorm,valRank,bSize] = Select2(pChorm,sChorm,uvalRank,ubSize,pop);
% [pChorm,sChorm,valRank] = Select(upChorm,usChorm,uvalRank);
%���ڵ�ͼ ���������еȼ�
% color=hsv(200);
% figure;
for i = 1 : n
    lamda=exp(1-n/(n+1-i));
    f=f0*2^lamda;
    %�������
    [apChorm,asChorm] = Aberance(pChorm,sChorm,f,jNumber,Tm,Trm,maxBatch);
    %�������
    [npChorm,nsChorm] = Across(apChorm,asChorm,pChorm,sChorm,cr,jNumber,Tm,Trm,maxBatch);
    %�����Ӵ��������� npIChorm,nsIChorm �ӷ����nsIndex
    nsIndex = CtoI(npChorm,nsChorm,Tm,maxBatch,jNumber);
    %�����Ӵ���Ŀ����Ӧ��ֵ
    [nvalRank,nbSize] = Bsize_Adj(npChorm,nsChorm,nsIndex,Tm,Trm,jNumber,pNumber,maxBatch);
    %�ϲ��Ӹ���
    upChorm = [npChorm;pChorm];usChorm = [nsChorm;sChorm];
    uvalRank = [nvalRank;valRank];uvalRank(:,3:4) = 0;
    ubSize = [nbSize;bSize];
    %�ϲ��� ���ٷ�֧������ ӵ���ȼ���
    [uvalRank,ubSize] = NonDominationSort(uvalRank,ubSize);
    %��Ӣѡ�� ǰpop��
    [pChorm,sChorm,valRank,bSize] = Select(upChorm,usChorm,uvalRank,ubSize,pop);
    %��¼ÿ������
    traceT(1,i)=min(valRank(:,1));
    traceT(2,i)=mean(valRank(:,1));
    traceC(1,i)=min(valRank(:,2));
    traceC(2,i)=mean(valRank(:,2));
end
total_time=cputime-start_time;
%     %�����һ��ɢ��ͼ
%     valRank(:,3:4) = 0;
%     [valRank,ubSize] = NonDominationSort(valRank,bSize);
%     clf;
%     for k = 1 : size(valRank,1)
%         upChorm(k,:) = pChorm(valRank(k,5)-pop,:);
%         usChorm(k,:) = sChorm(valRank(k,5)-pop,:);
%         scatter(valRank(k,1),valRank(k,2),36,color(valRank(k,3) * 4,:),'filled');
%         hold on;
%     end
%     xlabel('����깤ʱ��');
%     ylabel('�ɱ�');

% %����ʱ�估ƽ������
% figure;
% plot(traceT(1,:));
% hold on;
% plot(traceT(2,:),'-.');
% grid on;
% title('�㷨��������');
% xlabel('��������');
% ylabel('��С����깤ʱ��');
% legend('��С����깤ʱ��','ƽ��ֵ');
% 
% %���ƹ��ļ�ƽ������
% figure;
% plot(traceC(1,:));
% hold on;
% plot(traceC(2,:),'-.');
% grid on;
% title('�㷨��������');
% xlabel('��������');
% ylabel('��С�ɱ�');
% legend('��С�ɱ�','ƽ��ֵ');

% %���Ƹ���ͼ
% bpChorm = upChorm(1,:);
% bsChorm = usChorm(1,:);
% bbSize = ubSize(1,:);
% Gantt(bpChorm,bsChorm,Tm,Trm,pNumber,jNumber,maxBatch,bbSize);

% % IGD
% PopObj = valRank(valRank(:,3) == 1,1:2);
% igd = IGD(PopObj,PF);
% %HV
% hv = hypervolume_indicator(PopObj,PF);