function disp(X,name)
%DISP Command window display of a tensor.
%
%   DISP(X) displays a tensor with no name.
%
%   DISP(X,NAME) displays a tensor with the given name.
%


if ~exist('name','var')
    name = 'ans';
end

%Convert size to a string that can be printed
if isempty(X.size)
    s = sprintf('[empty tensor]');
    return;
end

if numel(X.size) == 1
    s = sprintf('%d',X.size);
else
    s = [sprintf('%d x ',X.size(1:end-1)) sprintf('%d', X.size(end))];
end
fprintf(1,'%s is a tensor of size %s\n',name,s);

if isempty(X.data)
    fprintf(1,'\t%s = []\n',name);
    return
end

s = shiftdim(num2cell(X.data,1:2),2);

for i = 1:numel(s)
    fprintf('\t%s',name);
    if ndims(X) == 1
        fprintf('(:)');
    elseif ndims(X) == 2
        fprintf('(:,:)');
    elseif ndims(X) > 2
        fprintf('(:,:');
        fprintf(',%d',tt_ind2sub(X.size(3:end),i));
        fprintf(')');
    end
    fprintf(' = \n');
    % Convert a matrix to a cell array of strings.
    fmt = get(0,'FormatSpacing');
    format compact
    S = evalc('disp(s{i})');
    if isempty(S)
        S = {''};
        return;
    end
    set(0,'FormatSpacing',fmt)
    S = textscan(S,'%s','delimiter','\n','whitespace','');
    S = S{1};
    output = S;
    fprintf('\t%s\n',output{:});
end

end
