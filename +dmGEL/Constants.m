% Define the +dmGEL package Constants.
classdef Constants
    properties (Constant)
        % Add other constants here
        % ...

        %% improfPlotUI specific Constants
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
    end
end
