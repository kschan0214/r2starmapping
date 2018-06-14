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
function h = r2starGUI_handle_panel_r2sMethod_Trapezoidal(hParent,h,position)

%% Parent handle of Trapezoidal panel
h.r2sMethod.panel.Trapezoidal = uipanel(hParent,'Title','Trapezoidal',...
    'position',position,...
    'backgroundcolor',get(h.fig,'color'));

%% Children of Trapezoidal panel
    h.r2sMethod.Trapezoidal.text.s0 = uicontrol('Parent',h.r2sMethod.panel.Trapezoidal ,...
        'Style','text',...
        'String','S0 extrapolation:',...
        'units','normalized','position',[0.01 0.75 0.2 0.2],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Iteration stopping criteria on the coarsest grid');
    h.r2sMethod.Trapezoidal.popup.s0 = uicontrol('Parent',h.r2sMethod.panel.Trapezoidal,...
        'Style','popup',...
        'String',{'1st echo','Weighted sum','Averaging'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ; 


end