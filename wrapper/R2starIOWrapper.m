%% R2starMacroIOWrapper(inputFullname,output,te,varargin)
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
% Date modified: 14 June 2018
% Date modified: 27 May 2019
%
function R2starIOWrapper(input,output,mask_filename,algorParam)

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

%% Check and set default algorithm parameters
algorParam = CheckAndSetDefault(algorParam);
% generl algorithm parameters
method     	= algorParam.general.r2starMethod;
s0mode     	= algorParam.general.s0mode;
% R2star algorithm parameters
PImethod   	= algorParam.r2s.PImethod;
fitType   	= algorParam.r2s.fitType;
isParallel  = algorParam.r2s.isParallel;

%% load input
disp('Reading data...');

% get input data
inputFullname   = input(1).gre;
teFullName      = input(2).te;

% GRE data
inputGRENifti = load_untouch_nii(inputFullname);
gre = double(inputGRENifti.img);

% store the header the NIfTI files, all following results will have
% the same header
outputNiftiTemplate = inputGRENifti;

% read TE
if ischar(teFullName)
    % files input
    % re-organise TE file name variable to cell
    kInd = strfind(teFullName,';');
    if kInd ~= 0
        for kf = 1:length(kInd)
            if kf==1
                tmpName{kf} = teFullName(1:kInd(kf)-1);
            else
                tmpName{kf} = teFullName(kInd(kf-1)+1:kInd(kf)-1);
            end
        end
        teFullName = tmpName;
    else
        tmpName{1} = teFullName;
        teFullName = tmpName;
    end
    % get TE from file(s)
    TE = readEchoTime(teFullName);
else
    % user manual input
    TE = teFullName;
end

%% get mask (optional)
mask = [];
if ~isempty(mask_filename)
    inputMaskNifti = load_untouch_nii(mask_filename);
    mask = double(inputMaskNifti.img)>0;
end

%% convert GUI input to R2starMacro input
disp(['S0 extrapolation method: ' s0mode]);
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
        numMagn = length(TE);
    case 'complex'
        numMagn = 0;
    case 'mixed'
        numMagn = 1;
end

%% core
disp('Calculating T2*/R2*/S0 map...');

[r2s,t2s,s0] = R2starMacro(gre,TE,'method',method,PImethod,'s0mode',s0mode,...
    'mask',mask,'numMagn',numMagn,'parallel',isParallel);

% if mask provided then apply it here
if ~isempty(mask)
    r2s = single(r2s) .* single(mask);
    t2s = single(t2s) .* single(mask);
    s0  = single(s0)  .* single(mask);
end

%% save results
disp('Saving R2* map and S0 image ...');

save_nii_quick(outputNiftiTemplate,r2s,	[outputDir filesep prefix 'r2s.nii.gz']);
save_nii_quick(outputNiftiTemplate,t2s,	[outputDir filesep prefix 't2s.nii.gz']);
save_nii_quick(outputNiftiTemplate,s0,  [outputDir filesep prefix 's0.nii.gz']);

disp('Done!');

end

%% check and set all algorithm parameters
function algorParam2 = CheckAndSetDefault(algorParam)
algorParam2 = algorParam;

try algorParam2.general.r2starMethod	= algorParam.general.r2starMethod; 	catch; algorParam2.general.r2starMethod	= 'trapezoidal';	end
try algorParam2.general.s0mode          = algorParam.general.s0mode;        catch; algorParam2.general.s0mode   	= '1st echo';	end
try algorParam2.r2s.PImethod            = algorParam.r2s.PImethod;          catch; algorParam2.r2s.PImethod         = 'interleaved';    end
try algorParam2.r2s.fitType             = algorParam.r2s.fitType;           catch; algorParam2.r2s.fitType          = 'magnitude';    end
try algorParam2.r2s.isParallel        	= algorParam.r2s.isParallel;     	catch; algorParam2.r2s.isParallel      	= false;    end

end

%% get echo time from files
function TE = readEchoTime(teFullName)
        
    % get extension from input file
    [~,~,ext] = fileparts(teFullName{1});

    % extract TE based on input data extension
    switch lower(ext)
        case '.mat'
            % if mat file then try to load 'TE' directly
            try load(teFullName{1},'TE');  catch; error('No variable named ''TE''.'); end
        case '.txt'
            % if text file the try to read the TEs line by line
            TE = readTE_MRIConvert_Text(teFullName);
        case '.json'
            % JSON file(s)
            TE = readTE_JSON(teFullName);
    end
    TE = TE(:).';
end
