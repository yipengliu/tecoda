function display(T)


fprintf(['%s is a BTDtensor of size ',repmat('%dx',1,numel(T.size)-1), '%d', ' and R %d.\n'],getVarName(T,inputname(1)),T.size(1:end-1),T.size(end),T.R);
fprintf('L: {');
for r=1:T.R
    sz_tmp=T.L{r};
    fprintf(['[',repmat('%d, ', 1, size(sz_tmp, 2)-1), '%d', ']  '],sz_tmp(1:end-1),sz_tmp(end));
end
fprintf('}.\n');
for r=1:T.R
    sz1=size(T.cores{r});
    fprintf(['core{%d}: [',repmat('%dx',1,numel(sz1)-1),'%d %s].\n'],r,sz1(1:end-1),sz1(end),class(T.cores{r}));
end

for r=1:T.R
    sz=[];
    for i=1:length(size(T.factors{r}))
        sz = [sz size(T.factors{r}{i})];
    end
    fprintf('factor{%d}: {',r);
    for i = 1:length(T.factors{r})
        sz = size(T.factors{r}{i});
        fprintf(['[',repmat('%gx',1,numel(sz)-1),'%g %s]'],sz(1:end-1),sz(end),class(T.factors{r}{i}));
    end
    fprintf('}.\n');
end
end

function out = getVarName(~,name)
    out = name;
end