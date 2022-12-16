function message = display(T)
%report the meassage of CP format tensor
    if T.rank
        fprintf(['%s is a rank-%d CPtensor of shape',repmat(' %d',1,numel(T.sz)), '\n'], getVarName(T),T.rank,T.sz(:));
    else
        fprintf(['%s is a empty CPtensor of shape 0\n'], getVarName(T));
    end
end
function out = getVarName(~)
    out = inputname(1);
end