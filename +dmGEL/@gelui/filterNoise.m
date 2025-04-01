function filterNoise(obj)
% # Filter noise
%
% * Apply new filter above already filtered image; 
%   filter filtered image.
% * Rewrite result of previous noise filtration;
%   filter original. 
% + Preserve calculated image BackGround (if it exists).
%
%         |Apply|  |Cancel|  |More options...|

disp('Image -> Filter Noise');
%% Set up the ui sizing: -------------------------------------------------
f_w = 500; % figure's width
ckb_l = 30;  % left of checkbox and radiobuttons
ckb_w = 440; % width of checkbox and radiobuttons
ckb_h = 20;  % height of checkbox and radiobuttons
ckb_vDist = 10;  % 
% Size of |Apply| and |Cancel| pushbuttons %[100 20 70 30] 
btn_l = 100; % left for |Apply| and right for |Cancel|
btn_w = 70;
btn_b = ckb_vDist; %20;
btn_h = 30; %25

% Calc vertical positions from top; will use dmGEL.dmAUX.hgposTop2Bottom(posVec, pph)
btnGrp_t = ckb_vDist;%*2
btnGrp_h = 2*ckb_h + ckb_vDist;
svBGckb_t = btnGrp_t + btnGrp_h + ckb_vDist;
btn_t = svBGckb_t + ckb_h + ckb_vDist;%*2
f_h = btn_t + btn_h + btn_b;
% btnGrp uibuttongroup's and saveBG checkbox'es positions: 
btnGrp_pos = dmGEL.dmAUX.hgposTop2Bottom([ckb_l, btnGrp_t, ckb_w, btnGrp_h], f_h);
svBGckb_pos = dmGEL.dmAUX.hgposTop2Bottom([ckb_l+20, svBGckb_t, ckb_w-20, ckb_h], f_h);

% Radiobuttons' positions relative to btnGrp uibuttongroup:
% * vertical
rb1_t = 0 +1;
rb2_t = ckb_h + ckb_vDist -2;
rb_l = 0;
% * position vectors
rb1_pos = dmGEL.dmAUX.hgposTop2Bottom([rb_l, rb1_t, ckb_w, ckb_h], btnGrp_h);
rb2_pos = dmGEL.dmAUX.hgposTop2Bottom([rb_l, rb2_t, ckb_w, ckb_h], btnGrp_h);

% |Apply| and |Cancel| position
cancelBtn_l = f_w - btn_l - btn_w; % |Cancel| left
applyBtn_pos = [btn_l, btn_b, btn_w, btn_h];
cancelBtn_pos = [cancelBtn_l, btn_b, btn_w, btn_h];
% ------------------------------------------------------------------------
%% Initializations ...

do_overwrite = false; 
preserve_bg = false;

% Calc The modal fig's position using main UI position
hMainUI = obj.hFig;
set(hMainUI, 'Units', 'pixels');
mainUI_pos = get(hMainUI, 'Position');
fPos = dmGEL.dmAUX.bestModalFigPos(f_w, f_h, mainUI_pos);

%% Construct the ui ------------------------------------------------------
% Create the modal dialog window
fig = figure('Name', 'Filter noise', ... 
    'WindowStyle', 'modal', ...
    'Units', 'pixels',...
    'Position', fPos, ...
    'DefaultUicontrolUnits', 'pixels', ...
    'IntegerHandle', 'off', ...
    'NumberTitle', 'off', ...
    'Resize', 'off');

color = get(fig, 'Color');

% Create a button group to manage the radio buttons
btnGrp = uibuttongroup('Parent', fig, ... 
    'Units', 'pixels', ... 
    'Position', btnGrp_pos, ... % [20 60 460 100]
    'HighlightColor', color, ...
    'ShadowColor', color, ...
    'BorderType', 'none', ...
    'BackgroundColor', color);

% Create mutually exclusive radio buttons with default selection
%rb1 = ...
uicontrol('Parent', btnGrp, ... 
    'Style','radiobutton', ...
    'String','Apply new filter above already filtered image; filter filtered image', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', rb1_pos, ... % [0 60 460 20]
    'Value', true, ...
    'Tag', 'filter_filtered');
%rb2 = ...
uicontrol('Parent', btnGrp, ... 
    'Style', 'radiobutton', ...
    'String', 'Discard result of previous noise filtration; filter original image', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', rb2_pos, ... % [10 40 100 20]
    'Value', false, ...
    'Tag', 'filter_original');

% Create save BackGround check-box
svBGckb = uicontrol('Parent', fig, ...
    'Style', 'checkbox', ...
    'String', ' Preserve calculated image BackGround (if it exists)', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', svBGckb_pos, ...
    'Value', false);

% Add Apply button to confirm the choice
%applyBtn = ...
uicontrol('Parent', fig, ...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'Position', applyBtn_pos, ... % [100 20 70 30]
    'String', 'Apply', ... 
    'Callback', @applyBtnPushed);

% Add Cancel button 
%cancelBtn = ...
uicontrol('Parent', fig, ...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'Position', cancelBtn_pos, ...
    'String', 'Cancel', ... 
    'Callback', @cancelBtnPushed);

%% Callbacks -------------------------------------------------------------
% Callback function for the Apply button
    function applyBtnPushed(~, ~)
        % Get the selected radio button ... Process the choice.
        selectedButton = btnGrp.SelectedObject;
        selectedOption = get(selectedButton, 'Tag');
        if strcmpi(selectedOption, 'filter_original')
            do_overwrite = true;
        end
        % Process the check-box choice.
        preserve_bg = get(svBGckb, 'Value');
        
        % Call corresponding methods 
        obj.GelDataObj.filterImg(do_overwrite, preserve_bg);
        obj.updateViewUImenu;
        obj.selectImg2ViewByTag(obj.FilteredImageViewItem_Tag);

        % Close the modal dialog window
        delete(fig);
    end


% Callback function for the Cancel button
    function cancelBtnPushed(~, ~)
        % Close the modal dialog window
        delete(fig);
    end
end
