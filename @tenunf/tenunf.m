%
classdef tenunf
    %tensor2unfolding class 
    %   intergrates all the unfolding methods for tensors
    
    properties
        data
        kunf
        nunf
    end
    
    methods
        function obj = tenunf()
            %UNFOLDING 构造此类的实例
            %   此处显示详细说明
        end
        
        function obj = kunf_all()
            obj.data
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

