function clearSession(obj)
%# Clear current Session
%
% * Select what to Clear
%    + Gel Images
%    + Band Selections
%   BackGround Calculator and Noise Filter Settings will be preserved.
%    
% * Clear all 
%   All Session data and settings will be vanished.
%
%       |Continue|                 |Cancel|
%

disp('File -> Clear Session')
%% Set up the ui sizing: -------------------------------------------------
% * horizontal:
f_w = 502; %520; % FIGURE's width
rb_l = 30;  % left of radiobuttons (left-most uicontrols) and min dist from right of the fig
ckb_lshift = 25; % left (horiz) shift for 'checkbox'-es relative to rb-s.
txt_lshift = 20; % shift for 'text'-s relative to rb-s.
ctnueBtn_l = 100; % left for |Continue| and right for |Cancel| 'pushbutton'-s
btn_w = 70;       % width of |Continue| and |Cancel| 'pushbutton'-s
%
% ---------------> CALCULATED:
rb_w = f_w - 2*rb_l; % radiobuttons' width
ckb_l = rb_l + ckb_lshift;  % checkboxes' left
ckb_w = f_w - rb_l - ckb_l; % checkboxes' width
txt_l = rb_l + txt_lshift;  % 'text'-s left
txt_w = f_w - rb_l - txt_l; % 'text'-s width
% |Cancel| left
cancelBtn_l = f_w - ctnueBtn_l - btn_w;
%          ---------------------------------------------
% * vertical (from TOP):
btn_b = 10; % bottom of |Continue| and |Cancel| btns and top of the top-most uicontrol
uictl_vDist = 6; % vertical distance between uicontrols
rb_ckb_h = 16;  % height of checkboxes and radiobuttons
btn_h = 30; % height of btns 
% Vertical shift for 'checkbox'-es: 
% to add to vDist relative to top-laying and to bottom-laying uicontrols 
ckb_vshift = 0;
% Vertical shift to add to vDist between '...will be preserved.' 'text'
% and 'Clear all' 'radiobutton'
top_bot_RBzone_vshift = 0;
%
% ---------------> CALCULATED:
selectRB_t = btn_b; % top of 'Select what to Clear' 'radiobutton'
gelCkb_t = selectRB_t + rb_ckb_h + uictl_vDist + ckb_vshift; % 'Gel Images' checkbox top
bandCkb_t = gelCkb_t + rb_ckb_h + uictl_vDist; % 'Band Selections' checkbox top
preservedTxt_t = bandCkb_t + rb_ckb_h + uictl_vDist + ckb_vshift; % '...will be preserved.' 'text' top
allRB_t = preservedTxt_t + rb_ckb_h + uictl_vDist + top_bot_RBzone_vshift; % top of 'Clear all' 'radiobutton'
allTxt_t = allRB_t + rb_ckb_h + uictl_vDist; % top of '...will be vanished.' 'text'
%
btn_t = allTxt_t + rb_ckb_h + uictl_vDist; % top of 'Continue' and 'Cancel' btns
f_h = btn_t + btn_h + btn_b; % FIGURE's height
%          ---------------------------------------------
%% *** POSITION VECTORS:
selectRB_pos = hgposTop2Bottom([rb_l, selectRB_t, rb_w, rb_ckb_h], f_h);   % 'Select what to Clear' 'radiobutton'
gelCkb_pos = hgposTop2Bottom([ckb_l, gelCkb_t, ckb_w, rb_ckb_h], f_h);     % 'Gel Images' checkbox
bandCkb_pos = hgposTop2Bottom([ckb_l, bandCkb_t, ckb_w, rb_ckb_h], f_h);   % 'Band Selections' checkbox
% BackGround Calculator and Noise Filter Settings will be preserved.:
preservedTxt_pos = hgposTop2Bottom(...
    [txt_l, preservedTxt_t, txt_w, rb_ckb_h], f_h);
allRB_pos = hgposTop2Bottom([rb_l, allRB_t, rb_w, rb_ckb_h], f_h); % 'Clear all' radiobutton
allTxt_pos = hgposTop2Bottom([txt_l, allTxt_t, txt_w, rb_ckb_h], f_h);     % 'All ... vanished' text
ctnueBtn_pos = [ctnueBtn_l, btn_b, btn_w, btn_h];   % 'Continue' button
cancelBtn_pos = [cancelBtn_l, btn_b, btn_w, btn_h]; % 'Cancel' button
% ------------------------------------------------------------------------
%% Initializations ...
% -----Stub CallBack preset ----
%fcn = @stubCallbackFcn;
% ------------------------------

