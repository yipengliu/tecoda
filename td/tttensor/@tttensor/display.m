function display(T)

fprintf(['%s is a tttensor of size ',repmat('%dx',1,numel(T.size)-1), '%d', ' and rank ','[',repmat('%d ',1,numel(T.rank)-1),'%d].\n'],getVarName(T,inputname(1)),T.size(1:end-1),T.size(end),T.rank(1:end-1),T.rank(end));
        
fprintf('factors: {');
for i = 1:length(T.factors)
    sz = size(T.factors{i});
    fprintf(['[',repmat('%gx',1,numel(sz)-1),'%g %s]'],sz(1:end-1),sz(end),class(T.factors{i}));
end
fprintf('}.\n');
end

function out = getVarName(~,name)
    out = name;
end

