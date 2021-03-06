
  function [finalpath,d,dis] = getpath(x,point,goal,trajp,path0,dis)%车的位置，途经点，目标点
%多个任务点最短路径
path=[];

n=length(dis);
ind=[];
[lib1,ind1]=ismember(x,trajp,'rows');
[lib2,ind2]=ismember(goal,trajp,'rows');
for i=1:size(point,1)
    [lib3,ind3]=ismember(point(i,:),trajp,'rows');
    ind=[ind3 ind];
end
finalpath=[];

n=size(point,1);
num=perms(ind);
N=factorial(n);    %计算排列组合总数

%遍历所有的排列组合，找到最短的一种
d=10000;
for i=1:N
    dd=0;
    temp=ind1;
    for j=1:n
        dd=dd+dis(temp,num(i,j));
        temp=num(i,j);
    end   
    dd=dd+dis(num(i,n),ind2);
    if dd<d
        d=dd;
        path=num(i,:);
    end
end
cx=x;
for i=1:n
    [p] = printPath(cx,trajp(path(i),:),trajp,path0,dis);
    finalpath=[finalpath;p];
    cx=trajp(path(i),:);
end
[p] = printPath(cx,goal,trajp,path0,dis);
finalpath=[finalpath;p];
