function exportProfiles(obj)

disp(' >>> improfPlotUI : DATA ---> Export Intensity Profiles')

filter = {'*.DAT;*.dat', 'DAT-files (*.DAT,*.dat)'; ...
        '*.CSV;*.csv', 'Comma Separated Values (*.CSV,*.csv)'; ...
        '*.TXT;*.txt', 'Text files (*.TXT,*.txt)'; ...
        '*.*','All Files (*.*)'};
header = 'Select a file to export Intensity Profiles to as CSV';
defname = 'Intensity_Profiles.CSV';
[fname, fpath] = uiputfile(filter, header, defname);
if isequal(fname, 0) % cancelled by user
    return
end

%% Prepare the data to export.
% Add X-axes values to profiles.
PVC = 1:size(obj.PflsVertCentral, 1); % Vertical Central
PVC = [PVC(:), obj.PflsVertCentral];

PHC = 1:size(obj.PflsHorizontal, 1); % Horizontal Central
PHC = [PHC(:), obj.PflsHorizontal];

PVL = 1:size(obj.PflsVertLeft, 1); % Vertical Left
PVL = [PVL(:), obj.PflsVertLeft];

PVR = 1:size(obj.PflsVertRight, 1); % Vertical Right
PVR = [PVR(:), obj.PflsVertRight];

% Combine profiles to single cell array.
dataCell = dmGEL.dmAUX.matrices2CSVreadyCell(PVC, PHC, PVL, PVR);

%% Prepend data header
col_hdrs = {'Distance along profile', ...
    'Original Grayscale', ...
    'Filtered', ...
    'BackGrnd', ...
    'BG-crted', ...
    'Selected'};

if dmGEL.Constants.PflsExportTwoLineHdr
    % construct 2-lined header 
    line_1 = [...
        repmat({'Vertical Central'},   [1, 6]), ...
        repmat({'Horizontal Central'}, [1, 6]), ... 
        repmat({'Vertical Left'},      [1, 6]), ... 
        repmat({'Vertical Right'},     [1, 6]) ...
        ];
    line_2 = repmat(col_hdrs, [1, 4]);
    dataCell = [line_1; line_2; dataCell];

else
    % construct single lined header
    pfx = {'VC: ', 'HC: ', 'VL: ', 'VR: '};
    hdr_line = cell(1, 24);
    k_oset = 0;
    for p = 1:4
        for k = 1:6
            hdr_line(k_oset + k) = {[pfx{p}, col_hdrs{k}]};
        end
        k_oset = k_oset + 6;
    end
    dataCell = [hdr_line; dataCell];
end

%% Try to export
selectedFile = fullfile(fpath, fname);
try
    % cellArrayToCSV(cellArray, filename, numPrecFmt, isComplexSrings, appendMode)
    dmGEL.dmAUX.cellArrayToCSV(dataCell, selectedFile, ...
        dmGEL.Constants.PflsExportNumPrecisionORformat, false, true)
catch ME
    msg = sprintf('Can not save Intensity Profiles to the file: \n%s\n%s', ...
        selectedFile, ME.message);
        errordlg(msg, 'Can not save Session to the file', 'modal');
end
end
