function posVec = hgposTop2Bottom(posVec, pph)
% posVec = hgposTop2Bottom(posVec, parentPos)
% Convert (in both directions) format of HG-object 'Position' vector:
% [left, BOTTOM, width, height] <--> [left, TOP, width, height]
% using height of the 'Parent' HG-object (ParentHeight) as follows:
% BOTTOM + TOP = ParentHeight - height
% * parentPos could be either scalar - height value of the parent hg-object
%   or Parent's 'Position' vector [l b w h].

if isscalar(pph)
    % pph is ParentHeight value
    PH = pph;
else
    % pph is assumed to be Parent's 'Position' vector
    PH = pph(4);
end
h = posVec(4);
b = posVec(2);
t = PH - h - b;

if t < 0
    error('%s\n%s\n', ...
        'Can not convert Position vector from/to TOP (BOTTOM)-based format.', ...
        'Specified ParentHeight is too small !');
end

posVec(2) = t;
end

