% The code in this file was inspirited by the undocumented class of MATLAB
% Image Processing Toolbox `iptui.roiPolygon` that was defined in the file:
% <matlab_root>/R2016b/toolbox/images/imuitools/+iptui/roiPolygon.m
% *
% However, despite this fact, this file contains completely original code,
% written by me from scratch. 
% *
% This code was developed as the result of my careful study of the code,
% internal structure and logic of `iptui.roiPolygon` superclasses, namely
% `impoly` and `imroi`. Since the class I created inherits the same
% superclass as MATLAB's original `iptui.roiPolygon` and also serves a
% fairly similar purpose, albeit less generalised, I decided to give it 
% the same name `roiPolygon` (while putting it to a different package). 
%  * Class inheritance hierarchy of MATLAB's `iptui.roiPolygon`:
%    iptui.roiPolygon < impoly < imroi < handle
%  * Class inheritance hierarchy of defined here `dmGEL.roiPolygon`:
%    dmGEL.roiPolygon < impoly < imroi < handle
% 
% The original `iptui.roiPolygon` is Copyright 2007-2014 The MathWorks, Inc.
%              --------------------------------------
% Code in this file is 
% Copyright (c) 2025, Denis I. Markov aka MariK
% < dm DOT marik DOT 230185 AT gmail DOT com >
% < t DOT me / dm_MariK >
% This work is licensed under the Creative Commons Attribution-ShareAlike
% 4.0 International License. 
% 
classdef roiPolygon < impoly
    
    %% Inherited properties:
        % api;
        % h_group;
        % draw_api;
        % graphicsDeletedListener;
        % Deletable;
        % hDeleteContextItem;
    
    %% Properties definition
    properties (Transient)
        % polygon context menus:
        hBodyCmenu;
        hVertexCmenu;
        % ----------------------
        
        hGELUI = []; % handle to the related gelui Object containing Axes
        
        % Color to set when this roiObj isSelected (orange by default)
        SelectedColor = hsv2rgb([1/12, 0.9, 1]);
        
    end %properties
    
    properties (SetAccess = protected, Transient)
        % flag to indicate whether this roiObj is Selected (in context of
        % the gelData Object) 
        isSelected = false; 
        
        % Preserve here the original color of the roiPolygon while it is
        % Selected (and its color is temporary changed to 'SelectedColor').
        OriginalColor;
        
    end %properties 
    
    %% Mmethods definition
    methods
        %% Class Constructor 
        function obj = roiPolygon(geluiObj, position, color)
            if nargin < 2
                position = [];
            end
            h_parent = geluiObj.hAxes;
            
            % * Call Super-Class Constructor:
            % h = impoly(hparent, position)
            %obj = obj@impoly(h_parent,[]);
            obj = obj@impoly(h_parent, position);
            
            % * Apply the class-specific modifications.
            if ~isempty(obj)
                % Set the handle to the related gelui Object
                obj.hGELUI = geluiObj;

                % Set the roiPolygon's color (if it is passed)
                if nargin >= 3
                    obj.setColor(color);
                end
                
                % Enable 'Delete' context menu items in both Body and
                % Vertex context menus
                obj.Deletable = true;
                
                % Constrain the movement of the polygon: specify the
                % boundary of the image as the limits. 
                constrainFcn = makeConstrainToRectFcn('impoly', ...
                    get(h_parent,'XLim'), get(h_parent,'YLim'));
                obj.setPositionConstraintFcn(constrainFcn);
                
                % Add new-position callback to the ROI object.
                % (Function that fires each time the ROI object changes its position.) 
                newPosCback_1 = @(~) obj.newPosCback;
                %newPosCback_1_id = obj.addNewPositionCallback(newPosCback_1);
                obj.addNewPositionCallback(newPosCback_1);

                % Adjust context menus of the ROI object.
                obj.cofigCmenus;
            end

        end % Class Constructor
        
        %% Configure the context menus
        function cofigCmenus(obj)
            
            % Get polygon context menus.
            bodyCmenu   = obj.getContextMenu();
            vertexCmenu = obj.getVertexContextMenu();
            
            % Preserve handles to these menus in the obj's Properties.
            obj.hBodyCmenu = bodyCmenu;
            obj.hVertexCmenu = vertexCmenu;
            % -------------------------------------------------------
            
            %% Configure Body context menu
            % Make it look like:
            % (5) [Get Intensity cmenu item]
            %     ----------------------------
            % (4) [Use to Calc. BG cmenu item]   <---  Separator: 'on'
            % (3) [Set Color cmenu item]*
            % (2) [Delete cmenu item]*
            %     ----------------------------
            % (1) [Test Selection cmenu item]    <---  Separator: 'on'
            
            % Find and hide 'copy position cmenu item'.
            bodyCopyPosItem = findobj(bodyCmenu, ...
                'tag', 'copy position cmenu item');
            set(bodyCopyPosItem, 'Enable', 'off');
            set(bodyCopyPosItem, 'Visible', 'off');
            
            % * add 'Get Intensity' cmenu item
            bodyGetIntItem = uimenu(bodyCmenu, ...
                'Label', 'Get Intensity', ...
                'Tag', sprintf('%s cmenu item', lower('Get Intensity')), ...
                'Separator', 'off', ...
                'Callback', @(varargin) obj.getIntensity);
            % * add 'Use to Calc. BG' cmenu item
            bodyUse2BGCalcItem = uimenu(bodyCmenu, ...
                'Label', 'Use to Calc. BG', ...
                'Tag', sprintf('%s cmenu item', lower('Use to Calc. BG')), ...
                'Separator', 'on', ...
                'Callback', @(varargin) obj.calcBG);
            % * add 'Test Selection' context menu item % <-- Hide it later
            bodyTestSelItem = uimenu(bodyCmenu, ...
                'Label', 'Test Selection', ...
                'Tag', sprintf('%s cmenu item', lower('Test Selection')), ...
                'Separator', 'on', ...
                'Callback', @(varargin) obj.testStrElSz); % <-------------- For debug and test only !!!
            % * add 'Cancel' context menu item (and 'ESC' key callback)
            % We do not need this since we set the roiPolygon 'Deletable' !
            %uimenu(bodyCmenu, ...
            %       'Label', 'Cancel', ...
            %       'Tag', 'cancel cmenu item', ...
            %       'Callback', @(varargin) obj.delete);

            % Modify order of the Body context menu items.
            bodyCmenuChildren = get(bodyCmenu, 'Children');
            bodyOtherIdx = ~ismember(bodyCmenuChildren, ...
                [bodyGetIntItem, bodyUse2BGCalcItem, bodyTestSelItem]);
            bodyOtherItems = bodyCmenuChildren(bodyOtherIdx);
            bodyCmenuChildren = [bodyTestSelItem, bodyOtherItems', ...
                bodyUse2BGCalcItem, bodyGetIntItem];
            set(bodyCmenu, 'Children', bodyCmenuChildren);
            % -------------------------------------------------------

            %% Configure Vertex context menu
            % Make it look like:
            % (5) [Delete Vertex cmenu item]*
            %     ----------------------------
            % (4) [Get Intensity cmenu item]   <---  Separator: 'on'
            % (3) [Use to Calc. BG cmenu item]
            % (2) [Set Color cmenu item]*
            %     ----------------------------
            % (1) [Test Selection cmenu item]  <---  Separator: 'on'
            
            % Find and hide 'copy position cmenu item'.
            vertexCopyPosItem = findobj(vertexCmenu, ...
                'tag', 'copy position cmenu item');
            set(vertexCopyPosItem, 'Enable', 'off');
            set(vertexCopyPosItem, 'Visible', 'off');
            
            % Find 'delete vertex cmenu item'.
            deleteVertexItem = findobj(vertexCmenu, ...
                'tag', 'delete vertex cmenu item');
            %set(deleteVertexItem, 'Separator', 'on'); %add 'Separator' to the item
            
            % * add 'Get Intensity' cmenu item
            vertexGetIntItem = uimenu(vertexCmenu, ...
                'Label', 'Get Intensity', ...
                'Tag', sprintf('%s cmenu item', lower('Get Intensity')), ...
                'Separator', 'on', ...
                'Callback', @(varargin) obj.getIntensity);
            % * add 'Use to Calc. BG' cmenu item
            vertexUse2BGCalcItem = uimenu(vertexCmenu, ...
                'Label', 'Use to Calc. BG', ...
                'Tag', sprintf('%s cmenu item', lower('Use to Calc. BG')), ...
                'Separator', 'off', ...
                'Callback', @(varargin) obj.calcBG);
            % * add 'Test Selection' context menu item % <-- Hide it later
            vertexTestSelItem = uimenu(vertexCmenu, ...
                'Label', 'Test Selection', ...
                'Tag', sprintf('%s cmenu item', lower('Test Selection')), ...
                'Separator', 'on', ...
                'Callback', @(varargin) obj.testStrElSz); % <------------- For debug and test only !!!
            
            % Modify order of the Vertex context menu items.
            vertexCmenuChildren = get(vertexCmenu, 'Children');
            vertexOtherIdx = ~ismember(vertexCmenuChildren, ...
                [deleteVertexItem, vertexGetIntItem, ...
                vertexUse2BGCalcItem, vertexTestSelItem]);
            vertexOtherItems = vertexCmenuChildren(vertexOtherIdx);
            
            vertexCmenuChildren = [vertexTestSelItem, vertexOtherItems', ...
                vertexUse2BGCalcItem, vertexGetIntItem, deleteVertexItem];
            set(vertexCmenu, 'Children', vertexCmenuChildren);
            
        end % cofigCmenus()
        % ----------------------------------------------------------------
        
        %% Callback for 'Get Intensity' context menus' item
        function getIntensity(obj)
            BW = obj.createMask;
            obj.hGELUI.getIntensity(BW);
        end % getIntensity()
        
        %% Callback for 'Use to Calc. BG' context menus' item
        function calcBG(obj)
            [~,h_im] = parseInputsForCreateMask(obj);
            [roiX,roiY,~,~] = obj.getPixelPosition(h_im);
            pos(:,1) = roiX; 
            pos(:,2) = roiY;
            obj.hGELUI.calcBG(pos);
        end
        % ----------------------------------------------------------------
        
        %% Turn isSelected state on and off
        function markSelected(obj, tf)
            if nargin < 2
                tf = true;
            end
            tf = logical(tf);
            
            if tf && obj.isSelected
                return
            end
            if ~tf && ~obj.isSelected
                return
            end
            
            if tf 
                obj.OriginalColor = obj.getColor;
                obj.setColor(obj.SelectedColor);
                obj.isSelected = true;
            else
                obj.setColor(obj.OriginalColor);
                obj.isSelected = false;
            end
            
        end % markSelected()
        
        %% Obtain roiSavedData structure
        function S = getSavedData(obj)
            S.Position = obj.getPosition;
            if obj.isSelected
                S.Color = obj.OriginalColor;
            else
                S.Color = obj.getColor;
            end
        end %getSavedData()
        
        %% ROI object change Position Callback
        function newPosCback(obj)
            disp('roiPolygon : Vertex position has been modified');
            obj.hGELUI.GelDataObj.setModified;
        end
        
        %% Delete method
        function delete(obj)
            disp('  --> roiPolygon : Delete method');
            if ~isvalid(obj.hGELUI)
                delete@impoly(obj);
                return
            end
            
            % Obtain handle to the related gelData object.
            gelObj = obj.hGELUI.GelDataObj;
            % Call the superclass delete method.
            delete@impoly(obj);

            % Fix HroiArr of the gelData object - remove handle to the
            % deleted polygon from the array.
            if isvalid(gelObj)
                gelObj.fixHroiArr;
            end
        end

        % -----------------------------------------------------------------
        %% Method to access the api - protected property of superclass imroi
        function api = getAPI(obj)
            api = obj.api;
        end %getAPI()
        % -----------------------------------------------------------------
        
        %% Callback for 'Test Selection' context menus' item
        % to test the difference between OLD way and NEW way of 
        % structuring element size calculation.
        %    ST = strel('rectangle', MN)
        % Size of rectangle-shaped structuring element (MN) is specified as 
        % a two-element vector of nonnegative integers. 1-st element of MN
        % is the number of rows, the 2-nd element is the number of columns. 
        % MN is [height, width] or [y, x]
        %
        % OLD Method for calculation of struct el size, BW-mask based: 
        % st_size = [ (1 + 2 * round ( ( max (sum (BW)) )/2 )) (1 + 2 * round ( ( max (sum (BW')) )/2 )) ];
        % that is the same as:
        % % st_size = 1 + 2 .* round( [max(sum(BW)), max(sum(BW, 2))] ./2);
        % 
        % NEW Method is getPixelPosition based:
        % [~,h_im] = parseInputsForCreateMask(obj);
        % [roix,roiy,~,~] = obj.getPixelPosition(h_im);
        % new_st_size = 1 + 2 .* round( [max(Y)-min(Y), max(X)-min(X)] ./2)
        % 
        % ALSO compare both Methods with getPosition based one:
        % pos = obj.getPosition; X = pos(:,1); Y = pos(:,2);
        % new_st_size = 1 + 2 .* round( [max(Y)-min(Y), max(X)-min(X)] ./2)
        %
        % Why we use quite a strange construction like this?
        % st_size_X = 1 + 2.*round( (max(X)-min(X))/2 )
        % Due to st_size_X and st_size_Y MUST BE ODD !!!
        % 2.*round( SOME_NUM/2 ) is always EVEN number.
        %
        function testStrElSz(obj)
            % OLD way
            BW = obj.createMask;
            old_st_size = 1 + 2 .* round( [max(sum(BW)), max(sum(BW, 2))] ./2);
            
            % NEW way
            [~,h_im] = parseInputsForCreateMask(obj);
            [roiX,roiY,~,~] = obj.getPixelPosition(h_im);
            new_st_size = 1 + 2 .* round( [max(roiY)-min(roiY), max(roiX)-min(roiX)] ./2);

            % getPosition way
            pos = obj.getPosition; 
            X = pos(:,1); 
            Y = pos(:,2);
            gPos_st_size = 1 + 2 .* round( [max(Y)-min(Y), max(X)-min(X)] ./2);
            
            % display results
            disp(['OLD: [', num2str(old_st_size), ']']);
            disp(['NEW: [', num2str(new_st_size), ']']);
            disp( 'getPosition based:')
            disp(['     [', num2str(gPos_st_size), ']']);
            disp(' ---------------------------------- ');
            
        end %testStrElSz()
        
    end % methods

end % classdef 