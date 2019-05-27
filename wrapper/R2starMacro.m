%% function [r2s, t2s, m0] = R2starMacro(img,te,varargin)
%
% Usage: 
%   [r2s, t2s, m0] = R2starMacro(img,te,...
%                       'r2star','ARLO',...
%                       'm0mode',m0mode,'ranget2s',ranget2s,'ranger2s',ranger2s)
%   [r2s, t2s, m0] = R2starMacro(img,te,...
%                       'r2star','gs',...
%                       'm0mode',m0mode,'ranget2s',ranget2s,'ranger2s',ranger2s)
%   [r2s, t2s, m0] = R2starMacro(img,te,...
%                       'r2star','pi','method','1stEcho',...
%                       'm0mode',m0mode,'ranget2s',ranget2s,'ranger2s',ranger2s)
%   [r2s, t2s, m0] = R2starMacro(img,te,...
%                       'r2star','trapezoidal',...
%                       'm0mode',m0mode,'ranget2s',ranget2s,'ranger2s',ranger2s)
%   [r2s, t2s, m0] = R2starMacro(img,te,...
%                       'r2star','nlls','model','mono','mask',mask,...
%                       'fit','mag','ranget2s',ranget2s,'ranger2s',ranger2s)
%
% Description: 
%   Flags:
%       'method'    -   R2* mapping method
%       'm0mode'    -   method to compute m0, 'default','weighted','average' 
%       'mask'      -   binary signal mask
%
%       Pi
%       ----------------
%       'method'    -   method to compute R2*
%
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 22 September 2017
% Date last modified: 24 September 2017
%
function [r2s, t2s, m0] = R2starMacro(img,te,varargin)
r2star_addpath

%% Parsing argument input flags
[r2sMethod,piMethod,s0mode,mask,NUM_MAGN,isParallel]=parse_varargin_R2star(varargin);

if isempty(NUM_MAGN)
    NUM_MAGN = length(te);
end

disp(['Using algorithm: ' r2sMethod]);

switch lower(r2sMethod)
    case 'arlo'
        [r2s,t2s,m0] = R2star_ARLO_mag(img,te,s0mode);
    case 'gs'
        [r2s,t2s,m0] = R2star_GS(img,te,s0mode);
    case 'pi'
        [r2s,t2s,m0] = R2star_pi(img,te,s0mode,piMethod);
    case 'trapezoidal'
        [r2s,t2s,m0] = R2star_trapezoidal(img,te,s0mode);
    case 'nlls'
        [r2s,t2s,m0] = R2star_NLLS(img,te,mask,isParallel,NUM_MAGN);
    case 'regression'
        [r2s,t2s,m0] = R2star_regression(img,te,mask,isParallel);
end

end

%% Parsing varargin

function [r2sMethod,piMethod,s0mode,mask,NUM_MAGN,isParallel]=parse_varargin_R2star(arg)
r2sMethod = 'trapezoidal';
piMethod = 'interleaved';
% default setting
NUM_MAGN = [];
mask = [];
s0mode='1stecho';
isParallel = false;

for kvar = 1:length(arg)
    if strcmpi(arg{kvar},'method')
        r2sMethod = arg{kvar+1};
        if strcmpi(r2sMethod,'pi')
            piMethod = arg{kvar+2};
        end
        continue
    end
    if strcmpi(arg{kvar},'mask')
        mask = arg{kvar+1} > 0;
        continue
    end
    if strcmpi(arg{kvar},'s0mode')
        s0mode = arg{kvar+1};
        continue
    end
    if strcmpi(arg{kvar},'parallel')
        isParallel = arg{kvar+1};
        continue
    end
    if strcmpi(arg{kvar},'numMagn')
        NUM_MAGN = arg{kvar+1};
        continue
    end
end
end
