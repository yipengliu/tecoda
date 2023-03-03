function message = display(T)
%report the meassage of CP format tensor
    if T.rank
        fprintf(['%s is a rank-%d cptensor of shape ',repmat('%dx',1,numel(T.size)-1), '%d.\n'], getVarName(T,inputname(1)),T.rank,T.size(1:end-1),T.size(end));
        fprintf(['weights: [',repmat('%g,',1,numel(T.weights)-1), '%g].\n'], T.weights(1:end-1),T.weights(end));
        sz=[];
        for i = 1:length(size(T.factors))
            sz = [sz size(T.factors{i})];
        end
        
        fprintf('factors: {');
        for i = 1:length(size(T.factors))
            sz = size(T.factors{i});
            fprintf(['[',repmat('%gx',1,numel(sz)-1),'%g %s] '],sz(1:end-1),sz(end),class(T.factors{i}));
        end
        fprintf('}\n');
    else
        fprintf(['%s is a empty CPtensor of shape 0.\n'], getVarName(T,inputname(1)));
    end
end
function out = getVarName(~,name)
    out = name;
end