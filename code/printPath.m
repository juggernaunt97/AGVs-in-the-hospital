function [finalpath] = printPath(x,goal,trajp,path,dis)
% Chuyển đổi số đường dẫn thành một điểm tọa độ cụ thể

[lib1,ind1]=ismember(x,trajp,'rows');
[lib2,ind2]=ismember(goal,trajp,'rows');
pathind=printpathIndex(ind1,ind2,path);
finalpath=[];
for i=1:size(pathind,2)
    finalpath(i,:)=trajp(pathind(i),:);
end
d=dis(ind1,ind2);
end
