%% h = r2starGUI_handle_panel_r2sMethod(hParent,h,position)
%
% Input
% --------------
% hParent       : parent handle of this panel
% h             : global structure contains all handles
% position      : position of this panel
%
% Output
% --------------
% h             : global structure contains all new and other handles
%
% Description: This GUI function creates a panel for R2* method control
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 21 April 2018
% Date last modified: 14 June 2018
%
%
function h = r2starGUI_handle_panel_r2sMethod(hParent,h,position)

methodName = {'Trapezoidal','ARLO','Geometric sum','Sequence of product',...
                'Linear regression','Non-linear least square'};

% Parent handle
h.StepsPanel.r2sMethod = uipanel(hParent,...
    'Title','R2* mapping',...
    'position',[position(1) position(2) 0.98 0.3],...
    'backgroundcolor',get(h.fig,'color'));
    
    % text/popup: R2* method menu
    h.r2sMethod.text.method = uicontrol('Parent',h.StepsPanel.r2sMethod,'Style','text','String','Method:',...
        'units','normalized','position',[0.01 0.85 0.3 0.1],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Select background field removal method');
    h.r2sMethod.popup.method = uicontrol('Parent',h.StepsPanel.r2sMethod,'Style','popup',...
        'String',methodName,...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ;   
    
    position_child = [0.01 0.15 0.95 0.65];
    
    % Trapezoidal
    h = r2starGUI_handle_panel_r2sMethod_Trapezoidal(h.StepsPanel.r2sMethod,...
                                                            h,position_child);

    % ARLO
    h = r2starGUI_handle_panel_r2sMethod_ARLO(h.StepsPanel.r2sMethod,...
                                                            h,position_child);
        
    % Geometric sum
    h = r2starGUI_handle_panel_r2sMethod_GS(h.StepsPanel.r2sMethod,...
                                                            h,position_child);
    
    % Sequence of product
    h = r2starGUI_handle_panel_r2sMethod_PI(h.StepsPanel.r2sMethod,...
                                                            h,position_child);
        
    % Linear regression, empty panel 
    h = r2starGUI_handle_panel_r2sMethod_lr(h.StepsPanel.r2sMethod,...
                                                            h,position_child);

    % lsqnonlin    
    h = r2starGUI_handle_panel_r2sMethod_NLLS(h.StepsPanel.r2sMethod,...
                                                            h,position_child);
    
    
% set callback
set(h.r2sMethod.popup.method, 'Callback', {@Popupr2sMethod_Callback,h});

end

%% Callback
function Popupr2sMethod_Callback(source,eventdata,h)
% display corresponding R2* method's panel

% get selected R2* method
method = source.String{source.Value,1} ;

% switch off all panels
fields = fieldnames(h.r2sMethod.panel);
for kf = 1:length(fields)
    set(h.r2sMethod.panel.(fields{kf}),     'Visible','off');
end

% switch on target panel
switch method
    case 'Trapezoidal'
        set(h.r2sMethod.panel.Trapezoidal,	'Visible','on');

    case 'ARLO'
        set(h.r2sMethod.panel.ARLO,     	'Visible','on');

    case 'Geometric sum'
        set(h.r2sMethod.panel.GS,           'Visible','on');

    case 'Sequence of product'
        set(h.r2sMethod.panel.PI,           'Visible','on');

    case 'Linear regression'
        set(h.r2sMethod.panel.Regression,	'Visible','on');

    case 'Non-linear least square'
        set(h.r2sMethod.panel.NLLS,         'Visible','on');

end

end