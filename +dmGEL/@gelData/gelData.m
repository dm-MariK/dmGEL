% Copyright (c) 2025 Denis I. Markov aka MariK
% < dm DOT marik DOT 230185 AT gmail DOT com >
% < t DOT me / dm_MariK >
% This work is licensed under the Creative Commons Attribution-ShareAlike
% 4.0 International License. 
%
classdef gelData < handle
    %% Properties definition
    properties (SetAccess = protected, AbortSet = true)
        % Session state: whether the obj's current state is saved to file
        % (new session is always considered to be saved - nothing to save)
        IsSaved = true;
    end % properties (SetAccess = protected, AbortSet = true)

    properties (Dependent, SetAccess = private)
        BGCorrectedImg;
    end % properties (Dependent, SetAccess = private)

    properties (AbortSet = true)
        OriginalImg;
        OriginalImgFilePath = '< No Data Loaded jet >';
        GrayScaledImg;
        FilteredImg;
        ImgBackGround;
        %BGCorrectedImg;

        % Handle to gelui obj containing axes HG-obj to plot images to
        Hgelui;
        % Array of roiPolygon objecs: selections associated with this Gel
        HroiArr = dmGEL.roiPolygon.empty;

        % Session name. 1)to generate filename to save session to;
        % 2) to use to name gelui window.
        SessionName = 'New Session';

        % Filter function and its additional arguments. 
        % Call syntax is expected to be:
        %   filtFcnArgs = {arg_1, arg_2, arg_3, arg_4}; % and so on...
        %   J = filtFcn(I, filtFcnArgs{:});
        % Note that additional arguments must be set as a cell array!
        FiltFcn;
        FiltFcnArgs;

        % BackGround calculator function and its additional arguments.
        % Call syntax is expected to be:
        %   BGcalcFcnArgs = {arg_1, arg_2, arg_3, arg_4}; % and so on...
        %   BG = BGcalcFcn(I, roi_pixel_pos, BGcalcFcnArgs{:});
        % Here BG is calculated BackGround, NOT the result of its
        % subtraction! 
        % roi_pixel_pos is two-vector matrix of polygon vertices'
        % coordinates returned by roiPolygon.getPixelPosition().
        % Note that additional arguments must be set as a cell array!
        BGcalcFcn;
        BGcalcFcnArgs;
        % ---------------------------------------------------------------

        % Whether to collect acquired gel intensity data to a file
        % and the file to collect the data to.
        CollectDataToFile = false;
        FileToCollectDataTo = '';
    end %properties

    properties (Constant)
        % Define defaults for BGcalcFcn, FiltFcn and their additional args
        % as Static (Constant) class properties.
        %
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
    end %properties (Constant)

    %% Mmethods definition
    methods
        %% Class Constructor
        % * Initialize BGcalcFcn, FiltFcn and their additional args from
        %   their default values.
        % * Accepts 'Hgelui' as input or generates new gelui figure 
        %   if 'Hgelui' is not passed.
        % * -- Saves handle to THIS obj to the figure's "setappdata()" ---> gelui 
        function obj = gelData(h_gelui)
            disp('gelDATA : Class Constructor is called');
            obj.FiltFcn = dmGEL.gelData.DefaultFiltFcn;
            obj.FiltFcnArgs = dmGEL.gelData.DefaultFiltFcnArgs;
            obj.BGcalcFcn = dmGEL.gelData.DefaultBGcalcFcn;
            obj.BGcalcFcnArgs = dmGEL.gelData.DefaultBGcalcFcnArgs;

            if nargin > 0
                % ... if called by gelui
                obj.Hgelui = h_gelui;
            else
                % init the gelui GUI-figure ...
                hUI = dmGEL.gelui(obj);
                obj.Hgelui = hUI;
            end

            % New session is always considered to be saved - nothing to save
            obj.IsSaved = true;
        end % Class Constructor

        %% Import an Image from file or from workspace variable.
        function importImg(obj, I)
            J = im2gray(I);
            K = uint8(J);

            obj.OriginalImg = I;
            obj.GrayScaledImg = K;

            % clear previous calculations
            obj.FilteredImg = [];
            obj.ImgBackGround = [];
            %obj.BGCorrectedImg = [];
            % delete all HroiArr roiPolygon objecs -- better ASK whether to
            % do this !!!
        end %importImg

        %% Invert Images' Colors
        function invertImg(obj)
            I = obj.GrayScaledImg;
            obj.GrayScaledImg = uint8(255) - I;
            % NOTIFY about the change !!!
            % ...
        end %invertImg

        %% Filter noise on the image
        % ...
        function filterImg(obj, do_overwrite, preserve_bg)
            fcn = obj.FiltFcn;
            args = obj.FiltFcnArgs;
            if do_overwrite || isempty(obj.FilteredImg)
                I = obj.GrayScaledImg;
            else
                I = obj.FilteredImg;
            end
            % J = filtFcn(I, filtFcnArgs{:});
            J = fcn(I, args{:});
            obj.FilteredImg = J;
            % NOTIFY about the change !!!
            % ...
            % Consider to add set() method. Do NOT set obj.FilteredImg if
            % isequal(J, obj.FilteredImg)
            % ***
            if ~preserve_bg
                % remove existing BackGround
                obj.ImgBackGround = [];
            end
        end %filterImg

        %% Subtract BackGround
        function bgCorrect(obj, roi_pixel_pos)
            if isempty(obj.FilteredImg)
                return
            end
            fcn = obj.BGcalcFcn;
            args = obj.BGcalcFcnArgs;
            I = obj.FilteredImg;
            % BG = BGcalcFcn(I, roi_pixel_pos, BGcalcFcnArgs{:});
            BG = fcn(I, roi_pixel_pos, args{:});
            %J = I - BG;
            obj.ImgBackGround = BG;
            %obj.BGCorrectedImg = J;
            % NOTIFY about the change !!!
        end %bgCorrect

        %% Calculate integral intensity on a selected area
        % (specified by logical image "mask")
        function v = getInt(obj, BWmask)
            if isempty(obj.ImgBackGround)
                v = [];
                return
            end
            Im = int16(obj.FilteredImg);
            Bg = int16(obj.ImgBackGround);
            A = Im - Bg;
            v = sum(A(BWmask));
        end %getInt

        %% Delete gel images
        function clearImages(obj)
            obj.OriginalImg = [];
            obj.OriginalImgFilePath = '< No Data Loaded jet >';
            obj.GrayScaledImg = [];
            obj.FilteredImg = [];
            obj.ImgBackGround = [];
            %obj.BGCorrectedImg = [];
        end %clearImages
        
        % ----------------------------------------------------------------
        %% Method to remove deleted polygons-objects from HroiArr
        function fixHroiArr(obj)
            validPolyIdx = isvalid(obj.HroiArr);
            obj.HroiArr = obj.HroiArr(validPolyIdx);
        end

        % ----------------------------------------------------------------
        %% Method to mark the session as modified
        function setModified(obj)
            obj.IsSaved = false;
            disp('gelDATA : setModified() is called');
        end

        % Method to *force* mark the session as saved - 4 debug only !!!
        function setSaved(obj)
            obj.IsSaved = true;
        end
        % ----------------------------------------------------------------

        %% BGCorrectedImg get-method
        function val = get.BGCorrectedImg(obj)
            if isempty(obj.ImgBackGround)
                val = [];
            else
                val = obj.FilteredImg - obj.ImgBackGround;
            end
        end

        %% Properties set-methods
        function set.OriginalImg(obj, val)
            obj.OriginalImg = val; 
            obj.setModified;
        end
        function set.OriginalImgFilePath(obj, val)
            obj.OriginalImgFilePath = val; 
            obj.setModified;
        end
        function set.GrayScaledImg(obj, val) 
            obj.GrayScaledImg = val; 
            obj.setModified;
        end
        function set.FilteredImg(obj, val) 
            obj.FilteredImg = val; 
            obj.setModified;
        end
        function set.ImgBackGround(obj, val) 
            obj.ImgBackGround = val; 
            obj.setModified;
        end
        function set.HroiArr(obj, val)
            obj.HroiArr = val; 
            obj.setModified;
        end
        function set.SessionName(obj, val) 
            obj.SessionName = val; 
            obj.setModified;
        end
        function set.FiltFcn(obj, val) 
            obj.FiltFcn = val; 
            obj.setModified;
        end
        function set.FiltFcnArgs(obj, val) 
            obj.FiltFcnArgs = val; 
            obj.setModified;
        end
        function set.BGcalcFcn(obj, val) 
            obj.BGcalcFcn = val; 
            obj.setModified;
        end
        function set.BGcalcFcnArgs(obj, val) 
            obj.BGcalcFcnArgs = val; 
            obj.setModified;
        end
        function set.CollectDataToFile(obj, val)
            obj.CollectDataToFile = val;
            obj.setModified;
        end
        function set.FileToCollectDataTo(obj, val)
            obj.FileToCollectDataTo = val;
            obj.setModified;
        end
        % ----------------------------------------------------------------

        %% Delete method
        % now - for debug propose only
        % NOTE! This method does NOT call roiPolygon : Delete method for
        % any of 'HroiArr' polygons.
        function delete(obj)
            disp('* gelDATA : Delete method');
        end
    end %methods

end % classdef