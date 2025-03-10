function poltData(obj, GelDataObj, selectionMask)

%   *** Use the following properties:
% SelectionImg - to keep prepared Img displaying the selection on the gel
% hPlot_3 - array of Line objects on hAxes_3 (for PflsVertCentral)
% hPlot_4 - array of Line objects on hAxes_4 (for PflsVertLeft)
% hPlot_5 - array of Line objects on hAxes_5 (for PflsHorizontal)
% hPlot_6 - array of Line objects on hAxes_6 (for PflsVertRight)

% Define Constants ...
%(LOAD them later from separate constants definition file! - NOW IS READY!)
SelectionImgBGColor = hsv2rgb([1/12, 0.3125, 1]); % light orange close to white
SelectionTrackColor = [0, 1, 0]; % green as is ;)
SelectionTrackLineWidth = 2; %dmGEL.Constants. ...
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
%              ----------------------------------------

% Make required calculations; update vals of the corresponding properties.
obj.genSelectionImg(GelDataObj, selectionMask);
obj.calcPfls(GelDataObj, selectionMask);



% The Plot Legend should look like:
% Original
% Filtered
% BackGrnd
% BG-crted

end