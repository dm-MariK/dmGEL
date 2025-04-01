function setNoiseFiltOptsUI(obj)
% # Noise Filter Settings
%
% * Use default Noise Filter function ('radiobutton')
%   Set up pixel's neighborhood size:
%   Width: |<'edit'>|   Height: |<'edit'>|
%   + Use same Width and Height values ('checkbox')
%   + Use default neighborhood size   ('checkbox')
%   'text' with description...
%   
% * Use custom Noise Filter function ('radiobutton')
%   Specify your function:
%   |<'edit'>|
%   Specify additional arguments to your function:
%   |<'edit'>|
%   'text' with description...
% 
%       |Apply|                 |Cancel|
%

%% Set up the ui sizing: -------------------------------------------------
% * horizontal:
rb_l = 30;  % left of radiobuttons (left-most uicontrols) and min dist from right of the fig
hdrTxt_lshift = 20; % shift for 'Set up multipliers:' 'text' relative to rb-s.
xMultTxt_lshift = 10; %0; % horiz shift for xMult 'text' relative to the above 'text'
ckbUse_lshift = 30; %0; % horiz shift for 'Use ...' 'checkbox'-es relative to the above 'text'
dsptTxt_w = 740; %740; % initial, optimized for cell array of strings % WIDTH OF 'TEXT' DESCRIPTION
xyMultTxt_w = 120; % width of xMult and yMult 'text'-s
xyMult_h_dist = 30; % horizont dist xMultEdt <--> yMultTxt
xyMultTxtEdt_h_dist = 2; % horizont dist nMultTxt <--> nMultEdt
applyBtn_l = 100; % left for |Apply| and right for |Cancel| 'pushbutton'-s
btn_w = 70;       % width of |Apply| and |Cancel| 'pushbutton'-s
%
% ---------------> CALCULATED:
f_w = dsptTxt_w + 2*rb_l + hdrTxt_lshift; %+ xMultTxt_lshift + ckbUse_lshift; %800; % figure's width
rb_w = f_w - 2*rb_l; % radiobuttons' width
% Left and width of 'Set up multipliers:' and other headers 'text'
hdrTxt_l = rb_l + hdrTxt_lshift;
hdrTxt_w = f_w - hdrTxt_l - rb_l;
% x/y-Mult-Txt/Edt left and width
xMultTxt_l = hdrTxt_l + xMultTxt_lshift;
xyMultEdt_w = ( f_w - rb_l - xMultTxt_l ...
    - 2*(xyMultTxt_w + xyMultTxtEdt_h_dist) ...
    - xyMult_h_dist )/2;
