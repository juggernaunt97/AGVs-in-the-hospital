function[barrier] = getpathBarrier(barrier)
if barrier(2)>2
        barrier(2,1)=barrier(2,1)-0.1;
    elseif barrier(2)<=2
        barrier(2,2)=barrier(2,2)+0.1;
end
    if barrier(8)>22 && barrier(8)<25.5
        barrier(3:9,1)=barrier(3:9,1)+0.1;
    elseif barrier(8)==25.5 && barrier(8)<=29.5
        barrier(8,2)=barrier(8,2)+0.1;
    end
    if barrier(6,2)>3.5
        barrier(6,2)=barrier(6,2)-0.1;
    end
if barrier(2)>0 && barrier(2)<35
    barrier(2,:) = barrier(2,:) + [0.1 0];
end
end