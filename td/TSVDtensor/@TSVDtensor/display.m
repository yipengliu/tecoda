function message = display(T)
%report the meassage of TSVD format tensor
    fprintf(['%s is a TSVDtensor of shape ',repmat('%dx',1,numel(T.size)-1), '%d.\n'], getVarName(T,inputname(1)),T.size(1:end-1),T.size(end));
    sz = T.U.size;
    fprintf(['U: [',repmat('%gx',1,numel(sz)-1),'%g %s]\n'],sz(1:end-1),sz(end),class(T.U));
    sz = T.S.size;
    fprintf(['S: [',repmat('%gx',1,numel(sz)-1),'%g %s]\n'],sz(1:end-1),sz(end),class(T.S));
    sz = T.V.size;
    fprintf(['V: [',repmat('%gx',1,numel(sz)-1),'%g %s]\n'],sz(1:end-1),sz(end),class(T.V));
end
function out = getVarName(~,name)
    out = name;
end
