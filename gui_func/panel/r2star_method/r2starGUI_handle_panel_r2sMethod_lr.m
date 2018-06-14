%% h = r2starGUI_handle_panel_r2sMethod_lr(hParent,h,position)
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
function h = r2starGUI_handle_panel_r2sMethod_lr(hParent,h,position)

%% Parent handle of panel
h.r2sMethod.panel.Regression = uipanel(hParent,...
    'Title','Regression',...
    'position',position,...
    'backgroundcolor',get(h.fig,'color'),'Visible','off');
%         h.r2sMethod.regression.checkbox.isParallel = uicontrol('Parent',h.r2sMethod.panel.Regression,'Style','checkbox',...
%             'String','Enable parallel computing (parfor)',...
%             'units','normalized','position',[0.01 0.75 0.98 0.2]);

end