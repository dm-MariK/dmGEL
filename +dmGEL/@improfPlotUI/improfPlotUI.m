% Copyright (c) 2025 Denis I. Markov aka MariK
% < dm DOT marik DOT 230185 AT gmail DOT com >
% < t DOT me / dm_MariK >
% This work is licensed under the Creative Commons Attribution-ShareAlike
% 4.0 International License. 
%
classdef  improfPlotUI < matlab.mixin.SetGet
    %% Properties definition
    properties (Constant)
        CLASS = 'dmGEL.improfPlotUI';
        DATA_VERSION = 1;
        PROPS2SAVE ={'FigName', ...
            'BGCorrectedImg', ...
            'SelectionImg', ...
            'PflsHorizontal', ...
            'PflsVertCentral', ...
            'PflsVertLeft', ...
            'PflsVertRight', ...
            'YCntr', ...
            'XCntr', ...
            'XLeft', ...
            'XRight'};
    end % properties (Constant)

    properties
        %% To keep calculated data
        FigName = dmGEL.Constants.ImprofPlotInitFigName; % the Figure's Name 
        BGCorrectedImg;  % copy of BGCorrectedImg from the GelDataObj
        SelectionImg;    % to keep prepared Img displaying the selection on the gel
        PflsHorizontal;  % horizontal improfiles through the selection center
        PflsVertCentral; % vertical improfiles through the selection center
        PflsVertLeft;    % vertical improfiles through the left part of the selection
        PflsVertRight;   % vertical improfiles through the right part of the selection
        % Profiles' coordinates:
        YCntr;
        XCntr;
        XLeft;
        XRight;
    end % properties

    properties (Transient = true)
        %% HG-handles
        hFig;

        % Axes layout would be:
        %    (1)[gel] (3)[improfiles] (5)[improfiles]
        %    (2)[gel] (4)[improfiles] (6)[improfiles]
        hAxes_1; % to show BGCorrectedImg
        hAxes_2; % to show Image representing user's selection
        hAxes_3;
        hAxes_4;
        hAxes_5;
        hAxes_6;
        
        hPlot_3; % array of Line objects on hAxes_3 (for PflsVertCentral)
        hPlot_4; % array of Line objects on hAxes_4 (for PflsVertLeft)
        hPlot_5; % array of Line objects on hAxes_5 (for PflsHorizontal)
        hPlot_6; % array of Line objects on hAxes_6 (for PflsVertRight)

        % 'DATA' main menu with its Items
        hDataMenu;
        hRebuildChartsItem;
        hExportProfilesItem;

        % 'Preserve me!' main menu with its Items
        hPreserveMenu;
        hPreserveItem;

        % Handle to the gelui obj whose method called the constructor of this improfPlotUI obj
        Hgelui = [];
    end % properties (Transient = true)

    properties(Transient = true, AbortSet = true)
        %% The Axes layout parameters - all are of 'Units', 'normalized'
        TileHeight = dmGEL.Constants.AxesTileHeight; %0.5;%
        GelTileWidth = dmGEL.Constants.AxesGelTileWidth; %0.33;%

        % Subplots' padding: Relative to Tile's dimentions but NOT as fractions of them.
        GelAxesPad = dmGEL.Constants.GelAxesPad; %0.005; % all - left, right, top, bottom
        PlotAxesRight = dmGEL.Constants.PlotAxesRight; %0.01;%
        PlotAxesTop = dmGEL.Constants.PlotAxesTop; %0.015;%
        %  --- additional space for X- and Y-axis labels ---
        PlotAxesLshift = dmGEL.Constants.PlotAxesLshift; %0.01;% % Left shift
        PlotAxesVshift = dmGEL.Constants.PlotAxesVshift; %0.01;% % Vertical shift
    end % properties(Transient = true, AbortSet = true)
    % ====================================================================

    %% Mmethods definition
    methods
        %% Set up location and sizing of the Axes
        function layoutAxes(obj)
            %% Axes 1 - left top - BG-corrected gel img
            a1l = obj.GelAxesPad;
            a1b = obj.TileHeight + obj.GelAxesPad;
            a1w = obj.GelTileWidth - 2 * obj.GelAxesPad;
            a1h = obj.TileHeight - 2 * obj.GelAxesPad;
            set(obj.hAxes_1, 'Units', 'normalized', ...
                'Position', [a1l, a1b, a1w, a1h]);
            %% Axes 2 - left bottom - BG-corrected gel img applied by with the mask
            a2l = obj.GelAxesPad;
            a2b = obj.GelAxesPad;
            a2w = obj.GelTileWidth - 2 * obj.GelAxesPad;
            a2h = obj.TileHeight - 2 * obj.GelAxesPad;
            set(obj.hAxes_2, 'Units', 'normalized', ...
                'Position', [a2l, a2b, a2w, a2h]);
            %% Axes 3 - middle top - improfiles ...
            plotTileWidth = (1 - obj.GelTileWidth)/2;
            a3l = obj.GelTileWidth + obj.PlotAxesRight + obj.PlotAxesLshift;
            a3b = obj.TileHeight + obj.PlotAxesTop + obj.PlotAxesVshift;
            a3w = plotTileWidth - 2*obj.PlotAxesRight - obj.PlotAxesLshift;
            a3h = obj.TileHeight - 2*obj.PlotAxesTop - obj.PlotAxesVshift;
            set(obj.hAxes_3, 'Units', 'normalized', ...
                'Position', [a3l, a3b, a3w, a3h]);
            %% Axes 4 - middle bottom - improfiles ...
            a4l = a3l;
            a4b = obj.PlotAxesTop + obj.PlotAxesVshift;
            a4w = a3w;
            a4h = a3h;
            set(obj.hAxes_4, 'Units', 'normalized', ...
                'Position', [a4l, a4b, a4w, a4h]);
            %% Axes 5 - right top - improfiles ...
            a5l = obj.GelTileWidth + plotTileWidth + obj.PlotAxesRight + obj.PlotAxesLshift;
            a5b = a3b;
            a5w = a3w;
            a5h = a3h;
            set(obj.hAxes_5, 'Units', 'normalized', ...
                'Position', [a5l, a5b, a5w, a5h]);
            %% Axes 6 - right bottom - improfiles ...
            a6l = a5l;
            a6b = obj.PlotAxesTop + obj.PlotAxesVshift; %= a4b
            a6w = a3w;
            a6h = a3h;
            set(obj.hAxes_6, 'Units', 'normalized', ...
                'Position', [a6l, a6b, a6w, a6h]);
        end % layoutAxes()

        %% Set methods for the Axes layout parameters
        function set.TileHeight(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.TileHeight = val; 
                obj.layoutAxes;
            end
        end
        function set.GelTileWidth(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.GelTileWidth = val; 
                obj.layoutAxes;
            end
        end
        function set.GelAxesPad(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.GelAxesPad = val; 
                obj.layoutAxes;
            end
        end
        function set.PlotAxesRight(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.PlotAxesRight = val; 
                obj.layoutAxes;
            end
        end
        function set.PlotAxesTop(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.PlotAxesTop = val; 
                obj.layoutAxes;
            end
        end
        function set.PlotAxesLshift(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.PlotAxesLshift = val; 
                obj.layoutAxes;
            end
        end
        function set.PlotAxesVshift(obj, val)
            if isscalar(val) && val > 0 && val <= 1
                obj.PlotAxesVshift = val; 
                obj.layoutAxes;
            end
        end
        % ================================================================

        %% Class constructor
        function obj = improfPlotUI(h_gelui, selectionMask)
            %% Make the UI
            % Figure itself
            fPos = dmGEL.Constants.ImprofPlotInitFigPosition;
            fName = dmGEL.Constants.ImprofPlotInitFigName;
            obj.hFig = figure(...
                'Units', 'pixels', ...
                'Position', fPos, ...
                'DefaultUicontrolUnits', 'pixels', ...
                'IntegerHandle', 'on', ...
                'HandleVisibility', 'on', ...
                'Renderer', 'opengl', ...
                'MenuBar', 'figure', ...
                'Toolbar', 'auto', ...
                'NumberTitle', 'off', ...
                'WindowStyle', 'normal', ...
                'DockControls', 'on', ...
                'PaperPositionMode', 'auto', ...
                'PaperOrientation', 'landscape', ...
                'Visible', 'off', ... % <------------------------------------ !!! !!! !!!
                'Name', fName ...
                );

            % Axes
            obj.hAxes_1 = axes('Parent', obj.hFig, 'Visible', 'on', 'HandleVisibility', 'on', 'Tag', 'Axes_1');
            obj.hAxes_2 = axes('Parent', obj.hFig, 'Visible', 'on', 'HandleVisibility', 'on', 'Tag', 'Axes_2');
            obj.hAxes_3 = axes('Parent', obj.hFig, 'Visible', 'on', 'HandleVisibility', 'on', 'Tag', 'Axes_3');
            obj.hAxes_4 = axes('Parent', obj.hFig, 'Visible', 'on', 'HandleVisibility', 'on', 'Tag', 'Axes_4');
            obj.hAxes_5 = axes('Parent', obj.hFig, 'Visible', 'on', 'HandleVisibility', 'on', 'Tag', 'Axes_5');
            obj.hAxes_6 = axes('Parent', obj.hFig, 'Visible', 'on', 'HandleVisibility', 'on', 'Tag', 'Axes_6');
            obj.layoutAxes;

            %% Add uimenus to figure's MenuBar
            % 'DATA' main menu with its Items
            obj.hDataMenu = uimenu(obj.hFig, 'Text', 'D&ATA'); % specify a mnemonic keyboard shortcut (Alt+mnemonic) by using the ampersand (&) character
            obj.hRebuildChartsItem = uimenu(obj.hDataMenu, ...
                'Text', '&Rebuild Charts', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.poltData ...
                );
            obj.hExportProfilesItem = uimenu(obj.hDataMenu, ...
                'Text', '&Export Intensity Profiles', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.exportProfiles ...
                );

            % 'Preserve me!' main menu with its Items
            obj.hPreserveMenu = uimenu(obj.hFig, ...
                'Text', '-> ! Preserve me ! <-', ...
                'ForegroundColor', [1 0 0]);
            obj.hPreserveItem = uimenu(obj.hPreserveMenu, ...
                'Text', 'Prevent Charts auto-update on a new band selection', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.disconnectGELUI);
                % Preserve this Chart Figure from auto-updates
                % Preserve Charts in this Figure from auto-updates
                % Prevent Charts in this Figure from auto-updates
                % Prevent Charts auto-update on a new band selection
                % Forever prevent Charts auto-update on a new band selection

            %% Set handle to the related gelui obj, create the charts
            if nargin > 0
                obj.Hgelui = h_gelui;
                obj.updateData(h_gelui.GelDataObj, selectionMask);
            end

            %% Final steps ...
            % set fig delete fcn and make figure Visible
            set(obj.hFig, 'DeleteFcn', @obj.figDeleteFcn);
            set(obj.hFig, 'Visible','on');
 
            % Save the handle to THIS obj to the figure's app data 
            setappdata(obj.hFig, 'THIS_UI_OBJ', obj);
        end % Class constructor
        % ================================================================
       
        %% Delete method
        function delete(obj)
            disp(' >>> improfPlotUI : Delete method');
            % Disconnect from the related gelui obj 
            % (without modifying the uimenu)
            obj.Hgelui.HimprofPlotUI = [];
            obj.Hgelui = [];
            % Delete the Figure if it is NOT 'BeingDeleted' yet
            if strcmpi(get(obj.hFig, 'BeingDeleted'), 'off')
                delete(obj.hFig);
            end
        end % Delete method
        % ================================================================
        
        %% The Figure's 'DeleteFcn'
        % function methodName(obj,src,eventData)
        function figDeleteFcn(obj, ~, ~)
            disp(' >>> improfPlotUI : figDeleteFcn');
            delete(obj);
        end % figDeleteFcn()
        
        % ================================================================

        %% Method to update Data and Charts
        function updateData(obj, GelDataObj, selectionMask)
            % Make required calculations; update vals of the corresponding properties.
            obj.prepImgs(GelDataObj, selectionMask);
            obj.calcPfls(GelDataObj, selectionMask);
            obj.genFigName(GelDataObj);
            % Update Charts 
            obj.poltData;
        end

        %% Disconnect this obj from the related gelui obj 
        % (Forever prevent Charts auto-update on a new band selection)
        % * remove handle to THIS obj from the related gelui obj property
        % * remove handle to the related gelui obj from THIS obj property
        % * set corresponding uimenu inactive and change its Text
        % * and delete its Item that has called this method
        function disconnectGELUI(obj)
            %HimprofPlotUI
            disp(' >>> improfPlotUI : |-> ! Preserve me ! <-| ---> Preserve me!')
            obj.Hgelui.HimprofPlotUI = [];
            obj.Hgelui = [];
            set(obj.hPreserveMenu, 'Enable', 'off');
            set(obj.hPreserveMenu, 'Text', '| PRESERVED |');
            delete(obj.hPreserveItem);
        end

        %% saveobj method
        function s = saveobj(obj)
            s.CLASS = dmGEL.improfPlotUI.CLASS;
            s.DATA_VERSION = dmGEL.improfPlotUI.DATA_VERSION;
            props2save = dmGEL.improfPlotUI.PROPS2SAVE;
            for k = 1:length(props2save)
                s.(props2save{k}) = obj.(props2save{k});
            end
        end

        %% Method to load saved class data from struct
        % This is to prevent loadobj() method from being called recursively
        % The object will be constructed on load
        function loadData(obj, s)
            % * to be added lated - logics to verify the DATA_VERSION
            if isfield(s, 'CLASS') && isequal(s.CLASS, dmGEL.improfPlotUI.CLASS)
                props2save = dmGEL.improfPlotUI.PROPS2SAVE;
                for k = 1:length(props2save)
                    if isfield(s, props2save{k})
                        obj.(props2save{k}) = s.(props2save{k});
                    end
                end
                % Reconstruct charts
                obj.poltData;
            else
                error('dmGEL.improfPlotUI : loadData() : \n%s', ...
                    'This is NOT saved obj of this class.');
            end
        end
    end % methods

    methods (Static)
        %% loadobj method
        function obj = loadobj(s)
            % Call Class Constructor first to generate an 'empty' obj.
            obj = dmGEL.improfPlotUI;

            % Saved improfPlotUI obj is ALWAYS disconnected from gelui.
            set(obj.hPreserveMenu, 'Enable', 'off');
            set(obj.hPreserveMenu, 'Text', '| PRESERVED |');
            delete(obj.hPreserveItem);

            % Parse the input 's'.
            if isstruct(s)
                disp('s is struct')
                obj.loadData(s)
            else
                % Try if 's' is already constructed class object
                try
                    class(s)
                    dataStruct = s.saveobj;
                    obj.loadData(dataStruct);
                catch ME
                    error('dmGEL.improfPlotUI : loadobj() : \n%s', ...
                        'ME.message');
                end
            end
        end % loadobj
    end % methods (Static)
end % classdef