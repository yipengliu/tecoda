function message = display(T,name)
%report the meassage of CP format tensor


if ~exist('name','var')
    name = 'ans';
end

fprintf('%s is a rank-%d CPtensor of shape %d\n', name,2,2);

end 