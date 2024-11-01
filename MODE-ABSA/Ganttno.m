function Ganttno(bpChorm,bsChorm,Tm,Trm,pNumber,jNumber,maxBatch)

%生成整数编码
[bpIChorm,bsIChorm,bsIndex] = CtoP(Tm,maxBatch,jNumber,bpChorm,bsChorm);
%根据设定的分批策略 得到分批编码 单价
[bbChorm,bbSize,bunitC] = BatchRule(bpIChorm,bsIChorm,bsIndex,Tm,Trm,jNumber,maxBatch);
%计算子代各目标适应度值

%
pTable = zeros(1,jNumber);%记录各子批最后时间
sTable = zeros(1,size(Trm,1));%记录各子服务最后时间
timeTable = zeros(3,pNumber);%记录各工序时间 开始-加工结束-运输结束

tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
bIndex = zeros(1,jNumber);%记录第几批
ci = 1;
for i = 1 : size(maxBatch,2)
    bi = 1;
    for j = 1 : maxBatch(i)
        if bbSize(ci) ~= 0
            bIndex(ci) = bi;
            bi = bi + 1;
        end
        ci = ci + 1;
    end
end

pIndex = ones(1,jNumber);%记录是第几道工序
preS = zeros(1,jNumber);%记录前一个制造单元编号
preI = zeros(1,jNumber);%记录前一道工序的下标
figure;
color=hsv(168);
for i = 1 : length(bpIChorm)
    if bIndex(bpIChorm(i)) ~= 0
        index = find(tIndex >= bpIChorm(i),1);%index记录第几类工件
        tz = bbSize(bpIChorm(i)) * Tm(index).t{pIndex(bpIChorm(i))}(bsIChorm(i));%加工时间
        if pIndex(bpIChorm(i)) == 1 %第一道工序
            preS(bpIChorm(i)) = bsIndex(i);
            preI(bpIChorm(i)) = i;
            %计算本工序开始时间
            if sTable(bsIndex(i)) > 0
                t = sTable(bsIndex(i));
            else
                t = 0;
            end
            %记录本工序时间
            timeTable(1,i) = t;
            timeTable(2,i) = t + tz;
            

            %记录制造单元最后时间
            sTable(bsIndex(i)) =  timeTable(2,i);
            pIndex(bpIChorm(i)) = pIndex(bpIChorm(i)) + 1;
        else
            tt = Trm(preS(bpIChorm(i)),bsIndex(i));%运输时间
            timeTable(3,preI(bpIChorm(i))) = timeTable(2,preI(bpIChorm(i))) + tt;
            %记录制造单元和子批最后时间
            pTable(bpIChorm(preI(bpIChorm(i)))) = timeTable(3,preI(bpIChorm(i)));
            %计算本工序开始时间
            if pTable(bpIChorm(i)) > sTable(bsIndex(i))
                t = pTable(bpIChorm(i));
                %画运输时间
                if timeTable(2,preI(bpIChorm(i))) < sTable(bsIndex(i))
                    rec(1) = sTable(bsIndex(i));%矩形左下横坐标
                else
                    rec(1) = timeTable(2,preI(bpIChorm(i)));
                end
                rec(2)=bsIndex(i)-0.3;%矩形左下纵坐标
                rec(3)=timeTable(3,preI(bpIChorm(i)))-rec(1);%矩形长度运输
                rec(4)=0.6;%矩形高度
                rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor','#696969');
            else
                t = sTable(bsIndex(i));
            end
            %记录本工序时间
            timeTable(1,i) = t;
            timeTable(2,i) = t + tz;
            %记录子服务最后时间
            sTable(bsIndex(i)) =  timeTable(2,i);

            preS(bpIChorm(i)) = bsIndex(i);
            preI(bpIChorm(i)) = i;
            pIndex(bpIChorm(i)) = pIndex(bpIChorm(i)) + 1;
        end
            rec(1)=timeTable(1,i);%矩形左下横坐标，工序开始时间
            rec(2)=bsIndex(i)-0.3;%矩形左下纵坐标
            rec(3)=timeTable(2,i)-timeTable(1,i);%矩形长度，加工时间
            rec(4)=0.6;%矩形高度
            txt=sprintf('%d-%d\n-%d',index,bIndex(bpIChorm(i)),pIndex(bpIChorm(i)) - 1);
            %画矩形
            rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(bpIChorm(i)* 4,:));
            %确定文本位置
            text(rec(1)+0.2,rec(2)+0.4,txt,'FontSize',10);        
    end

end
%设置坐标范围
axis([0,max(timeTable(2,:)),0,size(Trm,1)+ 1]);
xlabel('时间(s)'),ylabel('子服务');
title('甘特图');
%


end