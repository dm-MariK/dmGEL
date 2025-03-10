function calcPfls(obj, GelDataObj, selectionMask)

% Process the Selection's geometry. 
% Find x and y of its center and its width. We do NOT want to use here
% getPixelPosition() and getPosition() methods of roiPolygon class since
% this is to verify our results as most independent way as it is possible.
[r, c] = size(selectionMask);
xMin = c;
xMax = 1;
for y = 1:r
    k = find(selectionMask(y,:));
    if isempty(k)
        continue
    end
    if min(k) < xMin
        xMin = min(k);
    end
    if max(k) > xMax
        xMax = max(k);
    end
end
xCntr = round((xMin + xMax)/2);
xDist = xMax - xMin;
xLeft = xCntr - round(xDist * dmGEL.Constants.VertPflsHorizDist);
xRight = xCntr + round(xDist * dmGEL.Constants.VertPflsHorizDist);

yMin = r;
yMax = 1;
for x = 1:c
    k = find(selectionMask(:,x));
    if isempty(k)
        continue
    end
    if min(k) < yMin
        yMin = min(k);
    end
    if max(k) > yMax
        yMax = max(k);
    end
end
yCntr = round((yMin + yMax)/2);

% Calculate the Intensity profiles; keep them to this obj's properties.
%  - Horizontal profiles through the selection's center:
obj.PflsHorizontal = wrap_improfile([1; c], [yCntr; yCntr]);

%  - Vertical profiles through the selection's center:
obj.PflsVertCentral = wrap_improfile([xCntr; xCntr], [1; r]);

%  - Vertical profiles through the left part of the selection:
obj.PflsVertLeft = wrap_improfile([xLeft; xLeft], [1; r]);

%  - Vertical profiles through the right part of the selection:
obj.PflsVertRight = wrap_improfile([xRight; xRight], [1; r]);


%% Wrapper for the 'improfile' function
function P = wrap_improfile(xi, yi)
    % obtain the images from the GelDataObj and rescale them to [0, 1]
    O = im2double(GelDataObj.GrayScaledImg);
    F = im2double(GelDataObj.FilteredImg);
    B = im2double(GelDataObj.ImgBackGround);
    C = F - B;
    % calculate intensity profiles
    P(:,5) = improfile(selectionMask, xi, yi, 'nearest');
    P(:,1) = improfile(O, xi, yi, 'nearest');
    P(:,2) = improfile(F, xi, yi, 'nearest');
    P(:,3) = improfile(B, xi, yi, 'nearest');
    P(:,4) = improfile(C, xi, yi, 'nearest');
end

end