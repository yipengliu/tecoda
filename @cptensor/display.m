function message = display(T)
%report the meassage of CP format tensor
    if T.rank
        fprintf(['%s is a rank-%d CPtensor of shape',repmat(' %d',1,numel(T.size)), '.\n'], getVarName(T,inputname(1)),T.rank,T.size(:));
        fprintf(['The weights of each columns in factor matrices are ',repmat(' %g',1,numel(T.weights)), '.\n'], T.weights(:));
        disp("The size of factor matrices:");
        sz = [T.size;repmat(T.rank,1,numel(T.size))];
        colname = {};
        for i = 1:numel(T.size)
            colname{1,i} = char(regexprep(string(i),'^(?![a-z])', 'f', 'emptymatch', 'ignorecase'));
        end
        tb = array2table(sz,'VariableNames',colname,'RowName',{'length','width'});
        disp(tb);
    else
        fprintf(['%s is a empty CPtensor of shape 0.\n'], getVarName(T,inputname(1)));
    end
end
function out = getVarName(~,name)
    out = name;
end