%% function output = function_name(input)
%
% Usage:
%
% Input
% --------------
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
function [r2s,t2s,m0] = R2starmapping_CRSI(img,te,sigma,varargin)
p = abs(img).^2;
nTE = length(te);
%% Parsing argument input flags
[~,~,~,~,ranget2s,ranger2s,m0mode,~,m]=parse_varargin_R2star(varargin);
if isempty(ranget2s)
    minT2s = min(te)/20;
    maxT2s = max(te)*20;
    ranget2s = [minT2s, maxT2s];
end
if isempty(ranger2s)
    minR2s = 1/(20*max(te));
    maxR2s = 20/min(te);
    ranger2s = [minR2s, maxR2s];
end
    

A = 0;
for n=1:nTE-1
    tmp=0;
    for km=0:m
        tmp = tmp + p(:,:,:,n).^((m-km+1)/(m+1)) .* p(:,:,:,n+1).^(km/(m+1));
    end
    A = A+((te(n+1)-te(n))/(m-1) * tmp);
end

r2s = (p(:,:,:,1) - p(:,:,:,end))./ (2*(A-2*sigma.^2*(te(end)-te(1))));
t2s = 1./r2s;
%% Result preparation
% set range
r2s = SetImgRange(r2s,ranger2s);
t2s = SetImgRange(t2s,ranget2s);
    
% calculate m0
m0 = ComputeM0GivenR2star(r2s,te,img,m0mode);



end
