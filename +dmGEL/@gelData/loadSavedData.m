function loadSavedData(obj, s)
% Method to load saved class data from struct.
% This is to prevent loadobj() method from being called recursively.
% The object will be constructed on load.

% * to be added lated - logics to verify the DATA_VERSION
            
if isfield(s, 'CLASS') && isequal(s.CLASS, dmGEL.gelData.CLASS)
    % Load properties's values for "standard" properties:
    props2save = dmGEL.gelData.PROPS2SAVE;
    for k = 1:length(props2save)
        if isfield(s, props2save{k})
            obj.(props2save{k}) = s.(props2save{k});
        end
    end
    % Load functions:
    obj.FiltFcn = str2func(s.FiltFcn);
    obj.BGcalcFcn = str2func(s.BGcalcFcn);
    % Load functions's args:
    obj.FiltFcnArgs = eval(s.FiltFcnArgs);
    obj.BGcalcFcnArgs = eval(s.BGcalcFcnArgs);

    % Call refreshAll() method of Hgelui to make the gelui obj be prepared
    % for roiPolygon objecs construction.
    obj.Hgelui.refreshAll;

    % Reconstruct the array of roiPolygon objecs:
    delete(obj.HroiArr);
    obj.HroiArr = dmGEL.roiPolygon.empty;
    if isfield(s, 'HroiArr')
        for k = 1:length(s.HroiArr)
            position = s.HroiArr(k).Position;
            color = s.HroiArr(k).Color;
            obj.HroiArr(k) = dmGEL.roiPolygon(obj.Hgelui, position, color);
        end
    end

    % Just loaded session is always considered to be saved.
    obj.IsSaved = true;

else
    error('dmGEL.gelData : loadSavedData() : \n%s', ...
        'This is NOT saved gelData Object.');
end
end