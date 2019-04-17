clc,clear
%curve_fitting
%Berk 2018/6/11

%%%%%%%%%%
%data input
filename='chinaOpen.xlsx';
sheet=1;
FlatData=xlsread(filename,sheet);
sheet=2;
ChipData=xlsread(filename,sheet);
aFlat=zeros(1,12);
bFlat=zeros(1,12);
cFlat=zeros(1,12);
minFlat=zeros(1,12);
maxFlat=zeros(1,12);
aChip=zeros(1,12);
bChip=zeros(1,12);
cChip=zeros(1,12);
minChip=zeros(1,12);
maxChip=zeros(1,12);

%flat calculation
for RobotID=1:12
    if RobotID<=6
        rowNum.low=2;rowNum.high=8;  %
        columnNum=3*RobotID-2;
    else
        rowNum.low=15;rowNum.high=21;  %
        columnNum=3*(RobotID-6)-2;
    end
    FlatPower=FlatData(rowNum.low:rowNum.high,columnNum);
    FlatVel=(FlatData(rowNum.low:rowNum.high,columnNum+1)+FlatData(rowNum.low:rowNum.high,columnNum+2))/2;
    p=polyfit(FlatVel,FlatPower,2);
    aFlat(RobotID)=p(1)*10^5;bFlat(RobotID)=p(2);cFlat(RobotID)=p(3);
    minFlat(RobotID)=40;  %
    maxFlat(RobotID)=p(1)*650^2+p(2)*650+p(3);  %
end

%chip calculation
for RobotID=1:12
    if RobotID<=6
        rowNum.low=4;rowNum.high=9;  %
        columnNum=3*RobotID-2;
    else
        rowNum.low=17;rowNum.high=22;  %
        columnNum=3*(RobotID-6)-2;
    end
    ChipPower=ChipData(rowNum.low:rowNum.high,columnNum);
    ChipDistance=(ChipData(rowNum.low:rowNum.high,columnNum+1)+ChipData(rowNum.low:rowNum.high,columnNum+2))/2;
    p=polyfit(ChipDistance,ChipPower,2);
    aChip(RobotID)=p(1);bChip(RobotID)=p(2);cChip(RobotID)=p(3);
    minChip(RobotID)=40;  %
    maxChip(RobotID)=p(1)*430^2+p(2)*430+p(3);  %
end

%output
allData=zeros(10,12);
allData(1,:)=aFlat;
allData(2,:)=bFlat;
allData(3,:)=cFlat;
allData(4,:)=minFlat;
allData(5,:)=maxFlat;
allData(6,:)=aChip;
allData(7,:)=bChip;
allData(8,:)=cChip;
allData(9,:)=minChip;
allData(10,:)=maxChip;
dlmwrite('chinaOpen.txt', allData);
%%%%%%%%%%

figure
plot(FlatData(2:8,2),FlatData(2:8,1)),hold on
plot(FlatData(2:8,5),FlatData(2:8,4))
xlabel('Ball Speed (cm/s)');
ylabel('Flat Kick Power');
legend('Test Data 1','Test Data 2')