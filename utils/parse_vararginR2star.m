%% function [ranget2s,ranger2s,m0mode] = parse_vararginR2star(arg)
%
% Input
% --------------
% Flags:
%	'ranget2s'	: range for T2* (in s)
%	'ranger2s'	:range for R2* (in Hz)
%	'm0mode'    : method to compute m0, 'default','weighted','average'
%
% Output
% --------------
%
% Description:
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 
% Date last modified:
%
%
%% Parsing varargin
function [ranget2s,ranger2s,m0mode] = parse_vararginR2star(arg)
ranget2s = [];
ranger2s = [];
m0mode = [];
for kvar = 1:length(arg)
    if strcmpi(arg{kvar},'ranget2s')
        ranget2s = arg{kvar+1};
        continue
    end
    if strcmpi(arg{kvar},'ranger2s')
        ranger2s = arg{kvar+1};
        continue
    end
    if strcmpi(arg{kvar},'m0mode')
        m0mode = arg{kvar+1};
        continue
    end
end
end