% Calc The modal fig's position using main UI position
hMainUI = obj.hFig;
set(hMainUI, 'Units', 'pixels');
mainUI_pos = get(hMainUI, 'Position');
fPos = bestModalFigPos(f_w, f_h, mainUI_pos);

%% Construct the ui ------------------------------------------------------
% Create the modal dialog window
fig = figure('Name', 'Clear current Session', ... 
    'WindowStyle', 'modal', ...
    'Units', 'pixels',...
    'Position', fPos, ...
    'DefaultUicontrolUnits', 'pixels', ...
    'IntegerHandle', 'off', ...
    'NumberTitle', 'off', ...
    'Resize', 'off');

% 'Select what to Clear' 'radiobutton'
selectRB = uicontrol('Parent', fig, ... 
    'Style','radiobutton', ...
    'String', 'Select what to Clear', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight', 'bold', ...
    'Units', 'pixels', ...
    'Position', selectRB_pos, ... 
    'Value', true, ...
    'Tag', 'select', ...
    'Callback', @rbCallback);

% 'Gel Images' checkbox
gelCkb = uicontrol('Parent', fig, ...
    'Style', 'checkbox', ...
    'String', ' Gel Images', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', gelCkb_pos, ...
    'Value', true); %, ...
    %'Callback', fcn); 

% 'Band Selections' checkbox
bandCkb = uicontrol('Parent', fig, ...
    'Style', 'checkbox', ...
    'String', ' Band Selections', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', bandCkb_pos, ...
    'Value', true); %, ...
    %'Callback', fcn); 

% 'BackGround Calculator and Noise Filter Settings will be preserved.' text
%preservedTxt = ...
uicontrol('Parent', fig, ... 
    'Style', 'text', ...
    'String', 'BackGround Calculator and Noise Filter Settings will be preserved.', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', preservedTxt_pos);

% 'Clear all' radiobutton
allRB = uicontrol('Parent', fig, ... 
    'Style','radiobutton', ...
    'String', 'Clear all', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight', 'bold', ...
    'Units', 'pixels', ...
    'Position', allRB_pos, ... 
    'Value', false, ...
    'Tag', 'clear_all', ...
    'Callback', @rbCallback); 

% 'All Session data will be vanished.' text
%allTxt = ...
uicontrol('Parent', fig, ... 
    'Style', 'text', ...
    'String', 'All Session data and settings will be vanished.', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', allTxt_pos);

% 'Continue' button
%ctnueBtn = ...
uicontrol('Parent', fig, ...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'Position', ctnueBtn_pos, ...
    'String', 'Continue', ... 
    'Callback', @ctnueBtnPushed); 

% 'Cancel' button
%cancelBtn = ...
uicontrol('Parent', fig, ...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'Position', cancelBtn_pos, ...
    'String', 'Cancel', ... 
    'Callback', @cancelBtnPushed);

%% Callbacks -------------------------------------------------------------
% radiobuttons' callback
    function rbCallback(src, ~)
        if strcmpi(get(src, 'Tag'), 'clear_all')
            otherBR = selectRB;
            set(gelCkb, 'Enable', 'off');
            set(bandCkb, 'Enable', 'off');
        else
            otherBR = allRB;
            set(gelCkb, 'Enable', 'on');
            set(bandCkb, 'Enable', 'on');
        end
        set(src, 'Value', true);
        set(otherBR, 'Value', false);
    end

% Continue button's callback
    function ctnueBtnPushed(~, ~)
        % Ask whether to save Session before proceed 
        doProceed = obj.checkSaveSession;
        if ~ doProceed
            delete(fig);
            return
        end

        if get(allRB, 'Value') %==true % 'Clear all' selected
            obj.clearAll;
            delete(fig);
            return

        else % 'Select what to Clear'
            if get(gelCkb, 'Value') % clear gel images
                obj.GelDataObj.clearImages;
                obj.updateViewUImenu;
                hImage = findobj(obj.hAxes, 'Type', 'image');
                delete(hImage);
                obj.toggleBotPan;
                set(obj.hFig, 'Name', 'dmGEL: < No Image Loaded >');
            end
            if get(bandCkb, 'Value') % clear band selections
                delete(obj.GelDataObj.HroiArr); % <------------------------- UNDER DEVELOPMENT !!!
                obj.GelDataObj.fixHroiArr;
            end
            % Close the modal dialog window
            delete(fig);
        end
    end

% Cancel button's callback
    function cancelBtnPushed(~, ~)
        % Close the modal dialog window
        delete(fig);
    end

end

%% stub callback ---------------------------------------------------------
% function stubCallbackFcn(src, ~)
% style = get(src, 'Style');
% str = get(src, 'String');
% disp([style, ' :: ', str]);
% end