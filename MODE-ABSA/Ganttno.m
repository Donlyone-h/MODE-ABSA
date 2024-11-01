function Ganttno(bpChorm,bsChorm,Tm,Trm,pNumber,jNumber,maxBatch)

%������������
[bpIChorm,bsIChorm,bsIndex] = CtoP(Tm,maxBatch,jNumber,bpChorm,bsChorm);
%�����趨�ķ������� �õ��������� ����
[bbChorm,bbSize,bunitC] = BatchRule(bpIChorm,bsIChorm,bsIndex,Tm,Trm,jNumber,maxBatch);
%�����Ӵ���Ŀ����Ӧ��ֵ

%
pTable = zeros(1,jNumber);%��¼���������ʱ��
sTable = zeros(1,size(Trm,1));%��¼���ӷ������ʱ��
timeTable = zeros(3,pNumber);%��¼������ʱ�� ��ʼ-�ӹ�����-�������

tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
bIndex = zeros(1,jNumber);%��¼�ڼ���
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

pIndex = ones(1,jNumber);%��¼�ǵڼ�������
preS = zeros(1,jNumber);%��¼ǰһ�����쵥Ԫ���
preI = zeros(1,jNumber);%��¼ǰһ��������±�
figure;
color=hsv(168);
for i = 1 : length(bpIChorm)
    if bIndex(bpIChorm(i)) ~= 0
        index = find(tIndex >= bpIChorm(i),1);%index��¼�ڼ��๤��
        tz = bbSize(bpIChorm(i)) * Tm(index).t{pIndex(bpIChorm(i))}(bsIChorm(i));%�ӹ�ʱ��
        if pIndex(bpIChorm(i)) == 1 %��һ������
            preS(bpIChorm(i)) = bsIndex(i);
            preI(bpIChorm(i)) = i;
            %���㱾����ʼʱ��
            if sTable(bsIndex(i)) > 0
                t = sTable(bsIndex(i));
            else
                t = 0;
            end
            %��¼������ʱ��
            timeTable(1,i) = t;
            timeTable(2,i) = t + tz;
            

            %��¼���쵥Ԫ���ʱ��
            sTable(bsIndex(i)) =  timeTable(2,i);
            pIndex(bpIChorm(i)) = pIndex(bpIChorm(i)) + 1;
        else
            tt = Trm(preS(bpIChorm(i)),bsIndex(i));%����ʱ��
            timeTable(3,preI(bpIChorm(i))) = timeTable(2,preI(bpIChorm(i))) + tt;
            %��¼���쵥Ԫ���������ʱ��
            pTable(bpIChorm(preI(bpIChorm(i)))) = timeTable(3,preI(bpIChorm(i)));
            %���㱾����ʼʱ��
            if pTable(bpIChorm(i)) > sTable(bsIndex(i))
                t = pTable(bpIChorm(i));
                %������ʱ��
                if timeTable(2,preI(bpIChorm(i))) < sTable(bsIndex(i))
                    rec(1) = sTable(bsIndex(i));%�������º�����
                else
                    rec(1) = timeTable(2,preI(bpIChorm(i)));
                end
                rec(2)=bsIndex(i)-0.3;%��������������
                rec(3)=timeTable(3,preI(bpIChorm(i)))-rec(1);%���γ�������
                rec(4)=0.6;%���θ߶�
                rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor','#696969');
            else
                t = sTable(bsIndex(i));
            end
            %��¼������ʱ��
            timeTable(1,i) = t;
            timeTable(2,i) = t + tz;
            %��¼�ӷ������ʱ��
            sTable(bsIndex(i)) =  timeTable(2,i);

            preS(bpIChorm(i)) = bsIndex(i);
            preI(bpIChorm(i)) = i;
            pIndex(bpIChorm(i)) = pIndex(bpIChorm(i)) + 1;
        end
            rec(1)=timeTable(1,i);%�������º����꣬����ʼʱ��
            rec(2)=bsIndex(i)-0.3;%��������������
            rec(3)=timeTable(2,i)-timeTable(1,i);%���γ��ȣ��ӹ�ʱ��
            rec(4)=0.6;%���θ߶�
            txt=sprintf('%d-%d\n-%d',index,bIndex(bpIChorm(i)),pIndex(bpIChorm(i)) - 1);
            %������
            rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(bpIChorm(i)* 4,:));
            %ȷ���ı�λ��
            text(rec(1)+0.2,rec(2)+0.4,txt,'FontSize',10);        
    end

end
%�������귶Χ
axis([0,max(timeTable(2,:)),0,size(Trm,1)+ 1]);
xlabel('ʱ��(s)'),ylabel('�ӷ���');
title('����ͼ');
%


end