function modalPos = bestModalFigPos(modal_w, modal_h, mainFigPos)
%modalPos = bestModalFigPos(modal_w, modal_h, mainFigPos)
% To be used in cases when you need to adjust position of some modal figure
% ('WindowStyle', 'modal') that appear as a reaction of some user's
% activity in the "main" UI (figure) of your GUI-application. 
% bestModalFigPos() uses width (modal_w) and height (modal_h) of the modal
% figure being rized and position vector (mainFigPos) of the main UI to put
% the modal figure at the center of the main UI.

cntr_l = mainFigPos(1) + round(mainFigPos(3)/2); % pos = [l b w h]
cntr_b = mainFigPos(2) + round(mainFigPos(4)/2);

modal_l = cntr_l - round(modal_w/2);
modal_b = cntr_b - round(modal_h/2);

modalPos = [modal_l, modal_b, modal_w, modal_h];
end