function hGELUI = dmGELQUANTtool
%dmGELQUANTtool
%hGELUI = dmGELQUANTtool
% The wrapper to call dmGEL.gelui without the package notation.
% hGELUI is the output of `hGELUI = dmGEL.gelui`.
% hGELUI is a handle to the dmGEL.gelui object created.

if nargout == 0
    dmGEL.gelui;
    return
else
    hGELUI = dmGEL.gelui;
end
end