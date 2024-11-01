%主函数
clear;
clc;
%导入数据
load Data\Data01;
tNumber = size(Tm,2);%JNumber 工件种类数量
sNumber = size(Trm,1);%制造单元数量
maxBatch = zeros(1,tNumber);%最大批次数量
pNumber = 0;%总工序数
f0 = 0.5;%变异算子
cr = 0.3;%交叉算子
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
jNumber = sum(maxBatch);%分批后任务数

pop = 100; %种群大小
n = 200;%最大迭代次数
traceT = zeros(2,n);%时间结果记录
traceC = zeros(2,n);%成本结果记录
start_time=cputime;%记录cpu时间
%初始化种群
[pChorm,sChorm,sIndex] = InitPop(Tm,maxBatch,pNumber,jNumber,pop);
%计算各目标适应度值
[valRank,bSize] = Bsize_Adj(pChorm,sChorm,sIndex,Tm,Trm,jNumber,pNumber,maxBatch);
%快速非支配排序 拥挤度计算
% [upChorm,usChorm,uvalRank,ubSize] = NonDominationSort(pChorm,sChorm,valRank,bSize);
[uvalRank,ubSize] = NonDominationSort(valRank,bSize);
%精英选择 前pop个
[pChorm,sChorm,valRank,bSize] = Select2(pChorm,sChorm,uvalRank,ubSize,pop);
% [pChorm,sChorm,valRank] = Select(upChorm,usChorm,uvalRank);
%用于点图 区分帕累托等级
% color=hsv(200);
% figure;
for i = 1 : n
    lamda=exp(1-n/(n+1-i));
    f=f0*2^lamda;
    %变异操作
    [apChorm,asChorm] = Aberance(pChorm,sChorm,f,jNumber,Tm,Trm,maxBatch);
    %交叉操作
    [npChorm,nsChorm] = Across(apChorm,asChorm,pChorm,sChorm,cr,jNumber,Tm,Trm,maxBatch);
    %生成子代整数编码 npIChorm,nsIChorm 子服务号nsIndex
    nsIndex = CtoI(npChorm,nsChorm,Tm,maxBatch,jNumber);
    %计算子代各目标适应度值
    [nvalRank,nbSize] = Bsize_Adj(npChorm,nsChorm,nsIndex,Tm,Trm,jNumber,pNumber,maxBatch);
    %合并子父代
    upChorm = [npChorm;pChorm];usChorm = [nsChorm;sChorm];
    uvalRank = [nvalRank;valRank];uvalRank(:,3:4) = 0;
    ubSize = [nbSize;bSize];
    %合并后 快速非支配排序 拥挤度计算
    [uvalRank,ubSize] = NonDominationSort(uvalRank,ubSize);
    %精英选择 前pop个
    [pChorm,sChorm,valRank,bSize] = Select(upChorm,usChorm,uvalRank,ubSize,pop);
    %记录每代数据
    traceT(1,i)=min(valRank(:,1));
    traceT(2,i)=mean(valRank(:,1));
    traceC(1,i)=min(valRank(:,2));
    traceC(2,i)=mean(valRank(:,2));
end
total_time=cputime-start_time;
%     %画最后一代散点图
%     valRank(:,3:4) = 0;
%     [valRank,ubSize] = NonDominationSort(valRank,bSize);
%     clf;
%     for k = 1 : size(valRank,1)
%         upChorm(k,:) = pChorm(valRank(k,5)-pop,:);
%         usChorm(k,:) = sChorm(valRank(k,5)-pop,:);
%         scatter(valRank(k,1),valRank(k,2),36,color(valRank(k,3) * 4,:),'filled');
%         hold on;
%     end
%     xlabel('最大完工时间');
%     ylabel('成本');

% %绘制时间及平均曲线
% figure;
% plot(traceT(1,:));
% hold on;
% plot(traceT(2,:),'-.');
% grid on;
% title('算法搜索过程');
% xlabel('迭代次数');
% ylabel('最小最大完工时间');
% legend('最小最大完工时间','平均值');
% 
% %绘制功耗及平均曲线
% figure;
% plot(traceC(1,:));
% hold on;
% plot(traceC(2,:),'-.');
% grid on;
% title('算法搜索过程');
% xlabel('迭代次数');
% ylabel('最小成本');
% legend('最小成本','平均值');

% %绘制甘特图
% bpChorm = upChorm(1,:);
% bsChorm = usChorm(1,:);
% bbSize = ubSize(1,:);
% Gantt(bpChorm,bsChorm,Tm,Trm,pNumber,jNumber,maxBatch,bbSize);

% % IGD
% PopObj = valRank(valRank(:,3) == 1,1:2);
% igd = IGD(PopObj,PF);
% %HV
% hv = hypervolume_indicator(PopObj,PF);