xMultEdt_l = xMultTxt_l + xyMultTxt_w + xyMultTxtEdt_h_dist;
yMultTxt_l = xMultEdt_l + xyMultEdt_w + xyMult_h_dist;
yMultEdt_l = yMultTxt_l + xyMultTxt_w + xyMultTxtEdt_h_dist;
% 'Use ...' 'checkbox'-s left and width
ckbUse_l = xMultTxt_l + ckbUse_lshift;
ckbUse_w = f_w - ckbUse_l - rb_l;
% |Cancel| left
cancelBtn_l = f_w - applyBtn_l - btn_w;
%          ---------------------------------------------
% * vertical (from TOP):
uictl_vDist = 10; % vertical distance between uicontrols
rb_ckb_h = 20;  % height of checkboxes and radiobuttons
btn_edt_h = 30; % height of btns and edts
% vDist between 'Set up multipliers:' 'text' and xyEdt-s
xyEdt_top_vDist = 2;
% Vertical shift for 'Use ...' 'checkbox'-es: 
% to add to vDist relative to top-laying and to bottom-laying uicontrols 
ckbUse_vshift = 0;
% Vertical shift to add to vDist between top (default fcn) 'text'
% description and 'Use custom...' 'radiobutton'
top_bot_vshift = 0;
% 
topDsptTxt_h = 168; % height of top (default fcn) 'text' description
botDsptTxt_h = 204; %85; % height of bottom (custom fcn) 'text' description
% * approx 17 pixels per line of text
%
% ---------------> CALCULATED:
useDfltRB_t = uictl_vDist; % top of 'Use default...' 'radiobutton'
sMultHdrTxt_t = useDfltRB_t + rb_ckb_h + uictl_vDist; % top of 'Set up multipliers:' 'text'
% Top of x/y-Mult-Txt/Edt
xyEdt_t = sMultHdrTxt_t + rb_ckb_h + xyEdt_top_vDist;
xyTxt_t = xyEdt_t + btn_edt_h - rb_ckb_h - 2;
%
useSameCkb_t = xyEdt_t + btn_edt_h + uictl_vDist + ckbUse_vshift; % 'Use same xMult...' ckb top
useDfltCkb_t = useSameCkb_t + rb_ckb_h + uictl_vDist; % 'Use default...' ckb top
topDsptTxt_t = useDfltCkb_t + rb_ckb_h + uictl_vDist + ckbUse_vshift; % top of top (default fcn) 'text' description
% ----------------------------
useCustomRB_t = topDsptTxt_t + topDsptTxt_h + uictl_vDist + top_bot_vshift; % top of 'Use custom...' 'radiobutton' <---- !!!
usrFcnTxt_t = useCustomRB_t + rb_ckb_h + uictl_vDist; % top of 'Specify your function:' 'text'
usrFcnEdt_t = usrFcnTxt_t + rb_ckb_h + xyEdt_top_vDist; % top of the corresponding 'edit'
usrFcnArgsTxt_t = usrFcnEdt_t + btn_edt_h + uictl_vDist; % top of user's fcn args 'text'
usrFcnArgsEdt_t = usrFcnArgsTxt_t + rb_ckb_h + xyEdt_top_vDist; % top of the corresponding 'edit'
botDsptTxt_t = usrFcnArgsEdt_t + btn_edt_h + uictl_vDist; % top of bottom (user's fcn) 'text' description
%
btn_t = botDsptTxt_t + botDsptTxt_h + uictl_vDist + top_bot_vshift; % top of 'Apply' and 'Cancel' btns
btn_b = uictl_vDist;
f_h = btn_t + btn_edt_h + btn_b; % FIGURE's height
%          ---------------------------------------------
%% *** POSITION VECTORS:
useDfltRB_pos = hgposTop2Bottom([rb_l, useDfltRB_t, rb_w, rb_ckb_h], f_h); % 'Use default...' 'radiobutton'
sMultHdrTxt_pos = hgposTop2Bottom(...
    [hdrTxt_l, sMultHdrTxt_t, hdrTxt_w, rb_ckb_h], f_h); % 'Set up multipliers:' 'text'
% x/y-Mult-Txt/Edt
xTxt_pos = hgposTop2Bottom(...
    [xMultTxt_l, xyTxt_t, xyMultTxt_w, rb_ckb_h], f_h);
xEdt_pos = hgposTop2Bottom(...
    [xMultEdt_l, xyEdt_t, xyMultEdt_w, btn_edt_h], f_h);
yTxt_pos = hgposTop2Bottom(...
    [yMultTxt_l, xyTxt_t, xyMultTxt_w, rb_ckb_h], f_h);
yEdt_pos = hgposTop2Bottom(...
    [yMultEdt_l, xyEdt_t, xyMultEdt_w, btn_edt_h], f_h);
%
useSameCkb_pos = hgposTop2Bottom(...
    [ckbUse_l, useSameCkb_t, ckbUse_w, rb_ckb_h], f_h); % 'Use same xMult...' ckb
useDfltCkb_pos = hgposTop2Bottom(...
    [ckbUse_l, useDfltCkb_t, ckbUse_w, rb_ckb_h], f_h); % 'Use default...' ckb
topDsptTxt_pos = hgposTop2Bottom(...
    [hdrTxt_l, topDsptTxt_t, dsptTxt_w, topDsptTxt_h], f_h); % top (default fcn) 'text' description
%             ----------------------------------------
useCustomRB_pos = hgposTop2Bottom(...
    [rb_l, useCustomRB_t, rb_w, rb_ckb_h], f_h); % 'Use custom...' 'radiobutton'
usrFcnTxt_pos = hgposTop2Bottom(...
    [hdrTxt_l, usrFcnTxt_t, hdrTxt_w, rb_ckb_h], f_h); % 'Specify your function:' 'text'
usrFcnEdt_pos = hgposTop2Bottom(...
    [hdrTxt_l, usrFcnEdt_t, hdrTxt_w, btn_edt_h], f_h); % 'Specify your function:' 'edit'
usrFcnArgsTxt_pos = hgposTop2Bottom(...
    [hdrTxt_l, usrFcnArgsTxt_t, hdrTxt_w, rb_ckb_h], f_h); % '... additional arguments ...' 'text'
usrFcnArgsEdt_pos = hgposTop2Bottom(...
    [hdrTxt_l, usrFcnArgsEdt_t, hdrTxt_w, btn_edt_h], f_h); % '... additional arguments ...' 'edit'
botDsptTxt_pos = hgposTop2Bottom(...
    [hdrTxt_l, botDsptTxt_t, dsptTxt_w, botDsptTxt_h], f_h); % bottom (user's fcn) 'text' description
% Apply and Cancel buttons
applyBtn_pos = [applyBtn_l, btn_b, btn_w, btn_edt_h];
cancelBtn_pos = [cancelBtn_l, btn_b, btn_w, btn_edt_h];
% ------------------------------------------------------------------------
%% String for top (default fcn) 'text' description

% String for top (default fcn) 'text' description
topDsptTxt_str = {...
    'The default noise filtering function is "J = medfilt2(I,[Y X])" from MATLAB Image Processing Toolbox.', ...
    'It performs median filtering of the input image "I" in two dimensions. Each pixel of output "J" contains the', ...
    'median value in the Y-by-X neighborhood around the corresponding pixel in the input image "I".', ...
    ' * The values of neighborhood''s Width ("X") and Height ("Y") you can adjust here.' ...
    };

% String for bottom (user's fcn) 'text' description
% ! For selected dlg sizing the text should be col 6 to col 114 <-------!!!
botDsptTxt_str = {...
    ' * Specify your own custom function that calculates the image BackGround. The function must be specified either', ...
    'as a string (character vector) without quotes that represents the function''s name or as an anonymous function', ... 
    '(starting with "@" sign). An input to this field will then be processed by the "str2func" MATLAB function to construct', ... 
    'a function handle, ready to be executed. The function should return a filtered image and only it.', ...
    'The 1-st input of the function (Arg1) must be an image to be filtered', ...
    ' * Specify additional arguments to your function in the format of a cell array in the order thay should appear in', ...
    'your function''s call, as follows: {Arg2, Arg3, Arg4} and so on. Each ArgN by itself could be of any possible format.',...
    'An input to this field will then be processed by the "eval" MATLAB function and the result of its call is expected', ...
    'to be a single correct cell array. Here is an example of the correct format: {''StrParam'', ''StrVal'', 7, [1, 2; 3, 4]}', ...
    'Specify your cell array here just the same way you do it in the MATLAB Workspace, i.e. without leading and trailing' , ...
    'quotation marks. If no additional arguments are required just leave this field empty.' ...
    };
% ------------------------------------------------------------------------
%% PRESETS
% -----Stub CallBack preset ----
%stubFcn = @stubCallbackFcn;
% ------------------------------

% Calculate the modal fig's position using main UI position:
try
    hMainUI = obj.Hgelui.hFig;
    set(hMainUI, 'Units', 'pixels');
    mainUI_pos = get(hMainUI, 'Position');
    fPos = bestModalFigPos(f_w, f_h, mainUI_pos);
catch
    f_l = 500;
    f_b = 500;
    fPos = [f_l, f_b, f_w, f_h]; % the figure's position
end

defaultFcn = dmGEL.Constants.DefaultFiltFcn;
defaultFcnArgs = dmGEL.Constants.DefaultFiltFcnArgs; % {[10 10]}; % {[Y X]};
fcn = obj.FiltFcn;
fcnArgs = obj.FiltFcnArgs;

%% Construct the ui ------------------------------------------------------
% Create the modal dialog window
fig = figure('Name', 'Noise Filter Settings', ... 
    'WindowStyle', 'modal', ...
    'Units', 'pixels',...
    'Position', fPos, ...
    'DefaultUicontrolUnits', 'pixels', ...
    'IntegerHandle', 'off', ...
    'NumberTitle', 'off', ...
    'Resize', 'off');

% 'Use default...' 'radiobutton'
useDfltRB = uicontrol('Parent', fig, ... 
    'Style','radiobutton', ...
    'String','Use default Noise Filter function', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight','bold', ...
    'Units', 'pixels', ...
    'Position', useDfltRB_pos, ... 
    'Value', true, ...
    'Tag', 'use_default_fcn', ...
    'Callback', @rbCallback);

% Set up pixel's neighborhood size 'text'
%sMultHdrTxt = ...
uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String','Set up pixel''s neighborhood size:', ... 
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', sMultHdrTxt_pos);

% x/y-Txt/Edt
xTxt = uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String','Width: ', ...
    'HorizontalAlignment', 'right', ...
    'Units', 'pixels', ...
    'Position', xTxt_pos);
xEdt = uicontrol('Parent', fig, ...
    'Style', 'edit', ...
    'Units', 'pixels', ...
    'Position', xEdt_pos, ... 
    'BackgroundColor', 'w', ... 
    'String', '', ... % set to its default from the class obj <------------ !!!
    'HorizontalAlignment', 'left', ...
    'Callback', @xEdtCallback);
yTxt = uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String','Height: ', ...
    'HorizontalAlignment', 'right', ...
    'Units', 'pixels', ...
    'Position', yTxt_pos);
yEdt = uicontrol('Parent', fig, ...
    'Style', 'edit', ...
    'Units', 'pixels', ...
    'Position', yEdt_pos, ... 
    'BackgroundColor', 'w', ... 
    'String', '', ... % set to its default from the class obj <------------ !!!
    'HorizontalAlignment', 'left', ...
    'Callback', @yEdtCallback);

% 'Use same Width and Height' and 
% 'Use default neighborhood size' 'checkbox'-es
useSameCkb = uicontrol('Parent', fig, ...
    'Style', 'checkbox', ...
    'String', ' Use same Width and Height values', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', useSameCkb_pos, ...
    'Value', false, ...
    'Callback', @useSameCkbCallback);

useDfltCkb = uicontrol('Parent', fig, ...
    'Style', 'checkbox', ...
    'String', ' Use default neighborhood size', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', useDfltCkb_pos, ...
    'Value', false, ...
    'Callback', @useDfltCkbCallback);

% top (default fcn) 'text' description
%topDsptTxt = ...
uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String',topDsptTxt_str, ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', topDsptTxt_pos, ...
    'FontName', 'Helvetica', ...
    'FontSize', 10, ...
    'FontUnits', 'points');
