function genFigName(obj, GelDataObj)
% Extract file-name /or WS-var name from the 'GelDataObj's 'SessionName'
% property. See `importImg` method of `dmGEL.gelui` Class:
%   sessionName = ['dmGEL: ', 'name']
% Thus, `sessionName(7:end)` is `' name'`.

name = GelDataObj.SessionName;
name = name(7:end);
pfx = dmGEL.Constants.ImprofPlotInitFigName;
obj.FigName = [pfx, ':', name];
end