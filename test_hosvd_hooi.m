X = tensor(rand(5,6,7,8));
rank = [2,2,2,2];
y1 = hosvd(X,rank);
y2 = hooi(X,rank);
Y1 = TK2tensor(y1);
Y2 = TK2tensor(y2);
error1 = norm(calculate("minus", Y1, X));
error2 = norm(calculate("minus", Y2, X));