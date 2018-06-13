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
% Date last modified: 12 June 2018
%
%
function h = r2starGUI_handle_panel_r2sMethod(hParent,h,position)
% Parent handle
h.StepsPanel.r2sMethod = uipanel(hParent,...
    'Title','R2* mapping',...
    'position',[position(1) position(2) 0.98 0.3],...
    'backgroundcolor',get(h.fig,'color'));
    
    % popup menu
    h.r2sMethod.text.method = uicontrol('Parent',h.StepsPanel.r2sMethod,'Style','text','String','Method:',...
        'units','normalized','position',[0.01 0.85 0.3 0.1],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Select background field removal method');
    h.r2sMethod.popup.method = uicontrol('Parent',h.StepsPanel.r2sMethod,'Style','popup',...
        'String',{'Trapezoidal','ARLO','Geometric sum','Sequence of product','Regression','Non-linear least square'},...
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
        
    % Regression, empty panel 
    h = r2starGUI_handle_panel_r2sMethod_lr(h.StepsPanel.r2sMethod,...
                                                            h,position_child);

    % lsqnonlin    
    h = r2starGUI_handle_panel_r2sMethod_NLLS(h.StepsPanel.r2sMethod,...
                                                            h,position_child);
    
    
end