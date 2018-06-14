%% [r2s,t2s,s0] = R2starMacroIOWrapper(inputFullname,output,te,varargin)
%
% Input
% --------------
% inputFullname : input NIfTI files 
% output    	: output directory with output basename (R2* map and S0 image)
% varargin ('Name','Value' pair)
% ---------
% 'mask'      	: mask file (in NIfTI format) full name 
% 'method'      : R2* mapping method ('trapezoidal', 'gs', 'arlo', 'pi', 'regression', 'nlls')
% 's0mode'      : method to extrapolate S0 ('1st echo','weighted sum' or 'averaging')
% 'PImethod'    : option for using sequence of product method
% 'fit'         : fitting method ('magnitude,'complex','mixed')
% 'parallel'    : parfor option
%
% Output
% --------------
% r2s           : R2* map
% t2s           : T2* map
% s0            : extrapolated signal at TE=0
%
% Description: This is a wrapper of R2starMacro.m which has the following objeectives:
%               (1) matches the input format of r2starGUI.m
%               (2) save the results in NIfTI format
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 21 April 2018
% Date last modified: 14 June 2018
%
%
function [r2s,t2s,s0] = R2starMacroIOWrapper(inputFullname,output,te,varargin)

%% define variables
prefix = 'squirrel_';

%% Check if output directory exists 
output_index = strfind(output, filesep);
outputDir = output(1:output_index(end));
if ~isempty(output(output_index(end)+1:end))
    prefix = [output(output_index(end)+1:end) '_'];
end

if exist(outputDir,'dir') ~= 7
    % if not then create the directory
    mkdir(outputDir);
end

%% Parse input argument
[maskFullname,method,PImethod,s0mode,fitType,isParallel]=parse_varargin(varargin);

% convert GUI input to R2starMacro input
switch lower(s0mode)
    case '1st echo'
        s0mode = '1stecho';
    case 'weighted sum'
        s0mode = 'weighted';
    case 'averaging'
        s0mode = 'average';
end

switch lower(fitType)
    case 'magnitude'
        numMagn = length(te);
    case 'complex'
        numMagn = 0;
    case 'mixed'
        numMagn = 1;
end


%% load GRE input
disp('Reading data...');

inputGRENifti = load_untouch_nii(inputFullname);
gre = double(inputGRENifti.img);

% store the header the NIfTI files, all following results will have
% the same header
outputNiftiTemplate = inputGRENifti;

%% get mask (optional)
mask = [];
if ~isempty(maskFullname)
    inputMaskNifti = load_untouch_nii(maskFullname);
    mask = double(inputMaskNifti.img)>0;
end

%% core
disp('Calculating R2* map...');

[r2s,t2s,s0] = R2starMacro(gre,te,'method',method,PImethod,'s0mode',s0mode,...
    'mask',mask,'numMagn',numMagn,'parallel',isParallel);

% if mask provided then apply it here
if ~isempty(mask)
    r2s = r2s .* mask;
    t2s = t2s .* mask;
    s0  = s0  .* mask;
end

%% save results
disp('Saving R2* map and S0 image ...');

save_nii_quick(outputNiftiTemplate,r2s,	[outputDir filesep prefix 'r2s.nii.gz']);
save_nii_quick(outputNiftiTemplate,t2s,	[outputDir filesep prefix 't2s.nii.gz']);
save_nii_quick(outputNiftiTemplate,s0,  [outputDir filesep prefix 's0.nii.gz']);

disp('Done!');

end

%% parse input argument
function [maskFullname,method,PImethod,s0mode,fitType,isParallel]=parse_varargin(arg)
maskFullname = [];
method = 'trapezoidal';
PImethod = 'interleaved';
s0mode = '1st echo';
fitType = [];
isParallel = false;

if ~isempty(arg)
    for kvar = 1:length(arg)
        if strcmpi(arg{kvar},'mask')
            maskFullname = arg{kvar+1};
        end
        if strcmpi(arg{kvar},'method')
            method = arg{kvar+1};
        end
        if strcmpi(arg{kvar},'s0mode')
            s0mode = arg{kvar+1};
        end
        if strcmpi(arg{kvar},'PImethod')
            PImethod = arg{kvar+1};
        end
        if strcmpi(arg{kvar},'fit')
            fitType = arg{kvar+1};
        end
        if strcmpi(arg{kvar},'parallel')
            isParallel = arg{kvar+1};
        end
    end
end

end
