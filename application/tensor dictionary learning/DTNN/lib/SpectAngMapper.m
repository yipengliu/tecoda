function sam = SpectAngMapper(imagery1, imagery2)

%==========================================================================
% Evaluates the mean Spectral Angle Mapper (SAM)[1] for two MSIs.
%
% Syntax:
%   [psnr, ssim, fsim, ergas, msam ] = MSIQA(imagery1, imagery2)
%
% Input:
%   imagery1 - the reference MSI data array
%   imagery2 - the target MSI data array
% NOTE: MSI data array  is a M*N*K array for imagery with M*N spatial
%	pixels, K bands and DYNAMIC RANGE [0, 255]. If imagery1 and imagery2
%	have different size, the larger one will be truncated to fit the
%	smaller one.
%
%==========================================================================

tmp = (sum(imagery1.*imagery2, 3) + eps) ...
    ./ (sqrt(sum(imagery1.^2, 3)) + eps) ./ (sqrt(sum(imagery2.^2, 3)) + eps);
sam = mean2(real(acos(tmp)));