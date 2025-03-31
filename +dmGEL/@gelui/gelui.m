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
        hViewCalcDetails; % Display Calculation Details
%         hViewCalcDetailsSubmenu; % Display Calculation Details
%         hViewSelectionDetails;
%         hViewImgIntProfiles; % Image Intensity Profiles

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

        %% Associated gelData object and improfPlotUI object
        GelDataObj;
        HimprofPlotUI = [];
    end % properties (Transient)

    properties (SetAccess = private, Transient = true)
        %% Constants that should never be changed
        % The Figure's initial 'Name' (used on-construction only) and 'Tag'
        F_Name = ' -- New dmGEL Session -- '; % PRIVATE
        F_Tag = 'dmGEL.gelui.hFig'; % PRIVATE
        
        % Allowed 'String' values of the Txt uicontrol of the Bottom Panel
        ValueTxtString = 'Value:'; % PRIVATE
        PathTxtString = 'Original Image File:'; % PRIVATE

        % Bottom Panel uicontrols' Tags
        ValueTxt_Tag = 'dmGEL.gelui.hValueTxt'; % PRIVATE
        ValueEdt_Tag = 'dmGEL.gelui.hValueEdt'; % PRIVATE

        % The Axes Tag
        Axs_Tag = 'dmGEL.gelui.hAxes'; % PRIVATE
        
        % Tags for 'View' uimenu's Items to toggle image view mode % PRIVATE
        OriginalImageViewItem_Tag = 'Original'
        GrayScaledImageViewItem_Tag = 'GrayScaled'
        FilteredImageViewItem_Tag = 'Filtered'
        BackGroundViewItem_Tag = 'BackGround'
        BGCorrectedImageViewItem_Tag = 'BGCorrected'
    end % properties (SetAccess = private, Transient = true)

    properties (Transient = true, AbortSet = true)
        %% Some adjustable UI layout parameters
        % Figure color
        F_Color = dmGEL.Constants.GU_F_Color;
        % dmGEL.Constants.GU_ ; %
        % Some appearance settings of the Panels
        Pan_Color = dmGEL.Constants.GU_Pan_Color; %get(0, 'DefaultUicontrolBackgroundColor'); 
        Pan_BorderType = dmGEL.Constants.GU_Pan_BorderType; %'line';
        Pan_BorderWidth = dmGEL.Constants.GU_Pan_BorderWidth; %1;
        Pan_HighlightColor = dmGEL.Constants.GU_Pan_HighlightColor; %get(0, 'DefaultUipanelHighlightColor'); 

        % the Axes 'Position' (normalized Units) and Tag
        Axs_Pos = dmGEL.Constants.GU_Axs_Pos; %[0.01, 0.01, 0.98, 0.98];
        % ----------------------------------------------------------------

        % Minimal Top (central) Panel width and height
        Min_TPw = dmGEL.Constants.GU_Min_TPw; %500;
        Min_TPh = dmGEL.Constants.GU_Min_TPh; %300;
        
        % Height of Bottom Panel ...
        BotPanHeight = dmGEL.Constants.GU_BotPanHeight; %27;
        % ... and of its uicontrols
        EdtHeight = dmGEL.Constants.GU_EdtHeight; %23;
        TxtHeight = dmGEL.Constants.GU_TxtHeight; %18;
        EdtBottom = dmGEL.Constants.GU_EdtBottom; %2;
        TxtBottom = dmGEL.Constants.GU_TxtBottom; %2;
        % ------------
        TxtLeft = dmGEL.Constants.GU_TxtLeft; %20; %24;
        TxtEdtSpan = dmGEL.Constants.GU_TxtEdtSpan; %10;
        ValueTxtWidth = dmGEL.Constants.GU_ValueTxtWidth; %60;
        PathTxtWidth = dmGEL.Constants.GU_PathTxtWidth; %140
    end % properties (Transient = true, AbortSet = true)
    
    
    %% Mmethods definition ===============================================
    methods
        %% Properties set-methods
        function set.F_Color(obj, val) 
            set(obj.hFig, 'Color', val);
            obj.F_Color = val;
        end
        function set.Pan_Color(obj, val)
            set(obj.hTopPan, 'BackgroundColor', val);
            set(obj.hBotPan, 'BackgroundColor', val);
            obj.Pan_Color = val;
        end
        function set.Pan_BorderType(obj, val)
            set(obj.hTopPan, 'BorderType', val);
            set(obj.hBotPan, 'BorderType', val);
            obj.Pan_BorderType = val;
        end
        function set.Pan_BorderWidth(obj, val)
            set(obj.hTopPan, 'BorderWidth', val);
            set(obj.hBotPan, 'BorderWidth', val);
            obj.Pan_BorderWidth = val; 
        end
        function set.Pan_HighlightColor(obj, val)
            set(obj.hTopPan, 'HighlightColor', val);
            set(obj.hBotPan, 'HighlightColor', val);
            obj.Pan_HighlightColor = val;
        end
        function set.Axs_Pos(obj, val)
            set(obj.hAxes, 'Position', val);
            obj.Axs_Pos = val;
        end
        % ----------------------------------------------------------------
        
        function set.Min_TPw(obj, val)
            obj.Min_TPw = val; 
            obj.updatePanelsPosition;
        end
        function set.Min_TPh(obj, val)
            obj.Min_TPh = val; 
            obj.updatePanelsPosition;
        end
        function set.BotPanHeight(obj, val)
            obj.BotPanHeight = val; 
            obj.updatePanelsPosition;
        end
        function set.EdtHeight(obj, val)
            obj.EdtHeight = val; 
            obj.updatePanelsPosition;
        end
        function set.TxtHeight(obj, val)
            obj.TxtHeight = val; 
            obj.updatePanelsPosition;
        end
        function set.EdtBottom(obj, val)
            obj.EdtBottom = val; 
            obj.updatePanelsPosition;
        end
        function set.TxtBottom(obj, val)
            obj.TxtBottom = val; 
            obj.updatePanelsPosition;
        end
        function set.TxtLeft(obj, val)
            obj.TxtLeft = val; 
            obj.updatePanelsPosition;
        end
        function set.TxtEdtSpan(obj, val)
            obj.TxtEdtSpan = val; 
            obj.updatePanelsPosition;
        end
        function set.ValueTxtWidth(obj, val)
            obj.ValueTxtWidth = val; 
            obj.updatePanelsPosition;
        end
        function set.PathTxtWidth(obj, val)
            obj.PathTxtWidth = val; 
            obj.updatePanelsPosition;
        end
    end % methods
    % ====================================================================
    methods (Access = protected, Hidden = true)
        %% Create the UI
        function makeUI(obj)
            %% Create the figure itself
            %obj.F_Color = get(0,'DefaultUicontrolBackgroundColor');
            obj.hFig = figure(...
                'Units', 'pixels', ...
                'Position', dmGEL.Constants.GU_InitFigPosition, ...
                'DefaultUicontrolUnits', 'pixels', ...
                'Color', obj.F_Color, ...
                'IntegerHandle', 'off', ...
                'HandleVisibility', 'on', ...
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
                'MenuSelectedFcn', @(sec, events) obj.saveSession ...
                );
            obj.hFileLoad = uimenu(obj.hFileMenu, ...
                'Text', 'Load Session', ... %'Accelerator', <- Add this functionality later !!!
                'Separator', 'off', ...
                'MenuSelectedFcn', @(sec, events) obj.loadSession ...
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
            obj.hViewCalcDetails = uimenu(obj.hViewMenu, ...
                'Text', 'Display Calculation Details', ...
                'Separator', 'on', ...
                'Checked', 'off', ...
                'MenuSelectedFcn', @obj.setDispCalcDetails ...
                );
%             obj.hViewCalcDetailsSubmenu = uimenu(obj.hViewMenu, 'Text', 'Display Calculation Details', 'Separator', 'on');
%             obj.hViewSelectionDetails = uimenu(obj.hViewCalcDetailsSubmenu, ...
%                 'Text', 'Selection details', ...
%                 'Separator', 'off', ...
%                 'Checked', 'off', ...
%                 'MenuSelectedFcn', @obj.setDispSelectionDetails ...
%                 );
%             obj.hViewImgIntProfiles = uimenu(obj.hViewCalcDetailsSubmenu, ...
%                 'Text', 'Image Intensity Profiles', ...
%                 'Separator', 'off', ...
%                 'Checked', 'off', ...
%                 'MenuSelectedFcn', @obj.setDispImgIntProfiles ...
%                 );
            
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

            % Update the Figure's name
            set(obj.hFig, 'Name', obj.GelDataObj.SessionName);

            % Update checkable uimenus' items check-status.
            obj.setCheckedUimenus;
            obj.updateViewUImenu;
            
            % Switch Bottom Panel to its 'normal' mode.
            obj.toggleBotPan;

            % Save the handle to THIS obj to the figure's app data 
            setappdata(obj.hFig, 'GELUI_OBJ', obj);

        end % Class Constructor
        % ================================================================
       
        %% Delete method
        function delete(obj)
            disp('+ gelui : Delete method');
            % Delete the associated improfPlotUI Object
            if ~isempty(obj.HimprofPlotUI)
                delete(obj.HimprofPlotUI)
            end
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
            disp(' ++ gelui : figCloseRequestFcn : doProceed:');
            disp(doProceed)
            if doProceed
                delete(obj.hFig);
            end
        end % figCloseRequestFcn()
        % ================================================================
        
        %% saveobj method
        function s = saveobj(obj)
            s = obj.GelDataObj.saveobj;
        end % saveobj()
    end % methods

    methods (Static)
        %% loadobj method
        function obj = loadobj(s)
            gelDataObj = dmGEL.gelData.loadobj(s);
            obj = gelDataObj.Hgelui;
        end % loadobj
    end % methods (Static)

end % classdef