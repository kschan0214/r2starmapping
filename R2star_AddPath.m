function R2star_AddPath

% get the full path of this file
fullName = mfilename('fullpath');
currDir = fileparts(fullName);

addpath(currDir);

% keep GUI and macro directories
addpath([currDir filesep 'utils/']);
addpath([currDir filesep 'lsq/']);
addpath([currDir filesep 'ClosedFormSolution/']);

end