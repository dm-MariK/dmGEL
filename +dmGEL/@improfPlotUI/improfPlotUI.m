% Copyright (c) 2025 Denis I. Markov aka MariK
% < dm DOT marik DOT 230185 AT gmail DOT com >
% < t DOT me / dm_MariK >
% This work is licensed under the Creative Commons Attribution-ShareAlike
% 4.0 International License. 
%
classdef  improfPlotUI < matlab.mixin.SetGet
    properties (Transient = true)
        %% HG-handles
        hFig;

        % Axes layout would be:
        %    (1)[gel] (3)[improfiles] (5)[improfiles]
        %    (2)[gel] (4)[improfiles] (6)[improfiles]
        hAxes_1;
        hAxes_2;
        hAxes_3;
        hAxes_4;
        hAxes_5;
        hAxes_6;
        
        hPlot_3; % array of Line objects on hAxes_3 (for PflsVertCentral)
        hPlot_4; % array of Line objects on hAxes_4 (for PflsVertLeft)
        hPlot_5; % array of Line objects on hAxes_5 (for PflsHorizontal)
        hPlot_6; % array of Line objects on hAxes_6 (for PflsVertRight)

        % 'Export Data' main menu with its Items
        hExportMenu;
        hExportProfilesItem;

        % 'Preserve me!' main menu with its Items
        hPreserveMenu;
        hPreserveItem;

        %% To keep calculated data
        SelectionImg;    % to keep prepared Img displaying the selection on the gel
        PflsHorizontal;  % horizontal improfiles through the selection center
        PflsVertCentral; % vertical improfiles through the selection center
        PflsVertLeft;    % vertical improfiles through the left part of the selection
        PflsVertRight;   % vertical improfiles through the right part of the selection
    end % properties (Transient = true)

    properties(Transient = true, AbortSet = true)
        %% The Axes layout parameters - all are of 'Units', 'normalized'
        TileHeight = 0.5;
        GelTileWidth = 0.33;

        % Subplots' padding: Relative to Tile's dimentions but NOT as fractions of them.
        GelAxesPad = 0.005; % all - left, right, top, bottom
        PlotAxesRight = 0.01;
        PlotAxesTop = 0.015;
        %  --- additional space for X- and Y-axis labels ---
        PlotAxesLshift = 0.01; % Left shift
        PlotAxesVshift = 0.01; % Vertical shift
    end % properties(Transient = true, AbortSet = true)

    methods
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

        %% Class constructor
        % NOT FORGET TO SETAPPDATA WITH HANDLE TO THIS OBJ !!! !!! !!!
        function obj = improfPlotUI(varargin)
            %% Make the UI
            % Figure itself
            fPos = [24, 40, 1880, 880];
            fName ='Selection Details: Image Intensity Profiles';
            obj.hFig = figure(...
                'Units', 'pixels', ...
                'Position', fPos, ...
                'DefaultUicontrolUnits', 'pixels', ...
                'IntegerHandle', 'on', ...
                'Renderer', 'opengl', ...
                'MenuBar', 'figure', ...
                'Toolbar', 'auto', ...
                'NumberTitle', 'off', ...
                'WindowStyle', 'normal', ...
                'DockControls', 'on', ...
                'PaperPositionMode', 'auto', ...
                'PaperOrientation', 'landscape', ...
                'Visible', 'off', ...
                'Name', fName ...
                );

            % Axes
            axsArr = [obj.hAxes_1, obj.hAxes_2, obj.hAxes_3, obj.hAxes_4, obj.hAxes_5, obj.hAxes_6];
            for k = 1:length(axsArr)
                axsArr(k) = axes(...
                    'Parent', obj.hFig, ...
                    'Visible', 'on', ...
                    'HandleVisibility', 'on', ...
                    'NextPlot', 'add' ... %This is same as call `hold(hAxes, 'on')`; the default is 'replace'.
                    );
            end
            obj.layoutAxes;

        end % Class constructor
    end % methods
end % classdef