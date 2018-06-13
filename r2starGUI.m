%% r2starGUI
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
% Date created: 21 April 2018
% Date last modified:
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
rh.pushbutton_start = uicontrol('Parent',rh.fig,'Style','pushbutton',...
    'String','Start',...
    'units','normalized','Position',[0.85 0.01 0.1 0.05],...
    'backgroundcolor',get(rh.fig,'color'));

%% Set Callback functions
rh = SetAllCallbacks(rh);

end

%% utils functions
function h=SetAllCallbacks(h)

set(h.dataIO.button.input,      'Callback', {@ButtonOpen_Callback,'input'});
set(h.dataIO.button.output,    	'Callback', {@ButtonOpen_Callback,'output'});
set(h.dataIO.button.maskdir,   	'Callback', {@ButtonOpen_Callback,'mask'});
set(h.dataIO.button.teFile,    	'Callback', {@ButtonOpen_Callback,'te'});
set(h.r2sMethod.popup.method,  	'Callback', {@Popupr2sMethod_Callback});
set(h.pushbutton_start,        	'Callback', {@PushbuttonStart_Callback});

end

%% Callbacks
function ButtonOpen_Callback(source,eventdata,field)
% get directory and display it on GUI

global rh

switch field
    case 'te'
        % te file can be text file or mat file
        [tefileName,pathDir] = uigetfile({'*.mat;*.txt'},'Select TE file');
        
        % display file directory
        if pathDir ~= 0
            set(rh.dataIO.edit.teFile,'String',fullfile(pathDir,tefileName));
        end

    case 'mask'
        % only read NIfTI file for mask
        [maskfileName,pathDir] = uigetfile({'*.nii;*.nii.gz','NIfTI file (*.nii,*.nii.gz)'},'Select mask file');

        if pathDir ~= 0
            set(rh.dataIO.edit.maskdir,'String',fullfile(pathDir,maskfileName));
        end
        
    case 'input'
        % get directory for NIfTI files
        [greFileName,pathDir] = uigetfile({'*.nii;*.nii.gz','NIfTI file (*.nii,*.nii.gz)'},'Select multi-echo GER file');

        if pathDir ~= 0
            % set input edit field for display
            set(rh.dataIO.edit.input,'String',fullfile(pathDir,greFileName));
            % automatically set default output field
            set(rh.dataIO.edit.output,   'String',[pathDir filesep 'output']);
        end
        
    case 'output'
        % get directory for output
        pathDir = uigetdir;

        if pathDir ~= 0
            set(rh.dataIO.edit.output,'String',pathDir);
        end
end

end

function Popupr2sMethod_Callback(source,eventdata)
% display corresponding R2* method's panel

global rh

% get selected R2* method
method = source.String{source.Value,1} ;

% switch off all panels
fields = fieldnames(rh.r2sMethod.panel);
for kf = 1:length(fields)
    set(rh.r2sMethod.panel.(fields{kf}),    'Visible','off');
end

% switch on target panel
switch method
    case 'Trapezoidal'
        set(rh.r2sMethod.panel.Trapezoidal,	'Visible','on');

    case 'ARLO'
        set(rh.r2sMethod.panel.ARLO,     	'Visible','on');

    case 'Geometric sum'
        set(rh.r2sMethod.panel.GS,          'Visible','on');

    case 'Sequence of product'
        set(rh.r2sMethod.panel.PI,          'Visible','on');

    case 'Regression'
        set(rh.r2sMethod.panel.Regression,	'Visible','on');

    case 'Non-linear least square'
        set(rh.r2sMethod.panel.NLLS,        'Visible','on');

end

end

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
outputDir       = get(rh.dataIO.edit.output,'String');
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
        try s0mode   	= rh.r2sMethod.Trapezoidal.popup.s0.String{rh.r2sMethod.Trapezoidal.popup.s0.Value,1};	catch; s0mode='1st echo';       end
    case 'ARLO'
        method = 'arlo';
        try s0mode   	= rh.r2sMethod.ARLO.popup.s0.String{rh.r2sMethod.ARLO.popup.s0.Value,1};                catch; s0mode='1st echo';       end
    case 'Geometric sum'
        method = 'gs';
        try s0mode   	= rh.r2sMethod.GS.popup.s0.String{rh.r2sMethod.GS.popup.s0.Value,1};                    catch; s0mode='1st echo';       end
    case 'Sequence of product'
        method = 'pi';
        try s0mode   	= rh.r2sMethod.PI.popup.s0.String{rh.r2sMethod.PI.popup.s0.Value,1};                    catch; s0mode='1st echo';       end
        try PImethod    = rh.r2sMethod.PI.popup.method.String{rh.r2sMethod.PI.popup.method.Value,1};            catch; PImethod='interleaved';	end
    case 'Regression'
        method = 'regression';
        
    case 'Non-linear least square'
        method = 'nlls';
        try fitType   	= rh.r2sMethod.NLLS.popup.fitType.String{rh.r2sMethod.NLLS.popup.fitType.Value,1};      catch; fitType='magnitude';     end
        try isParallel = get(h.r2sMethod.NLLS.checkbox.isParallel,'Value');                                     catch; isParallel = false;      end
end

%% run 
R2starMacroIOWrapper(greFullName,outputDir,TE,'mask',maskFullName,'method',method,...
    's0mode',s0mode,'PImethod',PImethod,'fit',fitType,'parallel',isParallel);

% generate a log file
GenerateLogFile;

    function GenerateLogFile
        fid = fopen([outputDir filesep 'r2starGUI.log'],'w');
        fprintf(fid,'R2starMacroIOWrapper(''%s'',''%s'',[%s],''mask'',''%s'',''method'',''%s'',...\n',greFullName,outputDir,num2str(TE(:).'),maskFullName,method);
        fprintf(fid,'''s0mode'',''%s'',''PImethod'',''%s'',''fit'',''%s'',''paralle'',%i);\n',s0mode,PImethod,fitType,isParallel);
        fclose(fid);
    end


end