%             ----------------------------------------

% Use custom Noise Filter function ('radiobutton')
useCustomRB = uicontrol('Parent', fig, ... 
    'Style','radiobutton', ...
    'String','Use custom Noise Filter function', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight','bold', ...
    'Units', 'pixels', ...
    'Position', useCustomRB_pos, ... 
    'Value', false, ...
    'Tag', 'use_custom_fcn', ...
    'Callback', @rbCallback);

% 'Specify your function:' 'text' and 'edit' 
usrFcnTxt = uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String', 'Specify your function:', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', usrFcnTxt_pos);
usrFcnEdt = uicontrol('Parent', fig, ...
    'Style', 'edit', ...
    'Units', 'pixels', ...
    'Position', usrFcnEdt_pos, ... 
    'BackgroundColor', 'w', ... 
    'String', '', ... 
    'HorizontalAlignment', 'left', ...
    'Callback', @usrFcnEdtCallback);
% 'Specify additional arguments to your function:' 'text' and 'edit'
usrFcnArgsTxt = uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String', 'Specify additional arguments to your function:', ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', usrFcnArgsTxt_pos);
usrFcnArgsEdt = uicontrol('Parent', fig, ...
    'Style', 'edit', ...
    'Units', 'pixels', ...
    'Position', usrFcnArgsEdt_pos, ... 
    'BackgroundColor', 'w', ... 
    'String', '', ... 
    'HorizontalAlignment', 'left', ...
    'Callback', @usrFcnArgsEdtCallback);

