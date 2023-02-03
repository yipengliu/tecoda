function T = cp2tensor(CP)
%cp2tensor transform a CP format tensor into a dense tensor

    minS=minSplit(CP.size);
    if (minS==length(CP.size))
        data = khatrirao_product(CP.factors) * CP.weights;
    else
        % This unrolls modes 1:minS into rows and minS+1:end into columns
        % of the column-major matrix data which is then converted into a
        % tensor without permutation.
        %data = khatrirao(CP.factors(1:minS),'r') * diag(CP.weights) * khatrirao(CP.factors(minS+1:end),'r').';
        data = khatrirao_product(CP.factors(1:minS),'r') * diag(CP.weights) * khatrirao_product(CP.factors(minS+1:end),'r').';
    end
    T = tensor(data,CP.size);
end

function [minS]=minSplit(sz)
    % Search for optimal splitting with minimal memory footprint.
    mid = round(length(sz)/2);
    mLeft = prod(sz(1:mid));
    mRight = prod(sz(mid+1:end));
    minS = mid;
    minSum = mLeft+mRight;
    if mLeft < mRight
    % Search from mid to right
        while mid < length(sz)
            mid = mid+1;
            mLeft = mLeft*sz(mid);
            mRight = mRight/sz(mid);          
            if (mLeft+mRight < minSum)
                minSum = mLeft+mRight;
                minS = mid;
            else
                % mLeft and mRight are in balance
                break
            end
        end
    else
    % Search from mid to left
        while mid > 1
            mLeft = mLeft/sz(mid);
            mRight = mRight*sz(mid);
            mid = mid-1;
            if (mLeft+mRight < minSum)
                minSum = mLeft+mRight;
                minS = mid;
            else
                % mLeft and mRight are in balance
                break
            end            
        end
    end

end
