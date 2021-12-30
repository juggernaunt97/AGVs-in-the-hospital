function[movingbarrier,human] = getpathPeople(movingbarrier,human)
if movingbarrier(1)>20.9
        movingbarrier(1,:) = movingbarrier(1,:)-[0.022 0.0037];
end
if movingbarrier(1)>2 && movingbarrier(1)<=20.9
    movingbarrier(1,:) = movingbarrier(1,:)-[0.022 0.0047];
end
if movingbarrier(3,1)<19.1
    movingbarrier(3,:) = movingbarrier(3,:) +[0.1 -0.007];
end
if movingbarrier(3,1)>=19.1 && movingbarrier(3,1)<20
    movingbarrier(3,:) = movingbarrier(3,:) +[0.1 -0.015];
end
if movingbarrier(2,1)>1
    movingbarrier(2,:) = movingbarrier(2,1) + [-0.01 -0.08];
end

human(:,:) = human(:,:) + [0.01 0];
