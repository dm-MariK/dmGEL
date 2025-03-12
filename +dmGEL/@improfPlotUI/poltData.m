function poltData(obj)

%   *** Use the following properties:
% SelectionImg - to keep prepared Img displaying the selection on the gel
% hPlot_3 - array of Line objects on hAxes_3 (for PflsVertCentral)
% hPlot_4 - array of Line objects on hAxes_4 (for PflsVertLeft)
% hPlot_5 - array of Line objects on hAxes_5 (for PflsHorizontal)
% hPlot_6 - array of Line objects on hAxes_6 (for PflsVertRight)
%              ----------------------------------------

% Add gel image to the Axes 1
show_image(obj.hAxes_1, obj.BGCorrectedImg);

% Add selection representing image to Axes 2
show_image(obj.hAxes_2, obj.SelectionImg);

% Add Vertical Central profiles to Axes 3
title_txt = 'Vertical profiles through the selection''s center';
obj.hPlot_3 = plot_profiles(obj.hAxes_3, obj.PflsVertCentral, title_txt);

% Add Vertical Left profiles to Axes 4
width_percent = (0.5 - dmGEL.Constants.VertPflsHorizDist) * 100;
width_percent_str = num2str(width_percent, 3);
title_txt = ['Vertical profile through the left ', width_percent_str ,'% of the selection''s width'];
obj.hPlot_4 = plot_profiles(obj.hAxes_4, obj.PflsVertLeft, title_txt);

% Add Horizontal Central profiles to Axes 5
title_txt = 'Horizontal profiles through the selection''s center';
obj.hPlot_5 = plot_profiles(obj.hAxes_5, obj.PflsHorizontal, title_txt);

% Add Vertical Right profiles to Axes 6
title_txt = ['Vertical profile through the right ', width_percent_str ,'% of the selection''s width'];
obj.hPlot_6 = plot_profiles(obj.hAxes_6, obj.PflsVertRight, title_txt);

%% To show gel images with profiles' tracks (to hAxes_1 and hAxes_2)
    function show_image(h_axes, Img)
        % make the axes be cleared on a new 'child' drawing
        set(h_axes, 'NextPlot', 'replace');
        % add the img
        imshow(Img, 'Parent', h_axes);
        % switch the axes to 'add' mode on new 'children' drawing
        set(h_axes, 'NextPlot', 'add');
        % add the profiles' tracks
        [r, c] = size(Img);
        plot(h_axes, [1; c], [obj.YCntr; obj.YCntr], ... % Horizontal central
            'LineWidth', dmGEL.Constants.SelectionTrackLineWidth, ...
            'Color', dmGEL.Constants.SelectionTrackColor);
        plot(h_axes, [obj.XCntr; obj.XCntr], [1; r], ... % Vertical central
            'LineWidth', dmGEL.Constants.SelectionTrackLineWidth, ...
            'Color', dmGEL.Constants.SelectionTrackColor);
        plot(h_axes, [obj.XLeft; obj.XLeft], [1; r], ... % Vertical Left
            'LineWidth', dmGEL.Constants.SelectionTrackLineWidth, ...
            'Color', dmGEL.Constants.SelectionTrackColor);
        plot(h_axes, [obj.XRight; obj.XRight], [1; r], ... % Vertical Right
            'LineWidth', dmGEL.Constants.SelectionTrackLineWidth, ...
            'Color', dmGEL.Constants.SelectionTrackColor);
        % switch the axes back to 'replace' mode on new 'children' drawing
        set(h_axes, 'NextPlot', 'replace');
    end

%% To plot image intensity profiles (to hAxes_3 - hAxes_6)
% The Plot Legend should look like:
% Original
% Filtered
% BackGrnd
% BG-crted
% Selected
    function lineObjArr = plot_profiles(h_plot_axes, Pdata, titleText)
        X = 1:size(Pdata, 1);
        set(h_plot_axes, 'NextPlot', 'replace');
        lineObjArr = plot(h_plot_axes, X, Pdata);
        set(lineObjArr(1), 'DisplayName', 'Original', ...
            'LineWidth', dmGEL.Constants.PlotOrigLineWidth, ...
            'Color', dmGEL.Constants.PlotOrigColor);
        set(lineObjArr(2), 'DisplayName', 'Filtered', ...
            'LineWidth', dmGEL.Constants.PlotFiltLineWidth, ...
            'Color', dmGEL.Constants.PlotFiltColor);
        set(lineObjArr(3), 'DisplayName', 'BackGrnd', ...
            'LineWidth', dmGEL.Constants.PlotBackLineWidth, ...
            'Color', dmGEL.Constants.PlotBackColor);
        set(lineObjArr(4), 'DisplayName', 'BG-crted', ...
            'LineWidth', dmGEL.Constants.PlotCrtdLineWidth, ...
            'Color', dmGEL.Constants.PlotCrtdColor);
        set(lineObjArr(5), 'DisplayName', 'Selected', ...
            'LineWidth', dmGEL.Constants.PlotSelectionLineWidth, ...
            'Color', dmGEL.Constants.PlotSelectionColor);
        xlabel(h_plot_axes, 'Distance along profile');
        ylabel(h_plot_axes, 'Normalized intensity');
        title(h_plot_axes, titleText);
        %
        %legend1 = legend(h_axes, 'show');
        legend(h_plot_axes, 'show');
    end
end