% bottom (user's fcn) 'text' description
%botDsptTxt = ...
uicontrol('Parent', fig, ... 
    'Style','text', ...
    'String', botDsptTxt_str, ...
    'HorizontalAlignment', 'left', ...
    'Units', 'pixels', ...
    'Position', botDsptTxt_pos, ...
    'FontName', 'Helvetica', ...
    'FontSize', 10, ...
    'FontUnits', 'points' );
%             ----------------------------------------

% Apply and Cancel buttons
applyBtn = uicontrol('Parent', fig, ...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'Position', applyBtn_pos, ...
    'String', 'Apply', ... 
    'Callback', @applyBtnPushed);
%cancelBtn = ...
uicontrol('Parent', fig, ...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'Position', cancelBtn_pos, ...
    'String', 'Cancel', ... 
    'Callback', @cancelBtnPushed);

%% Initializations -------------------------------------------------------
% Set up uicontrols according to the obj properties values.
if ~isequal(fcn, defaultFcn) % obj uses custom fcn
    % Adjust Radiobuttons to reflect this:
    set(useCustomRB, 'Value', true);
    set(useDfltRB, 'Value', false);

    % Set up Strings of 'Custom fcn' and 'Custom fcn Args' Edits:
    set(usrFcnEdt, 'String', func2str(fcn));
    if isempty(fcnArgs)
        set(usrFcnArgsEdt, 'String', '');
    else
        fcnArgs_Str = dmCellArrayToString(fcnArgs);
        set(usrFcnArgsEdt, 'String', fcnArgs_Str);
    end

else % obj uses default fcn
    % Adjust Radiobuttons to reflect this:
    set(useCustomRB, 'Value', false);
    set(useDfltRB, 'Value', true);

    % Adjust other top-sub-figure's uicontrols ...
    if isequal(fcnArgs, defaultFcnArgs) % obj uses default fcn's Args
        % Set the corresponding Checkbox to reflect this:
        set(useDfltCkb, 'Value', true);
        
        % Disable x/yEdits and 'Use same x and y' Checkbox:
        set(xEdt, 'Enable', 'off');
        set(yEdt, 'Enable', 'off');
        set(useSameCkb, 'Enable', 'off'); 

    else % fcn's Args are customized
        % Set the corresponding Checkbox to reflect this:
        set(useDfltCkb, 'Value', false);

        % Set x/y-Edt Strings:
        %nb_Sz = fcnArgs{1};% <------------------------------------------------------- 
        set(xEdt, 'String', num2str(fcnArgs{1}(2)));
        set(yEdt, 'String', num2str(fcnArgs{1}(1)));
    end
end

% Call the updUI() fcn to finalize the UI layout:
updUI;

%% Callbacks -------------------------------------------------------------
    function updUI
        if get(useDfltRB, 'Value') %== true % 'Use default fcn' is selected
            % Enable uicontrols on the top sub-figure; 
            % set up fcn and fcnArgs values.
            set(useDfltCkb, 'Enable', 'on'); % enable 'Use default fcn's Args' checkbox
            fcn = defaultFcn;
            if get(useDfltCkb, 'Value') %== true % 'Use default fcn's Args' is checked
                % Set up fcnArgs value to its default:
                fcnArgs = defaultFcnArgs;
                % Set x/yEdits' Strings:
                set(xEdt, 'String', num2str(fcnArgs{1}(2)));
                set(yEdt, 'String', num2str(fcnArgs{1}(1)));
                % Fix uicontrols' colors and re-enable Appy btn: % <---------------------------- FIX COLORS !!!
                set(xEdt, 'BackgroundColor', [1 1 1]); % white BG for the xEdit 
                set(xTxt, 'ForegroundColor', [0 0 0]); % black font color for the xTxt
                set(yEdt, 'BackgroundColor', [1 1 1]); % white BG for the yEdit 
                set(yTxt, 'ForegroundColor', [0 0 0]); % black font color for the yTxt
                % ... move to other place ... % <------------------------------------------------ FIX COLORS !!!
                
                set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
            else
                set(xEdt, 'Enable', 'on');
                set(yEdt, 'Enable', 'on');
                set(useSameCkb, 'Enable', 'on');
                xSz = str2num(get(xEdt, 'String'));
                ySz = str2num(get(yEdt, 'String'));
                fcnArgs = {[ySz xSz]};
            end

            % Set up Strings for the bottom sub-figure uicontrols and
            % disable them; fix their colors.
            set(usrFcnEdt, 'String', func2str(fcn));
            set(usrFcnEdt, 'Enable', 'off');
            set(usrFcnEdt, 'BackgroundColor', [1 1 1]); % white BG for the usrFcn-Edit % <---------------------------- FIX COLORS !!!
            set(usrFcnTxt, 'ForegroundColor', [0 0 0]); % black font color for its Txt label
            % *
            fcnArgsStr = dmCellArrayToString(fcnArgs);
            set(usrFcnArgsEdt, 'String', fcnArgsStr);
            set(usrFcnArgsEdt, 'Enable', 'off'); 
            set(usrFcnArgsEdt, 'BackgroundColor', [1 1 1]); % white BG for the usrFcnArgs-Edit % <---------------------------- FIX COLORS !!!
            set(usrFcnArgsTxt, 'ForegroundColor', [0 0 0]); % black font color for its Txt label

        else % 'Use custom fcn' is selected
            % Disable uicontrols on the top sub-figure and enable on the
            % bottom
            set(xEdt, 'Enable', 'off');
            set(yEdt, 'Enable', 'off');
            set(useSameCkb, 'Enable', 'off');
            set(useDfltCkb, 'Enable', 'off');
            set(usrFcnEdt, 'Enable', 'on');
            set(usrFcnArgsEdt, 'Enable', 'on');
            %set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn -- NO!!
            
        end
    end

% Radiobuttons' callback
    function rbCallback(src, ~)
        if strcmpi(get(src, 'Tag'), 'use_default_fcn')
            otherBR = useCustomRB;
        else
            otherBR = useDfltRB;
        end
        set(src, 'Value', true);
        set(otherBR, 'Value', false);
        updUI;
    end

% Callback for 'Use default multipliers' Checkbox
    function useDfltCkbCallback(src, ~)
        if get(src, 'Value') %== true % the Checkbox is checked
            % Disable x/yEdits and 'Use same x and y' Checkbox
            set(xEdt, 'Enable', 'off');
            set(yEdt, 'Enable', 'off');
            set(useSameCkb, 'Enable', 'off');

            % Set up fcnArgs value to its default
            fcnArgs = defaultFcnArgs;

            % Set x/yEdits' and usrFcnArgsEdt's Strings
            set(xEdt, 'String', num2str(fcnArgs{1}(2)));
            set(yEdt, 'String', num2str(fcnArgs{1}(1)));
            fcnArgsStr = dmCellArrayToString(fcnArgs);
            set(usrFcnArgsEdt, 'String', fcnArgsStr);

            % Fix uicontrols' colors and re-enable Appy btn
            set(xEdt, 'BackgroundColor', [1 1 1]); % white BG for the xEdit 
            set(xTxt, 'ForegroundColor', [0 0 0]); % black font color for the xTxt
            set(yEdt, 'BackgroundColor', [1 1 1]); % white BG for the yEdit 
            set(yTxt, 'ForegroundColor', [0 0 0]); % black font color for the yTxt
            set(usrFcnArgsEdt, 'BackgroundColor', [1 1 1]); % white BG for the usrFcnArgs-Edit 
            set(usrFcnArgsTxt, 'ForegroundColor', [0 0 0]); % black font color for its Txt label
            set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn

        else % the Checkbox is UNchecked
            % Enable x/yEdits and 'Use same x and y' Checkbox
            set(xEdt, 'Enable', 'on');
            set(yEdt, 'Enable', 'on');
            set(useSameCkb, 'Enable', 'on');
        end
    end

% Callback for xEdt
    function xEdtCallback(src, ~)
        str = get(src, 'String'); % <---------------------------------------------------------------- STOPPED HERE 
        val = str2num(str);
        if isscalar(val) % ~isempty ... isscalar([]) is false
            set(src, 'String', num2str(val));
            set(src, 'BackgroundColor', [1 1 1]); % white BG for the Edit 
            set(xTxt, 'ForegroundColor', [0 0 0]); % black font color for the xTxt
            set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
            fcnArgs{1}(2) = val;
            if get(useSameCkb, 'Value') %==true %'Use same x and y' checked
                set(yEdt, 'String', num2str(val));
                fcnArgs{1}(1) = val;
                set(yEdt, 'BackgroundColor', [1 1 1]); % white BG for the yEdit 
                set(yTxt, 'ForegroundColor', [0 0 0]); % black font color for the yTxt
            end
            fcnArgsStr = dmCellArrayToString(fcnArgs);
            set(usrFcnArgsEdt, 'String', fcnArgsStr);

        else % wrong value is passed
            set(src, 'BackgroundColor', hsv2rgb([0.04, 0.15, 1])); % light red
            set(xTxt, 'ForegroundColor', [1 0 0]); % red font color for the xTxt
            set(applyBtn, 'Enable', 'off'); % disable 'Apply' btn
        end
    end

% Callback for yEdt
    function yEdtCallback(src, ~)
        str = get(src, 'String');
        val = str2num(str);
        if isscalar(val) % ~isempty ... isscalar([]) is false
            set(src, 'String', num2str(val));
            set(src, 'BackgroundColor', [1 1 1]); % white BG for the Edit 
            set(yTxt, 'ForegroundColor', [0 0 0]); % black font color for the yTxt
            set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
            fcnArgs{1}(1) = val;
            if get(useSameCkb, 'Value') %==true %'Use same x and y' checked
                set(xEdt, 'String', num2str(val));
                fcnArgs{1}(2) = val;
                set(xEdt, 'BackgroundColor', [1 1 1]); % white BG for the xEdit 
                set(xTxt, 'ForegroundColor', [0 0 0]); % black font color for the xTxt
            end
            fcnArgsStr = dmCellArrayToString(fcnArgs);
            set(usrFcnArgsEdt, 'String', fcnArgsStr);

        else % wrong value is passed
            set(src, 'BackgroundColor', hsv2rgb([0.04, 0.15, 1])); % light red
            set(yTxt, 'ForegroundColor', [1 0 0]); % red font color for the yTxt
            set(applyBtn, 'Enable', 'off'); % disable 'Apply' btn
        end
    end

% Callback for 'Use same x and y' Checkbox
    function useSameCkbCallback(src, ~)
        if get(src, 'Value') %==true %'Use same x and y' checked
            xStr = get(xEdt, 'String');
            yStr = get(yEdt, 'String');
            xVal = str2num(xStr);
            yVal = str2num(yStr);
            % If xVal is correct use it to update yVal and make yVal
            % correct. Existing yVal is ignored and being overwritten.
            if isscalar(xVal)
                set(yEdt, 'String', num2str(xVal));
                fcnArgs{1}(1) = xVal;
                set(yEdt, 'BackgroundColor', [1 1 1]); % white BG for the yEdit 
                set(yTxt, 'ForegroundColor', [0 0 0]); % black font color for the yTxt
                fcnArgsStr = dmCellArrayToString(fcnArgs);
                set(usrFcnArgsEdt, 'String', fcnArgsStr);
                set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
                return;

            elseif isscalar(yVal)
            % If xVal is NOT correct try to use yVal. If yVal is correct
            % use it to update xVal and make xVal correct.
                set(xEdt, 'String', num2str(yVal));
                fcnArgs{1}(2) = yVal;
                set(xEdt, 'BackgroundColor', [1 1 1]); % white BG for the yEdit 
                set(xTxt, 'ForegroundColor', [0 0 0]); % black font color for the yTxt
                fcnArgsStr = dmCellArrayToString(fcnArgs);
                set(usrFcnArgsEdt, 'String', fcnArgsStr);
                set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
            end
        end
    end

% Callback for 'User's fcn' Edit
    function usrFcnEdtCallback(src, ~)
        str = get(src, 'String');
        try
            fcn = str2func(str);
            set(src, 'String', func2str(fcn));
            set(src, 'BackgroundColor', [1 1 1]); % white BG for the Edit 
            set(usrFcnTxt, 'ForegroundColor', [0 0 0]); % black font color for its Txt label
            set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
        catch
            set(src, 'BackgroundColor', hsv2rgb([0.04, 0.15, 1])); % light red
            set(usrFcnTxt, 'ForegroundColor', [1 0 0]); % red font color for its Txt label
            set(applyBtn, 'Enable', 'off'); % disable 'Apply' btn
        end
    end

% Callback for 'User's fcn Args' Edit
    function usrFcnArgsEdtCallback(src, ~)
        str = get(src, 'String');
        if isempty(str)
            fcnArgs = {};
            set(src, 'BackgroundColor', [1 1 1]); % white BG for the Edit 
            set(usrFcnArgsTxt, 'ForegroundColor', [0 0 0]); % black font color for its Txt label
            set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
            return
        end

        % The String is non-empty
        try
            fcnArgs = eval(str);
            fcnArgsStr = dmCellArrayToString(fcnArgs);
            set(usrFcnArgsEdt, 'String', fcnArgsStr);
            %
            set(src, 'BackgroundColor', [1 1 1]); % white BG for the Edit 
            set(usrFcnArgsTxt, 'ForegroundColor', [0 0 0]); % black font color for its Txt label
            set(applyBtn, 'Enable', 'on'); % re-enable 'Apply' btn
        catch
            set(src, 'BackgroundColor', hsv2rgb([0.04, 0.15, 1])); % light red
            set(usrFcnArgsTxt, 'ForegroundColor', [1 0 0]); % red font color for its Txt label
            set(applyBtn, 'Enable', 'off'); % disable 'Apply' btn
        end
    end

% 'Cancel' btn callback
    function cancelBtnPushed(~, ~)
        % Close the modal dialog window
        delete(fig);
    end

% 'Apply' btn callback
    function applyBtnPushed(~, ~) % <--------------------------------------------------------- REMOVE DEBUG MSGs !!!
        % for debug propose ...
        disp(defaultFcn);
        disp(fcn);
        disp(defaultFcnArgs);
        disp(fcnArgs);
        disp(' -------------------------------------------------------- ')

        % Set the obj's properties
        obj.FiltFcn = fcn;
        obj.FiltFcnArgs = fcnArgs;

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
