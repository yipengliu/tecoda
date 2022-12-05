function M = l_shifting_n_unfolding(varargin)
    % wait to modifieds

    % default mode:arrange first mode as the row and in little-end order
    if isa(varargin{1},'tensor')
       T = varargin{1};
       if nargin == 1
            shift = 1;
            mode_row = 1;
            order = 'l';
       elseif nargin == 2 
            if varargin{2}=='L' || varargin{2}=='B'
                shift = 1;
                mode_row = 1;
                order = varargin{2};
            else
                error("Please input correct shift(number) and mode(number)!")
            end
       elseif nargin == 3
            if ~isnumeric(varargin{2}) || ~isnumeric(varargin{3})
                error("Shift and mode must be number!")
            else
                order = 'L';

                % Consider Shift
                if length(shift) >= 1
                    error("Shift must be a number!")
                end
                if shift == 0
                    M = mode_n1n2_unfolding(varargin{1},varargin{3});
                    return
                end
                shift = int8(varargin{2});
                if shift ~= varargin{2}
                    warning("Shift %d is not integer and round to %d",varargin{3},shift)
                end
                if shift < 0
                    new_shift = mod(shift,T.ndim+1);
                    warning("Shift %d is negative and mod be come mode %d",shift,new_shift)
                    shift = new_shift;
                elseif shift > T.ndim
                     new_shift = mod(shift,T.ndim+1);
                     warning("Shift %d exceed the dimension number of tensor and mod be come mode %d",shift,new_shift)
                     shift = new_shift;
                end
               

                mode_row = int8(varargin{3});
                order = 'l';
                for i = 1:length(mode_row)
                    if mode_row(i) <= 0
                        new_mode = mod(mode_row{i},T.ndim+1);
                        warning("%d mode %d is negative and mod be come mode %d",i,mode_row(i),new_mode)
                        mode_row(i) = new_mode;
                    end
                    if mode_row(i) ~= varargin{3}(i)
                        warning("%d mode %d is not integer and round to %d",varargin{3},i,mode_row(i))
                    end
                    if mode_row(i) > T.ndim
                        new_mode = mod(mode_row{i},T.ndim);
                        warning("%d mode %d exceed the dimension number of tensor and mod be come mode %d",i,mode_row(i),new_mode)
                        mode_row(i) = new_mode;
                    end
                end
            end
       elseif nargin == 4
            if ~isnumeric(varargin{2}) || ~isnumeric(varargin{3})
                error("Shift and mode must be number!")
            elseif varargin{4}~='L' && varargin{4}~='B'
                error("Order must be L or B!")
            else
                shift = varargin{2};
                if length(shift) >= 1
                    error("Shift must be a number!")
                elseif shift <= 0
                    error("Shift")

                mode_row = int8(varargin{3});
                order = 'l';
                for i = 1:length(mode_row)
                    if mode_row(i) <= 0
                        new_mode = mod(mode_row{i},T.ndim+1);
                        warning("%d mode %d is negative and mod be come mode %d",i,mode_row(i),new_mode)
                        mode_row(i) = new_mode;
                    end
                    if mode_row(i) ~= varargin{3}(i)
                        warning("%d mode %d is not integer and round to %d",varargin{3},i,mode_row(i))
                    end
                    if mode_row(i) > T.ndim
                        new_mode = mod(mode_row{i},T.ndim);
                        warning("%d mode %d exceed the dimension number of tensor and mod be come mode %d",i,mode_row(i),new_mode)
                        mode_row(i) = new_mode;
                    end
            end
    else
        error("Input tensor must be tensor class data")
    end
    % Litte endian order
    % refer to tensorlab ten2.mat tens2mat(T,[1,3],2)'
    if order=='L'
        mode_col = 1:T.ndim;
        mode_col(mode_row) = [];
        M = permute(T,[mode_row,mode_col]);
        M = reshape(M,mode,[]);
    % Big endian order
    else
        mode_col = 1:T.ndim;
        mode_col(mode_row) = [];
        mode_col = fliplr(mode_col);
        M = permute(T,[mode_row,mode_col]);
        M = reshape(M,mode,[]);
    end
   
end