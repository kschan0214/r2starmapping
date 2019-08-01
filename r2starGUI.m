%% r2starGUI
%
% Description: This is a GUI to compute T2*/R2*/S0 maps/image for multi-echo GRE data
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 21 April 2018
% Date modified: 14 June 2018
% Date modified: 27 May 2019
%
%
function r2starGUI

clear 

global rh

%% add path
r2star_addpath;

%% set GUI window size
screenSize = get(0,'ScreenSize');
posLeft = round(screenSize(3)/4);
posBottom = round(screenSize(4)/6);
guiSizeHori = round(screenSize(3)/3);
guiSizeVert = round(screenSize(4)*2/3);
if guiSizeHori < 750
    guiSizeHori = 750;
end
if guiSizeVert < 350
    guiSizeVert = 350;
end

% create GUI 
rh.fig=figure('Units','pixels','position',[posLeft posBottom guiSizeHori guiSizeVert],...
    'MenuBar','None','Toolbar','None','Name','R2* mapping toolbox (v0.2.0)','NumberTitle','off');

%% I/O panel
rh = r2starGUI_handle_panel_dataIO(rh.fig,rh,[0.01 0.7]);

%% R2* method panel
rh = r2starGUI_handle_panel_r2sMethod(rh.fig,rh,[0.01 0.4]);

%% Start button
rh.pushbutton_start = uicontrol('Parent',rh.fig,...
    'Style','pushbutton',...
    'String','Start',...
    'units','normalized','Position',[0.85 0.01 0.1 0.05],...
    'backgroundcolor',get(rh.fig,'color'));

%% Set Callback functions
set(rh.pushbutton_start, 'Callback', {@PushbuttonStart_Callback});

end

%% Callback
function PushbuttonStart_Callback(source,eventdata)

global rh

% Disable the pushbutton to prevent doubel click
set(source,'Enable','off');

%% get I/O GUI input
greFullName   	= get(rh.dataIO.edit.input,'String');
outputBasename  = get(rh.dataIO.edit.output,'String');
maskFullName    = get(rh.dataIO.edit.maskdir,'String');
% try TE file name first
teFullName    	= get(rh.dataIO.edit.teFile,'String');
if isempty(teFullName)
    % if not file then load user input
    teFullName = get(rh.dataIO.edit.userTE,'String');
end
% in case no TE input
if isempty(teFullName)
    error('No TE information is found!');
end
% get R2* method GUI input
r2starMethod     = rh.r2sMethod.popup.method.String{rh.r2sMethod.popup.method.Value,1};

% get and create output directory
output_index = strfind(outputBasename, filesep);
outputDir = outputBasename(1:output_index(end));
% if the output directory does not exist then create the directory
if exist(outputDir,'dir') ~= 7
    mkdir(outputDir);
end

% create a new m file
logFilename = [outputDir filesep 'r2starGUI_log.m'];
if exist(logFilename,'file') == 2
    counter = 1;
    while exist(logFilename,'file') == 2
        suffix = ['_' num2str(counter)];
        logFilename = [outputDir filesep 'r2starGUI_log' suffix '.m'];
        counter = counter + 1;
    end
end
fid = fopen(logFilename,'w');

% general path
fprintf(fid,'%% add general Path\n');
fprintf(fid,'r2star_addpath\n\n');

% input data
fprintf(fid,'input(1).gre = ''%s'' ;\n' ,greFullName);
if isempty(str2num(teFullName))
    fprintf(fid,'input(2).te  = ''%s'' ;\n',teFullName);
else
    fprintf(fid,'input(2).te  = %s ;\n',teFullName);
end

% output
fprintf(fid,'output_basename = ''%s'' ;\n',outputBasename);

% mask
fprintf(fid,'mask_filename = [''%s''] ;\n\n',maskFullName);

% algorithm parameters
fprintf(fid,'%% Algorithm parameters\n');
switch r2starMethod
    case 'Trapezoidal'
        fprintf(fid,'algorParam.general.r2starMethod = ''trapezoidal'' ;\n');
        fprintf(fid,'algorParam.general.s0mode = ''%s'' ;\n', ...
            rh.r2sMethod.Trapezoidal.popup.s0.String{rh.r2sMethod.Trapezoidal.popup.s0.Value,1});
        
    case 'ARLO'
        fprintf(fid,'algorParam.general.r2starMethod = ''arlo'' ;\n');
        fprintf(fid,'algorParam.general.s0mode = ''%s'' ;\n', ...
            rh.r2sMethod.ARLO.popup.s0.String{rh.r2sMethod.ARLO.popup.s0.Value,1});
      
    case 'Geometric sum'
        fprintf(fid,'algorParam.general.r2starMethod = ''gs'' ;\n');
        fprintf(fid,'algorParam.general.s0mode = ''%s'' ;\n', ...
            rh.r2sMethod.GS.popup.s0.String{rh.r2sMethod.GS.popup.s0.Value,1});
        
    case 'Sequence of product'
        fprintf(fid,'algorParam.general.r2starMethod = ''pi'' ;\n');
        fprintf(fid,'algorParam.general.s0mode = ''%s'' ;\n', ...
            rh.r2sMethod.PI.popup.s0.String{rh.r2sMethod.PI.popup.s0.Value,1});
        fprintf(fid,'algorParam.r2s.PImethod = ''%s'' ;\n', ...
            rh.r2sMethod.PI.popup.method.String{rh.r2sMethod.PI.popup.method.Value,1});
        
    case 'Linear regression'
        fprintf(fid,'algorParam.general.r2starMethod = ''regression'' ;\n');
        
    case 'Non-linear least square'
        fprintf(fid,'algorParam.general.r2starMethod = ''nlls'' ;\n');
        fprintf(fid,'algorParam.r2s.fitType = ''%s'' ;\n', ...
            rh.r2sMethod.NLLS.popup.fitType.String{rh.r2sMethod.NLLS.popup.fitType.Value,1});
        fprintf(fid,'algorParam.r2s.isParallel = %i ;\n', ...
            get(h.r2sMethod.NLLS.checkbox.isParallel,'Value'));
end

fprintf(fid,'\nR2starMacroIOWrapper(input,output_basename,mask_filename,algorParam);\n');

fclose(fid);

try
% run process
run(logFilename);

% re-enable the pushbutton
set(source,'Enable','on');

catch ME
    % re-enable the start button before displaying the error
    set(source,'Enable','on');

    rethrow(ME);
end


end