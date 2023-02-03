%
classdef tenunf<handle
    %tensor2unfolding class 
    %   intergrates all the unfolding methods for tensors
    
    properties
        kunf % store all k-th unfolding matrices
        nunf % store all mode n unfolding matrices
        bunf % store balanced unfolding matrices
    end
    
    methods
        function obj = tenunf()
            %UNFOLDING 构造此类的实例
            %   此处显示详细说明
            obj.kunf={};
            obj.nunf={};
            obj.bunf=[];
        end
        
        function kunf_all(obj,T)
            if isa(T,'tensor')
                ndims = numel(T.size);
            elseif isnumeric(T)
                ndims = numel(size(T));
            else
                error("Input tensor must be tensor class data or high dimension matrix!")
            end
            for k = 1:ndims
                obj.kunf{k} = k_unfold(T,k);
            end
        end
        
        function nunf_all(obj,T)
            if isa(T,'tensor')
                ndims = numel(T.size);
            elseif isnumeric(T)
                ndims = numel(size(T));
            else
                error("Input tensor must be tensor class data or high dimension matrix!")
            end
            for n = 1:ndims
                obj.nunf{n} = mode_n_unfold(T,n);
            end
        end
        
        function bunf_all(obj,T)
            if isa(T,'tensor')
                ndims = numel(T.size);
            elseif isnumeric(T)
                ndims = numel(size(T));
            else
                error("Input tensor must be tensor class data or high dimension matrix!")
            end
            obj.bunf=balanced_unfold(T);
        end
        
        function clear(obj,cmd)
            switch cmd
                case 'a'
                    obj.kunf={};
                    obj.nunf={};
                    obj.bunf=[];
                case 'k'
                    obj.kunf={};
                case 'n'
                    obj.nunf={};
                case 'b'
                    obj.b=[];
            end
        end
        
        % tensor to unfolding matrix
        function [unfolding,varargout] = ten2unf(varargin)
            switch varargin{2}
                case 'k'
                    unfolding = k_unfold(varargin{3:end});
                case 'n'
                    unfolding = mode_n_unfold(varargin{3:end});
                case 'n1n2'
                    unfolding = mode_n1n2_unfold(varargin{3:end});
                case 'Ln'
                    unfolding = Lshift_n_unfold(varargin{3:end});
                case 'b'
                    [unfolding,varargout{1},varargout{2}] = balanced_unfold(varargin{3:end});
            end
        end
        
        function T = unf2ten(varargin)
           switch varargin{2}
                case 'k'
                    T = k_fold(varargin{3:end});
                case 'n'
                    T = mode_n_fold(varargin{3:end});
                case 'n1n2'
                    T = mode_n1n2_fold(varargin{3:end});
                case 'Ln'
                    T = Lshift_n_fold(varargin{3:end});
                case 'b'
                    T = balanced_fold(varargin{3:end});
            end
        end
    end
end

