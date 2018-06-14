%% r2starGUI
%
% Description: This is a GUI to compute T2*/R2*/S0 maps/image for multi-echo GRE data
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 21 April 2018
% Date last modified: 14 June 2018
%
%
function r2starGUI

clear 

global rh

%% add path
R2star_AddPath;

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
    'MenuBar','None','Toolbar','None','Name','R2* mapping','NumberTitle','off');

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
% set(source,'Enable','off');

%% initialise all possible parameters
s0mode      = '1stecho';
PImethod    = 'interleaved';
isParallel  = false;
fitType     = 'magnitude';
TE          = [];

%% get I/O GUI input
greFullName   	= get(rh.dataIO.edit.input,'String');
outputBasename  = get(rh.dataIO.edit.output,'String');
maskFullName    = get(rh.dataIO.edit.maskdir,'String');

% try to get TE variable in this stage
teFullName    	= get(rh.dataIO.edit.teFile,'String');
if ~isempty(teFullName)
    % get data type
    [~,~,ext] = fileparts(teFullName);
    
    if strcmpi(ext,'.mat')
        % if mat file then try to load 'TE' directly
        try load(teFullName,'TE');  catch; error('No variable named TE.'); end
    else
        % if text file the try to read the TEs line by line
        TE = readTEfromText(teFullName);
        TE = TE(:);
    end
else
    % read user input array
    TE = str2num(get(rh.dataIO.edit.userTE,'String'));
    TE = TE(:);
end
% in case TE cannot be found
if isempty(TE) || isnan(TE(1))
    error('Incorrect TE format.');
end

%% get R2* method GUI input
r2starMethod     = rh.r2sMethod.popup.method.String{rh.r2sMethod.popup.method.Value,1};

switch r2starMethod
    case 'Trapezoidal'
        method='trapezoidal';
        s0mode   	= rh.r2sMethod.Trapezoidal.popup.s0.String{rh.r2sMethod.Trapezoidal.popup.s0.Value,1};
        
    case 'ARLO'
        method = 'arlo';
        s0mode   	= rh.r2sMethod.ARLO.popup.s0.String{rh.r2sMethod.ARLO.popup.s0.Value,1};
        
    case 'Geometric sum'
        method = 'gs';
        s0mode   	= rh.r2sMethod.GS.popup.s0.String{rh.r2sMethod.GS.popup.s0.Value,1};
        
    case 'Sequence of product'
        method = 'pi';
        s0mode   	= rh.r2sMethod.PI.popup.s0.String{rh.r2sMethod.PI.popup.s0.Value,1};
        PImethod    = rh.r2sMethod.PI.popup.method.String{rh.r2sMethod.PI.popup.method.Value,1};
        
    case 'Linear regression'
        method = 'regression';
        
    case 'Non-linear least square'
        method = 'nlls';
        fitType   	= rh.r2sMethod.NLLS.popup.fitType.String{rh.r2sMethod.NLLS.popup.fitType.Value,1}; 
        isParallel = get(h.r2sMethod.NLLS.checkbox.isParallel,'Value');
        
end

%% run 
R2starMacroIOWrapper(greFullName,...
                     outputBasename,...
                     TE,...
                     'mask',maskFullName,...
                     'method',method,...
                     's0mode',s0mode,'PImethod',PImethod,'fit',fitType,'parallel',isParallel);

% get output directory
output_index = strfind(outputBasename, filesep);
outputDir = outputBasename(1:output_index(end));

% generate a log file
GenerateLogFile;

    function GenerateLogFile
        fid = fopen([outputDir filesep 'r2starGUI.log'],'w');
        fprintf(fid,'R2starMacroIOWrapper(''%s'',...\n',greFullName);
        fprintf(fid,'''%s'',...\n',outputBasename);
        fprintf(fid,'[%s],...\n',num2str(TE(:).'));
        fprintf(fid,'''mask'',''%s'',...\n',maskFullName);
        fprintf(fid,'''method'',''%s'',...\n',method);
        fprintf(fid,'''s0mode'',''%s'',''PImethod'',''%s'',''fit'',''%s'',''parallel'',%i);\n',s0mode,PImethod,fitType,isParallel);
        fclose(fid);
    end


end