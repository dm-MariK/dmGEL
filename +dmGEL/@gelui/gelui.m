% Copyright (c) 2025 Denis I. Markov aka MariK
% < dm DOT marik DOT 230185 AT gmail DOT com >
% < t DOT me / dm_MariK >
% This work is licensed under the Creative Commons Attribution-ShareAlike
% 4.0 International License. 
%
classdef gelui < matlab.mixin.SetGet
    %% Properties definition 
    properties (Transient)
        hFig;
        
        %% Top (Central) uiPanel (uipanel) with its 'Children'
        hTopPan;
        hAxes;
        %hImage; % Consider to make it dynamical or exclude completely!
        % array for 'iptui.roiPolygon'-like objects
                
        %% Bottom uiPanel with its 'Children'
        hBotPan;
        hValueTxt;  %  'Value:' 'text' uicontrol
        hValueEdt;  %  'Value' 'edit' uicontrol
        
        %% axtoolbar to contain "Pan", "Zoom In", "Zoom Out", and "Restore View" buttons
        hAxTB;
        
        %% 'File' main menu with its Items
        hFileMenu;
        hFileImportImageSubmenu;
        hFileImportFile;
        hFileImportWorkSpace;
        %-------------
        hFileSave;
        hFileLoad;
        hFileClear;
        hFileNewWindow;
        %-------------
        hFileCollectDataTo;
        %-------------
        hFileExit;

        %% 'View' main menu with its Items
        hViewMenu;
        % Cell array of Items to toggle image view mode:
        % 'Original Image', 'GrayScaled Image', 'Filtered Image',
        % 'BackGround', 'BGCorrected Image'
        ViewModeItems = {};
        % ... and handles to these Items separately:
        hOriginal;
        hGrayScaled;
        hFiltered;
        hBackGround;
        hBGCorrected;
        %------------------
        hViewOrigImgFile; % Original Image File -- Display its Path
        %------------------
        hViewCalcDetailsSubmenu; % Display Calculation Details
        hViewSelectionDetails;
        hViewImgIntProfiles; % Image Intensity Profiles

        %% 'Image' main menu with its Items
        hImageMenu;
        hImageFilterNoise;
        hImageInvertColors;
        hImageDelBG; % Delete BackGround | Clear BackGround Calculation
        
        %% 'Settings' main menu with its Items
        hSettingsMenu;
        hSettingsNoiseFilter;  % Noise Filter
        hSettingsBGCalculator; % BackGround Calculator

        %% 'New Selection' main menu with its single Item
        hNewSelectionMenu;
        hNewSelectionItem;
        % ^ this is due to it is not a good idea to use a main menu as a Button
        % =================================================
    end % properties (Transient)

    properties
        %% Workflow variables
        % Whether to collect acquired gel intensity data to a file
        % and the file to collect the data to.
        CollectDataToFile = false;
        FileToCollectDataTo = '';

        % Whether to Display Calculation Details: 
        DispSelectionDetails = false; % SelectionDetails
        DispImgIntProfiles = false; % Image Intensity Profiles
        % =================================================

        %% Associated gelData object
        GelDataObj;
        
    end % properties
    
    properties (SetAccess = protected, Hidden = true, Transient = true)
        %% Some presets for the UI layout
        
        % figure size 
        % (WAS maximal for my screen on X220i, if used with tabdlg)
        F_left = 6;
        F_bottom = 6;
        F_width =  900; % 1340; %1356;
        F_height = 600;

        % figure color, 'Name' and 'Tag'
        F_Color = hsv2rgb([0.35, 0.7, 0.7020]); % Change it later. Use this color to disp Orig Img File Path
        F_Name = ' -- New dmGEL Session -- ';
        F_Tag = 'dmGEL.gelui.hFig';
        % ----------------------------------------
        
        % Minimal Top (central) Panel width and height
        Min_TPw = 500;  
        Min_TPh = 300;
        
        % height of Bottom Panel ...
        BotPanHeight = 27;
        % ... and its uicontrols
        EdtHeight = 23;
        TxtHeight = 18;
        EdtBottom = 2;
        TxtBottom = 2;
        % ------------
        TxtLeft = 20; %24;
        TxtEdtSpan = 10;
        ValueTxtWidth = 60;
        PathTxtWidth = 140;

        % Allowed 'String' values of the Txt uicontrol of the Bottom Panel
        ValueTxtString = 'Value:';
        PathTxtString = 'Original Image File:';

        % Bottom Panel uicontrols' Tags
        ValueTxt_Tag = 'dmGEL.gelui.hValueTxt'
        ValueEdt_Tag = 'dmGEL.gelui.hValueEdt'

        % some appearance settings of the Panels
        Pan_Color = get(0, 'DefaultUicontrolBackgroundColor'); % <-- ChildPan_Color
        Pan_BorderType = 'line'; % <-- ChildPan_BorderType = 'line';
        %Pan_BorderType = 'none';
        Pan_BorderWidth = 1; % <-- ChildPan_BorderWidth = 1;
        Pan_HighlightColor = get(0, 'DefaultUipanelHighlightColor'); % <-- ChildPan_HighlightColor
        
        % Panels' Tags -- not need
        % ----------------------------------------
        
        % the Axes 'Position' (normalized Units) and Tag
        Axs_Pos = [0.01, 0.01, 0.98, 0.98];
        Axs_Tag = 'dmGEL.gelui.hAxes';
        % ----------------------------------------
        
        % Common (default) uiControl Positon parameters
        %BtnLeft = 24;
        %BtnWidth = 139;
        %BtnHeight = 25;
        %EdtHeight = 23;
        %TopDist = 30; % Top distance of the 1-st uiControl (from Top)
        
        % Tags for 'View' uimenu's Items to toggle image view mode
        OriginalImageViewItem_Tag = 'Original'
        GrayScaledImageViewItem_Tag = 'GrayScaled'
        FilteredImageViewItem_Tag = 'Filtered'
        BackGroundViewItem_Tag = 'BackGround'
        BGCorrectedImageViewItem_Tag = 'BGCorrected'
        
    end % properties (SetAccess = protected, Hidden = true, Transient = true)
    
    %% Mmethods definition
    methods (Access = protected, Hidden = true)
        %% Create the UI
        function makeUI(obj)
            %% Create the figure itself
            %obj.F_Color = get(0,'DefaultUicontrolBackgroundColor');
            obj.hFig = figure(...
                'Units', 'pixels', ...
                'Position', [obj.F_left obj.F_bottom obj.F_width obj.F_height], ...
                'DefaultUicontrolUnits', 'pixels', ...
                'Color', obj.F_Color, ...
                'IntegerHandle', 'off', ...
                'Renderer', 'painters', ...
                'MenuBar', 'none', ...
                'Toolbar', 'none', ...
                'NumberTitle', 'off', ...
                'WindowStyle', 'normal', ...
                'DockControls', 'off', ...
                'PaperPositionMode', 'auto', ...
                'PaperOrientation', 'landscape', ...
                'Visible', 'off', ...
                'Name', obj.F_Name, ...
                'Tag', obj.F_Tag);
            
            %% Create the uiPanels [and setup their Position -- may be later]
            obj.hTopPan = uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'pixels', ...
                'Position', [1 1 1 1], ... 
                'Visible', 'off', ...
                'DefaultUicontrolUnits', 'pixels', ...
                'BackgroundColor', obj.Pan_Color, ...
                'BorderType', obj.Pan_BorderType, ...
                'BorderWidth', obj.Pan_BorderWidth, ... 
                'HighlightColor', obj.Pan_HighlightColor);
            obj.hBotPan = uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'pixels', ...
                'Position', [1 1 1 1], ... 
                'Visible', 'off', ...
                'DefaultUicontrolUnits', 'pixels', ...
                'BackgroundColor', obj.Pan_Color, ...
                'BorderType', obj.Pan_BorderType, ...
                'BorderWidth', obj.Pan_BorderWidth, ... 
                'HighlightColor', obj.Pan_HighlightColor);
            %obj.updatePanelsPosition; % <---------------- call this later!!
            
            %% Add the axes to the Top uiPanel
            obj.hAxes = axes(...
                'Parent', obj.hTopPan, ...
                'Visible', 'on', ...
                'Units', 'normalized', ...
                'Position', obj.Axs_Pos, ...
                'HandleVisibility', 'on', ...
                'NextPlot', 'replace', ...
                'Tag', obj.Axs_Tag ...
                );
            
            %% Add uiControls to the Bottom uiPanel 
            % Calculate their 'Position' first
            EdtLeft = obj.TxtLeft + obj.ValueTxtWidth + obj.TxtEdtSpan;
            EdtWidth = 1; % <----- !!!
            %  *  'Value:' 'text'  ---------------------------------------
            obj.hValueTxt = uicontrol(...
                'Parent', obj.hBotPan, ...
                'Style', 'text', ...
                'Units', 'pixels', ...
                'Position', [obj.TxtLeft, obj.TxtBottom, obj.ValueTxtWidth, obj.TxtHeight], ... % [l, b, w, h]
                'String', obj.ValueTxtString, ...
                'HorizontalAlignment', 'right', ... % 'left', ...
                'FontWeight', 'bold', ...
                'Tag', obj.ValueTxt_Tag ...
                );
            %  *  'Value' 'edit' field  ----------------------------------
            obj.hValueEdt = uicontrol(...
                'Parent', obj.hBotPan, ...
                'Style', 'edit', ...
                'Units', 'pixels', ...
                'Position', [EdtLeft, obj.EdtBottom, EdtWidth, obj.EdtHeight], ... % [l, b, w, h]
                'BackgroundColor', 'w', ... 
                'String', '-1234567890', ...
                'HorizontalAlignment', 'left', ...
                'Tag', obj.ValueEdt_Tag ...
                );
            % ============================================================
            %% Add 'File' main menu with its Items
            obj.hFileMenu = uimenu(obj.hFig, 'Text', 'File');
            obj.hFileImportImageSubmenu = uimenu(obj.hFileMenu, 'Text', 'Import Image', 'Separator', 'off');
            obj.hFileImportFile = uimenu(obj.hFileImportImageSubmenu, ...
                'Text', 'From file', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.importFile ...
                );
            obj.hFileImportWorkSpace = uimenu(obj.hFileImportImageSubmenu, ...
                'Text', 'From Workspace', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.importWorkSpace ...
                );
            %-------------
            obj.hFileSave = uimenu(obj.hFileMenu, ...
                'Text', 'Save Session', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'on', ...
                'MenuSelectedFcn', @(sec, events) disp('File -> Save Session') ...
                );
            obj.hFileLoad = uimenu(obj.hFileMenu, ...
                'Text', 'Load Session', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) disp('File -> Load Session') ...
                );
            obj.hFileClear = uimenu(obj.hFileMenu, ...
                'Text', 'Clear Session', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.clearSession ...
                );
            obj.hFileNewWindow = uimenu(obj.hFileMenu, ...
                'Text', 'New Session Window', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.newSessionWindow ...
                );
            %-------------
            obj.hFileCollectDataTo = uimenu(obj.hFileMenu, ...
                'Text', 'Collect data to file ...', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'on', ...
                'MenuSelectedFcn', @obj.setFileCollectDataTo ...
                );
            %-------------
            obj.hFileExit = uimenu(obj.hFileMenu, ...
                'Text', 'Exit', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'on', ...
                'MenuSelectedFcn', @obj.figCloseRequestFcn ...
                );

            %% Add 'View' main menu with its Items
            obj.hViewMenu = uimenu(obj.hFig, 'Text', 'View');
            % Items to toggle image view mode:
            obj.hOriginal = uimenu(obj.hViewMenu, ...
                'Text', 'Original Image', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'Checked', 'off', ...
                'Tag', obj.OriginalImageViewItem_Tag, ...
                'MenuSelectedFcn', @obj.selectImg2View ...
                );
            obj.hGrayScaled = uimenu(obj.hViewMenu, ...
                'Text', 'GrayScaled Image', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'Checked', 'off', ...
                'Tag', obj.GrayScaledImageViewItem_Tag, ...
                'MenuSelectedFcn', @obj.selectImg2View ...
                );
            obj.hFiltered = uimenu(obj.hViewMenu, ...
                'Text', 'Filtered Image', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'Checked', 'off', ...
                'Tag', obj.FilteredImageViewItem_Tag, ...
                'MenuSelectedFcn', @obj.selectImg2View ...
                );
            obj.hBackGround = uimenu(obj.hViewMenu, ...
                'Text', 'Calculated BackGround', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'Checked', 'off', ...
                'Tag', obj.BackGroundViewItem_Tag, ...
                'MenuSelectedFcn', @obj.selectImg2View ...
                );
            obj.hBGCorrected = uimenu(obj.hViewMenu, ...
                'Text', 'BGCorrected Image', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'Checked', 'off', ...
                'Tag', obj.BGCorrectedImageViewItem_Tag, ...
                'MenuSelectedFcn', @obj.selectImg2View ...
                );
            % Pack them to Cell Array % a = [a, {4}];
            obj.ViewModeItems = [obj.ViewModeItems, {obj.hOriginal}, ...
                {obj.hGrayScaled}, {obj.hFiltered}, {obj.hBackGround}, ...
                {obj.hBGCorrected}]; 
            %------------------

            obj.hViewOrigImgFile = uimenu(obj.hViewMenu, ...
                'Text', 'Show Original Image Location', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'on', ...
                'MenuSelectedFcn', @(sec, events) obj.toggleBotPan(true) ...
                );
            %------------------
            obj.hViewCalcDetailsSubmenu = uimenu(obj.hViewMenu, 'Text', 'Display Calculation Details', 'Separator', 'on');
            obj.hViewSelectionDetails = uimenu(obj.hViewCalcDetailsSubmenu, ...
                'Text', 'Selection details', ...
                'Separator', 'off', ...
                'Checked', 'off', ...
                'MenuSelectedFcn', @obj.setDispSelectionDetails ...
                );
            obj.hViewImgIntProfiles = uimenu(obj.hViewCalcDetailsSubmenu, ...
                'Text', 'Image Intensity Profiles', ...
                'Separator', 'off', ...
                'Checked', 'off', ...
                'MenuSelectedFcn', @obj.setDispImgIntProfiles ...
                );
            
            %% Add 'Image' main menu with its Items
            obj.hImageMenu = uimenu(obj.hFig, 'Text', 'Image');
            obj.hImageFilterNoise = uimenu(obj.hImageMenu, ...
                'Text', 'Filter Noise', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.filterNoise ...
                );
            obj.hImageInvertColors = uimenu(obj.hImageMenu, ...
                'Text', 'Invert Colors', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.invertColors ...
                );
            obj.hImageDelBG = uimenu(obj.hImageMenu, ...
                'Text', 'Clear BackGround Calculation', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.clearBG ...
                );
            
            %% Add 'Settings' main menu with its Items
            obj.hSettingsMenu = uimenu(obj.hFig, 'Text', 'Settings');
            obj.hSettingsNoiseFilter = uimenu(obj.hSettingsMenu, ...
                'Text', 'Noise Filter', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.GelDataObj.setNoiseFiltOptsUI ...
                );
            obj.hSettingsBGCalculator = uimenu(obj.hSettingsMenu, ...
                'Text', 'BackGround Calculator', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.GelDataObj.setBgCalcOptsUI ...
                );
            
            %% Add 'New Selection' main menu (with its single Item)
            obj.hNewSelectionMenu = uimenu(obj.hFig, 'Text', 'New Selection');
            obj.hNewSelectionItem = uimenu(obj.hNewSelectionMenu, ...
                'Text', 'New Selection', ...
                'Separator', 'off', ...
                'MenuSelectedFcn', @(src, event) obj.newSelection ...
                );
            % ------------------------------------------------------------

            %% Add axtoolbar to contain "Pan", "Zoom In", "Zoom Out", and "Restore View" buttons
            obj.hAxTB = axtoolbar(obj.hAxes, {'pan', 'zoomin', 'zoomout', 'restoreview'}); % due to some reason being 'hidden' by imshow() 
            
            %% Finally call updatePanelsPosition() method to adjust UI elements allocation
            obj.updatePanelsPosition;
        end % makeUI()
    end %methods (Access = protected, Hidden = true)
    % ====================================================================
    
    methods
        %% Update Position of the uiPanels and their Children
        function updatePanelsPosition(obj)
            
            % obtain the Figure size
            set(obj.hFig, 'Units', 'pixels');
            uiPos = get(obj.hFig, 'Position');
            ui_w = uiPos(3);% - 3;
            ui_h = uiPos(4);% - 3;
        
            % Calculate geometry constrains:
            %  * for the Figure as a whole (width and height)
            min_Fh = obj.Min_TPh + obj.BotPanHeight; % looks useless !!! !!no!
            
            % Calculate Top Panel width, ... 
            if ui_w <= obj.Min_TPw
                TPw = obj.Min_TPw; % this also looks useless !!! !!no!
            else
                TPw = ui_w; % save this only
            end
            
            % ... and bottom 
            TPb = obj.BotPanHeight + 1;
            
            % Calculate Top Panel height
            if ui_h <= min_Fh 
                TPh = obj.Min_TPh;
            else
                TPh = ui_h - obj.BotPanHeight;
            end
            
            % Construct the Panels' Position-vectors ... % [l, b, w, h]
            TPpos = [1, TPb, TPw, TPh];
            BPpos = [1, 1, TPw, obj.BotPanHeight];
                        
            % ... and set the Panels' Position
            set(obj.hTopPan, 'Position', TPpos); 
            set(obj.hBotPan, 'Position', BPpos);

            % Adjust uicontrols' Position on the Bottom Panel.
            % determine what kind of hValueTxt we have and define its width
            txtStr = get(obj.hValueTxt, 'String');
            if strcmpi(txtStr, obj.ValueTxtString)
                vTxt_w = obj.ValueTxtWidth;
            else % obj.PathTxtString
                vTxt_w = obj.PathTxtWidth;
            end

            % Calculate hValueEdt left and width
            EdtLeft = obj.TxtLeft + vTxt_w + obj.TxtEdtSpan;
            EdtWidth = TPw - 2*obj.TxtLeft - vTxt_w - obj.TxtEdtSpan;

            % Construct the uicontrols' Position-vectors ... % [l, b, w, h]
            TxtPos = [obj.TxtLeft, obj.TxtBottom, vTxt_w, obj.TxtHeight];
            EdtPos = [EdtLeft, obj.EdtBottom, EdtWidth, obj.EdtHeight];
            % ... and set the uicontrols' Position
            set(obj.hValueTxt, 'Position', TxtPos); 
            set(obj.hValueEdt, 'Position', EdtPos);
        end % updatePanelsPosition()
        % ================================================================
        
        %% Class Constructor 
        function obj = gelui(gelDataObj)
            % Create the UI
            obj.makeUI;
            
            % Adjust the Panels' visibility
            set(obj.hTopPan, 'Visible','on');
            set(obj.hBotPan, 'Visible','on');
            
            % Make the Figure Visible and set its 'ResizeFcn' and
            % 'DeleteFcn' 
            set(obj.hFig, 'Visible','on');
            set(obj.hFig, 'ResizeFcn', @obj.figResizeFcn);
            set(obj.hFig, 'DeleteFcn', @obj.figDeleteFcn);
            
            % Initialize related gelData object
            if nargin > 0
                % If called by gelData Class constructor - use the obj passed 
                obj.GelDataObj = gelDataObj;
            else
                % call gelData Class constructor with this obj argument
                obj.GelDataObj = dmGEL.gelData(obj);
            end
            
            % Set Figure's Close Request Function
            set(obj.hFig, 'CloseRequestFcn', @obj.figCloseRequestFcn);

            % setappdata(h,'API',api); % <-- Store the handles to the fig
            % app data ...

        end % Class Constructor
        % ================================================================
       
        %% Delete method
        function delete(obj)
            disp('+ gelui : Delete method');
            % Delete the Figure if it is NOT 'BeingDeleted' yet
            if strcmpi(get(obj.hFig, 'BeingDeleted'), 'off')
                delete(obj.hFig);
            end
            % Delete the associated GelData Object
            delete(obj.GelDataObj);
        end % Delete method
        % ================================================================
        
        %% The Figure's 'DeleteFcn'
        % function methodName(obj,src,eventData)
        function figDeleteFcn(obj, ~, ~)
            disp(' ++ gelui : figDeleteFcn');
            delete(obj);
        end % figDeleteFcn()
        
        %% The Figure's 'ResizeFcn'
        function figResizeFcn(obj, ~, ~)
            obj.updatePanelsPosition;
        end % figResizeFcn()
        
        %% Figure's Close Request Function ('CloseRequestFcn')
        function figCloseRequestFcn(obj, ~, ~)
            disp('File -> Exit || Close the Window');
            doProceed = obj.checkSaveSession;
            if doProceed
                delete(obj.hFig);
            end
        end % figCloseRequestFcn()

    end %methods

end % classdef