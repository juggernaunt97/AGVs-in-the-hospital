function [x,crashstate,crash] = robotavoid(x,barrier,dropbarrier,xstate,state,xorder,xpath,xpoint,n,pn,target,stopp,trajp,path,dis)
% 
tempx = x;
tempbarrier=barrier;
tempdropbarrier=dropbarrier;
tempxstate=xstate;
tempstate=state;
tempxorder=xorder;
tempn=n;
tempxpath=xpath;
temppn=pn;
crashstate=false;
crash=zeros(size(x,1));
crash2 = zeros(size(x,1),size(barrier,1));
crash3 = zeros(size(x,1),size(dropbarrier,1));
for i=1:size(x,1)
    for j=1:size(x,1)
        if i~=j&&norm(tempx(i,:)-tempx(j,:))<0.6 
           crashstate=true;
           crash(i,j)=1;
        end
    end
end
for i=1:size(x,1)
    for j=1:size(x,1)
        for z=1:size(barrier,1)
            if i~=j&&norm(-tempbarrier(z,:) + tempx(i,:))<0.6
            crashstate=true;
            crash(i,j)=1;
            x(i,:)=x(i,:);
            end
        end
    end
end
for i=1:size(x,1)
    for j=1:size(x,1)
        for z=1:size(dropbarrier,1)
            if i~=j&&norm(tempx(i,:)-tempdropbarrier(z,:))<0.6
            crashstate=true;
            crash(i,j)=1;
            x(i,:)=x(i,:);
            end
        end
    end
end
    



