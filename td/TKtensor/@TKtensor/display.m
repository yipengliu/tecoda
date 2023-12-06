function display(T)

if isempty(T.size)
    fprintf('%s is a empty TKtensor',getVarName(T,inputname(1)));
    return
end

fprintf(['%s is a TKtensor of size ',repmat('%dx',1,numel(T.size)-1), '%d', ' and rank ',repmat('%dx',1,numel(T.rank)-1), '%d.\n'],getVarName(T,inputname(1)),T.size(1:end-1),T.size(end),T.rank(1:end-1),T.rank(end));
sz1 = size(T.core);
fprintf(['core: [',repmat('%dx',1,numel(sz1)-1),'%d %s].\n'],sz1(1:end-1),sz1(end),class(T.core));
sz=[];
for i = 1:length(size(T.factors))
    sz = [sz size(T.factors{i})];
end

fprintf('factors: {');
for i = 1:length(size(T.factors))
    sz = size(T.factors{i});
    fprintf(['[',repmat('%gx',1,numel(sz)-1),'%g %s]'],sz(1:end-1),sz(end),class(T.factors{i}));
end
fprintf('}.\n');
end

function out = getVarName(~,name)
out = name;
end
