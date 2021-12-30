close all;
clear all;

load('../data/movingbarrier.mat')
load('../data/dropbarrier.mat')
load('../data/barrier.mat')
load('../data/trajp.mat') % 仓储环境的轨迹点
load('../data/x.mat')    %100个机器人的初始位置
load('../data/storagepoint.mat')   %货架上对应的工作点
load('../data/storagerock.mat')     %货架位置
load('../data/target.mat')          %最终目标点
load('../data/stopp.mat')
load('../data/human.mat')
%与目标点相对应的，每个机器人站中的停靠点
xpath=zeros(1500,200);% Được sử dụng để lưu trữ các nhiệm vụ còn lại theo thứ tự hiện tại của robot
xstate=zeros(1,100); %Dùng để chỉ trạng thái của rô bốt, 0 chưa chấp nhận lệnh 1 đang thực hiện lệnh
state=zeros(1,100); % Được sử dụng để đánh giá liệu rô bốt đã đạt đến điểm nhiệm vụ và sẵn sàng thực hiện nhiệm vụ hay chưa
xpoint=zeros(3,200);
xorder=zeros(1500,200); % Thứ tự nhiệm vụ ma trận, được sử dụng để lưu trữ đường dẫn hiện tại của tất cả các rô bốt
n = 20;
R = [1 25];

dt=0.1;
global v
v = 0.5;
duration = 1; %Thời gian làm việc của robot
grid on
[t,dis,path] = Floyd1(trajp);
time=0;
worktime=zeros(1,size(x,1)); % Ghi lại thời gian robot đã làm việc tại điểm làm việc hiện tại
[point,goal] = Createorderform();    %Tạo đơn hàng
num=1;
pn=zeros(1,100)
n=ones(size(x,1),1);  %Được sử dụng để ghi lại nút nào rô bốt đã đạt đến trên đường dẫn hiện tại của nó
t=0;
z=1;
K = dlmread('output.txt');
K1 = K(1:3,:);
K2 = K(4:8,:);
K3 = K(9:11,:);
movingbarrier(1,:)=K(1,:);
movingbarrier(2,:)=K2(1,:);
movingbarrier(3,:)=K3(1,:);

while 1
    dropbarrier = rand(z,2)*range(R);
    save('dropbarrier.mat');
    z=z+1;
    if num<200                              %Tạo đơn hàng sau mỗi -s
        [point,goal] = Createorderform();    %Tạo đơn hàng
        %         point=[3 3.5]
        %          goal=[4.5 2]
        num=num+1;
        [crashstate,crash] = robotavoid(x,barrier,dropbarrier,xstate,state,xorder,xpath,xpoint,n,pn,target,stopp,trajp,path,dis);
        [finalpath,ind,xstate] = bidfunc(x,xstate,xpath,point,goal,duration,trajp,pn,path,dis);  %Đặt giá thầu, đưa ra con đường dẫn đến chiếc xe có chi phí thấp nhất
        xorder(:,2*ind-1:2*ind)=zeros(1500,2);
        n(ind)=1;
        xorder(1:size(finalpath,1),2*ind-1:2*ind)=finalpath;
        xpath(1:size(finalpath,1),2*ind-1:2*ind)=finalpath;
        xpoint(:,2*ind-1:2*ind)=[point;zeros(3-size(point,1),2)];
        pn(ind)=size(point,1);
        time=0;
    end
    
    while 1

        hold off
        histogram(x)
        
        [x,crashstate,crash] = robotavoid(x,barrier,dropbarrier,xstate,state,xorder,xpath,xpoint,n,pn,target,stopp,trajp,path,dis);     
        [x,xstate,state,xpath,n,pn,xorder] = Executetask(x,xstate,state,xorder,xpath,xpoint,n,pn,crash,target,stopp,trajp,path,dis); 
        [movingbarrier,human] = getpathPeople(movingbarrier,human);
        [barrier] = getpathBarrier(barrier);
        time=time+dt;
        t=t+dt;
        worktime;
        plot(finalpath(:,1),finalpath(:,2),'--');hold on;
        plot(x(:,1),x(:,2),'ro','MarkerFaceColor','r');hold on;
        strHuman = 'human';
        strDr = 'doctor';
        strAGV = 'AGV';
        plot(human(:,1),human(:,2),'gs','MarkerFaceColor','m');hold on;
        text(human(:,1),human(:,2),strHuman,'Color','black','FontSize',7);
        plot(movingbarrier(:,1),movingbarrier(:,2),'gs','MarkerFaceColor','b');hold on;
        text(movingbarrier(:,1),movingbarrier(:,2),strDr,'Color','blue','FontSize',7);
        plot(barrier(:,1),barrier(:,2),'gs','MarkerFaceColor','b');hold on;
        text(barrier(:,1),barrier(:,2),strDr,'Color','blue','FontSize',7);
        text(x(:,1),x(:,2),strAGV,'Color','red','FontSize',6);
        plot(K2(:,1),K2(:,2),'--');hold on;
        plot(K1(:,1),K1(:,2),'--');hold on;
        plot(K3(:,1),K3(:,2),'--');hold on;
        plot(dropbarrier(:,1),dropbarrier(:,2),'gs','MarkerFaceColor','y');hold on;
        plot(storagerock(:,1),storagerock(:,2),'sk');hold on;
        
        simenvironment()
        plot(target(:,1),target(:,2),'xr');hold on;
        grid on
        drawnow;
        for j=1:size(x,1)
            if state(j)==1                     % Nếu rô bốt đạt đến điểm làm việc, bắt đầu tính thời gian cho đến khi kết thúc thời gian tác vụ
                worktime(j)=worktime(j)+dt;
            end
            if worktime(j)>duration
                worktime(j)=0;
                state(j)=0;
            end
        end
        if time>2
            break;
        end
        
    end
    if num==200&&(~any(xstate))
        break;
    end
end