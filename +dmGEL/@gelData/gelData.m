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
        OriginalImgFilePath = '< No Data Loaded yet >';
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
        SessionName = 'dmGEL: New Session';

        % Filter function and its additional arguments. 
        % Call syntax is expected to be:
        %   filtFcnArgs = {arg_1, arg_2, arg_3, arg_4}; % and so on...
        %   J = filtFcn(I, filtFcnArgs{:});
        % Note that additional arguments must be set as a cell array!
        FiltFcn = dmGEL.Constants.DefaultFiltFcn;
        FiltFcnArgs = dmGEL.Constants.DefaultFiltFcnArgs;

        % BackGround calculator function and its additional arguments.
        % Call syntax is expected to be:
        %   BGcalcFcnArgs = {arg_1, arg_2, arg_3, arg_4}; % and so on...
        %   BG = BGcalcFcn(I, roi_pixel_pos, BGcalcFcnArgs{:});
        % Here BG is calculated BackGround, NOT the result of its
        % subtraction! 
        % roi_pixel_pos is two-vector matrix of polygon vertices'
        % coordinates returned by roiPolygon.getPixelPosition().
        % Note that additional arguments must be set as a cell array!
        BGcalcFcn = dmGEL.Constants.DefaultBGcalcFcn;
        BGcalcFcnArgs = dmGEL.Constants.DefaultBGcalcFcnArgs;
        % ---------------------------------------------------------------

        % Whether to collect acquired gel intensity data to a file
        % and the file to collect the data to.
        CollectDataToFile = false;
        FileToCollectDataTo = '';

        % Whether to Display Calculation Details:
        % Selection Details and Image Intensity Profiles.
        DispCalcDetails = true;
    end %properties

    properties (Constant)
        
        %% 'Signature' of saved object's data
        CLASS = 'dmGEL.gelData';
        DATA_VERSION = 1;
        PROPS2SAVE = {'OriginalImg', ...
            'OriginalImgFilePath', ...
            'GrayScaledImg', ...
            'FilteredImg', ...
            'ImgBackGround', ...
            'SessionName', ...    
            'CollectDataToFile', ...
            'FileToCollectDataTo', ...
            'DispCalcDetails'};
    end %properties (Constant)

    %% Mmethods definition
    methods
        %% Class Constructor
        % * Initialize BGcalcFcn, FiltFcn and their additional args from
        %   their default values.
        % * Accepts 'Hgelui' as input or generates new gelui figure 
        %   if 'Hgelui' is not passed. 
        function obj = gelData(h_gelui)
            disp('gelDATA : Class Constructor is called');
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
            obj.OriginalImgFilePath = '< No Data Loaded yet >';
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
        function set.DispCalcDetails(obj, val)
            obj.DispCalcDetails = val;
            obj.setModified;
        end
        % ----------------------------------------------------------------

        %% saveobj method
        function s = saveobj(obj)
            s.CLASS = dmGEL.gelData.CLASS;
            s.DATA_VERSION = dmGEL.gelData.DATA_VERSION;
            props2save = dmGEL.gelData.PROPS2SAVE;
            for k = 1:length(props2save)
                s.(props2save{k}) = obj.(props2save{k});
            end
            % Process functions:
            s.FiltFcn = func2str(obj.FiltFcn);
            s.BGcalcFcn = func2str(obj.BGcalcFcn);
            % Process functions's args:
            s.FiltFcnArgs = dmCellArrayToString(obj.FiltFcnArgs);
            s.BGcalcFcnArgs = dmCellArrayToString(obj.BGcalcFcnArgs);
            % Process the array of roiPolygon objecs:
            obj.fixHroiArr;
            if ~isempty(obj.HroiArr)
                for k = 1:length(obj.HroiArr)
                    s.HroiArr(k) = obj.HroiArr(k).getSavedData;
                end
            end
        end
        % ----------------------------------------------------------------

        %% Delete method
        % now - for debug propose only
        % NOTE! This method does NOT call roiPolygon : Delete method for
        % any of 'HroiArr' polygons.
        function delete(obj)
            disp('* gelDATA : Delete method');
            disp(['  >> gelDATA with Session name; ', obj.SessionName, ' - is being deleted']);
        end
        % ----------------------------------------------------------------
    end %methods

    methods (Static)
        %% loadobj method
        function obj = loadobj(s)
            % Call Class Constructor first to generate an 'empty' obj.
            obj = dmGEL.gelData;

            % !!! ADD SYNCHRONIZATION of gelui state !!! <------------- !!!
            
            % Parse the input 's'.
            if isstruct(s)
                disp('s is struct')
                obj.loadSavedData(s)
            else
                % Try if 's' is already constructed class object
                try
                    class(s)
                    dataStruct = s.saveobj;
                    obj.loadSavedData(dataStruct);
                catch ME
                    error('dmGEL.gelData : loadobj() : \n%s', ...
                        'ME.message');
                end
            end
        end % loadobj
    end % methods (Static)    
end % classdef