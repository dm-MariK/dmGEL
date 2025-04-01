% Define the +dmGEL package Constants.
classdef Constants
    properties (Constant)
        %% Package-wide Constants ----------------------------------------
        % Whether to disp debug messages
        DebugMode = true; % now have no sense

        %% gelui specific Constants --------------------------------------
        % The initial Figure's Position:
        GU_InitFigPosition = [6, 6, 900, 600];

        % Figure color
        GU_F_Color = get(0, 'DefaultUicontrolBackgroundColor');
                     % hsv2rgb([0.35, 0.7, 0.7020]); 
               % Change it later. Use this color to disp Orig Img File Path

        % Some appearance settings of the Panels
        GU_Pan_Color = get(0, 'DefaultUicontrolBackgroundColor');
        GU_Pan_BorderType = 'line'; % 'none';
        GU_Pan_BorderWidth = 1;
        GU_Pan_HighlightColor = get(0, 'DefaultUipanelHighlightColor');

        % the Axes 'Position' (normalized Units) and Tag
        GU_Axs_Pos = [0.01, 0.01, 0.98, 0.98];
        % ----------------------------------------------------------------

        % Minimal Top (central) Panel width and height
        GU_Min_TPw = 500;
        GU_Min_TPh = 300;
        
        % Height of Bottom Panel ...
        GU_BotPanHeight = 27;
        % ... and of its uicontrols
        GU_EdtHeight = 23;
        GU_TxtHeight = 18;
        GU_EdtBottom = 2;
        GU_TxtBottom = 2;
        % ------------
        GU_TxtLeft = 20; %24;
        GU_TxtEdtSpan = 10;
        GU_ValueTxtWidth = 60;
        GU_PathTxtWidth = 140

        % Common (default) uiControl Positon parameters
        %BtnLeft = 24;
        %BtnWidth = 139;
        %BtnHeight = 25;
        %EdtHeight = 23;
        %TopDist = 30; % Top distance of the 1-st uiControl (from Top)
        % ----------------------------------------------------------------

        % Blink parameters for toggleBotPan() method when switching to
        % 'showPath' mode.
        GU_BotPanShowPathBlinkFGcolor = [1 0 0];
        GU_BotPanShowPathBlinkBGcolor = hsv2rgb([0.35, 0.7, 0.7020]);
        GU_BotPanShowPathBlinkFontWeight = 'bold';
        GU_BotPanShowPathBlinkTime = 0.5; % in seconds

        %% improfPlotUI specific Constants -------------------------------
        % The initial Figure's Position:
        ImprofPlotInitFigPosition = [24, 40, 1880, 880];
        % ----------------------------------------------------------------
        % The Axes layout parameters - all are of 'Units', 'normalized'
        AxesTileHeight = 0.5;    % renamed from TileHeight
        AxesGelTileWidth = 0.33; % renamed from GelTileWidth

        % Subplots' padding: Relative to Tile's dimentions but NOT as fractions of them.
        GelAxesPad = 0.005; % all - left, right, top, bottom
        PlotAxesRight = 0.01;
        PlotAxesTop = 0.015;
        %  --- additional space for X- and Y-axis labels ---
        PlotAxesLshift = 0.01; % Left shift
        PlotAxesVshift = 0.01; % Vertical shift
        % ----------------------------------------------------------------

        % To representat a band-area Selection:
        SelectionImgBGColor = hsv2rgb([1/12, 0.3125, 1]); % light orange close to white
        SelectionTrackColor = [0, 1, 0]; % green as is ;)
        SelectionTrackLineWidth = 2;
        
        % Where to place the Left and the Right Vertical Intensity profiles
        % relative the Central one; the distance from the Central profile:
        VertPflsHorizDist = 0.35;
        % * i.e., for example, 0.35 means that these profiles will be
        % shifted by 35% of the selection width from the selection center. 
        % Thus, they will go through the left 15% and right 15% of the
        % selection's width: 50% - 35% = 15%
        
        % To display (chart) Image Intensity profiles (improfile-s):
        PlotOrigColor = [0 0.498 0];
        PlotOrigLineWidth = 1;
        PlotFiltColor = [0 0 1];
        PlotFiltLineWidth = 2;
        PlotBackColor = [0 0.749 0.749];
        PlotBackLineWidth = 2;
        PlotCrtdColor = [1 0 0];
        PlotCrtdLineWidth = 2;
        PlotSelectionColor = [0 0 0];
        PlotSelectionLineWidth = 2;

        % To export Image Intensity Profiles as CSV
        PflsExportTwoLineHdr = true;
        PflsExportNumPrecisionORformat = 5; % precision / format used by num2str while converting to CSV

        %% roiPolygon specific Constants ---------------------------------
        % Color of a roiObj when the obj isSelected 
        % (orange by default: hsv2rgb([1/12, 0.9, 1]);)
        SelectedPolygonColor = hsv2rgb([1/12, 0.9, 1]);

        %% gelData specific Constants ------------------------------------
        % Define defaults for BGcalcFcn, FiltFcn and their additional args
        %                   ---------------------------
        % Use median filtering (medfilt2 function) with square neighborhood
        % for noise removing:
        %   nbh = [10 10];
        %   I_mf2 = medfilt2(I,nbh);
        DefaultFiltFcn = @medfilt2;
        DefaultFiltFcnArgs = {[10 10]};
        
        %   BG = dmGEL.bgRectImopen(I, roi_pixel_pos, xMult, yMult)
        % xMult and yMult are horizontal (along X-axis) and vertical (along
        % Y-axis) multipliers, respectively. Scalars. Both are preset to 2. 
        % FOR PERFECT BACKGROUND CALCULATION STREL (for morphologically
        % image opening) MUST BE 2-TIMES BIGGER IN IT'S WIDTH AND 2-TIMES
        % BIGGER IN IT'S HEIGHT THAN THE BIGGEST BAND ON THE GELL IMAGE !!!
        DefaultBGcalcFcn = @dmGEL.bgRectImopen;
        DefaultBGcalcFcnArgs = {2, 2};

    end
end
