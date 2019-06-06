function R2star_AddPath

% get the full path of this file
fullName = mfilename('fullpath');
currDir = fileparts(fullName);

addpath(currDir);

% keep GUI and macro directories
utilsDir = [currDir filesep 'utils/'];
addpath(utilsDir);
addpath(genpath([utilsDir 'nifti/']));

addpath(genpath([currDir filesep 'gui_func/']));
addpath(genpath([currDir filesep 'wrapper/']));

addpath([currDir filesep 'lsq/']);
addpath([currDir filesep 'ClosedFormSolution/']);

end