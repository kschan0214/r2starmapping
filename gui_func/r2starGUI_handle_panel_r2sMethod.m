%% h = r2starGUI_handle_panel_r2sMethod(hParent,hFig,h,position)
%
% Input
% --------------
% hParent       : parent handle of this panel
% hFig          : handle of the GUI
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
% Date last modified: 22 April 2018
%
%
function h = r2starGUI_handle_panel_r2sMethod(hParent,hFig,h,position)
h.StepsPanel.r2sMethod = uipanel(hParent,'Title','R2* mapping',...
    'position',[position(1) position(2) 0.95 0.25],...
    'backgroundcolor',get(hFig,'color'));
    h.r2sMethod.text.method = uicontrol('Parent',h.StepsPanel.r2sMethod,'Style','text','String','Method:',...
        'units','normalized','position',[0.01 0.85 0.3 0.1],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Select background field removal method');
    h.r2sMethod.popup.method = uicontrol('Parent',h.StepsPanel.r2sMethod,'Style','popup',...
        'String',{'Trapezoidal','ARLO','Geometric sum','Sequence of product','Regression','Non-linear least square'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ;   
    
    % Trapezoidal
    h.r2sMethod.panel.Trapezoidal = uipanel(h.StepsPanel.r2sMethod,'Title','Trapezoidal',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'));
        h.r2sMethod.Trapezoidal.text.s0 = uicontrol('Parent',h.r2sMethod.panel.Trapezoidal ,'Style','text',...
            'String','S0 extrapolation:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Iteration stopping criteria on the coarsest grid');
        h.r2sMethod.Trapezoidal.popup.s0 = uicontrol('Parent',h.r2sMethod.panel.Trapezoidal,'Style','popup',...
        'String',{'1st echo','Weighted sum','Averaging'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ; 

    % ARLO
    h.r2sMethod.panel.ARLO = uipanel(h.StepsPanel.r2sMethod,'Title','ARLO',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.r2sMethod.ARLO.text.s0 = uicontrol('Parent',h.r2sMethod.panel.ARLO ,'Style','text',...
            'String','S0 extrapolation:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Iteration stopping criteria on the coarsest grid');
        h.r2sMethod.ARLO.popup.s0 = uicontrol('Parent',h.r2sMethod.panel.ARLO,'Style','popup',...
        'String',{'1st echo','Weighted sum','Averaging'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ;
        
    % Geometric sum
    h.r2sMethod.panel.GS = uipanel(h.StepsPanel.r2sMethod,'Title','Geometric sum',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.r2sMethod.GS.text.s0 = uicontrol('Parent',h.r2sMethod.panel.GS ,'Style','text',...
            'String','S0 extrapolation:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Iteration stopping criteria on the coarsest grid');
        h.r2sMethod.GS.popup.s0 = uicontrol('Parent',h.r2sMethod.panel.GS,'Style','popup',...
        'String',{'1st echo','Weighted sum','Averaging'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ;
    
    % Sequence of product    
    h.r2sMethod.panel.PI = uipanel(h.StepsPanel.r2sMethod,'Title','Sequence of product',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.r2sMethod.PI.text.s0 = uicontrol('Parent',h.r2sMethod.panel.PI ,'Style','text',...
            'String','S0 extrapolation:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Iteration stopping criteria on the coarsest grid');
        h.r2sMethod.PI.popup.s0 = uicontrol('Parent',h.r2sMethod.panel.PI,'Style','popup',...
        'String',{'1st echo','Weighted sum','Averaging'},...
        'units','normalized','position',[0.31 0.75 0.4 0.2]) ;
        h.r2sMethod.PI.text.method = uicontrol('Parent',h.r2sMethod.panel.PI ,'Style','text',...
            'String','Method:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Iteration stopping criteria on the coarsest grid');
        h.r2sMethod.PI.popup.method = uicontrol('Parent',h.r2sMethod.panel.PI,'Style','popup',...
        'String',{'1st echo','interleaved'},...
        'units','normalized','position',[0.31 0.5 0.4 0.2]) ;
        
    % Regression    
    h.r2sMethod.panel.Regression = uipanel(h.StepsPanel.r2sMethod,'Title','Regression',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
%         h.r2sMethod.regression.checkbox.isParallel = uicontrol('Parent',h.r2sMethod.panel.Regression,'Style','checkbox',...
%             'String','Enable parallel computing (parfor)',...
%             'units','normalized','position',[0.01 0.75 0.98 0.2]);

    % lsqnonlin    
    h.r2sMethod.panel.NLLS = uipanel(h.StepsPanel.r2sMethod,'Title','Non-linear least square',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.r2sMethod.NLLS.text.fitType = uicontrol('Parent',h.r2sMethod.panel.NLLS,'Style','text',...
            'String','Type of data fitting',...
            'units','normalized','position',[0.01 0.75 0.3 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.r2sMethod.NLLS.popup.fitType = uicontrol('Parent',h.r2sMethod.panel.NLLS,'Style','popup',...
        'String',{'Magnitude','Complex','Mixed'},...
        'units','normalized','position',[0.31 0.75 0.2 0.2]) ;
    
        h.r2sMethod.NLLS.checkbox.isParallel = uicontrol('Parent',h.r2sMethod.panel.NLLS,'Style','checkbox',...
            'String','Enable parallel computing (parfor)',...
            'units','normalized','position',[0.01 0.5 0.98 0.2]);
    
    
end