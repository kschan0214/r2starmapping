%% h = r2starGUI_handle_panel_r2sMethod_Trapezoidal(hParent,h,position)
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
% Description: This GUI function creates a panel  
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 12 June 2018
% Date last modified: 
%
%
function h = r2starGUI_handle_panel_r2sMethod_ARLO(hParent,h,position)

%% Parent handle of Trapezoidal panel
h.r2sMethod.panel.ARLO = uipanel(hParent,...
    'Title','ARLO',...
    'position',position,...
    'backgroundcolor',get(h.fig,'color'),'Visible','off');

%% Children of Trapezoidal panel
    h.r2sMethod.ARLO.text.s0 = uicontrol('Parent',h.r2sMethod.panel.ARLO ,...
        'Style','text',...
        'String','S0 extrapolation:',...
        'units','normalized','position',[0.01 0.75 0.2 0.2],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'));
    h.r2sMethod.ARLO.popup.s0 = uicontrol('Parent',h.r2sMethod.panel.ARLO,'Style','popup',...
    'String',{'1st echo','Weighted sum','Averaging'},...
    'units','normalized','position',[0.31 0.85 0.4 0.1]) ;


end