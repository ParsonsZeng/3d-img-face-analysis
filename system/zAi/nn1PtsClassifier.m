function [classes] = nn1PtsClassifier(pts, selClasses, selIxs)
%Klasyfikuje punkty 1-nn na podstawie przypisania do klas podzbioru punkt�w.
%Parametry:
% pts - wszystkie punkty
% selIxs - indeksy wybranych punkt�w
% selClasses - klasy podzbioru punkt�w
%Zwracane:
% classes - przypisanie do klas dla wszystkich punkt�w

wbar = guiStartWaitBar(0, 'Points classification...');

featurePts = pts(selIxs, :);
noOfFPts = size(featurePts, 1);
noOfPts = size(pts, 1);

classes = zeros(noOfPts, 1);
for i = 1:noOfPts
    
    guiSetWaitBar(i/noOfPts);
    
    %find nearest neighbor in feature points
    pt = pts(i, :);    
    distances = sum(  (featurePts - repmat(pt, noOfFPts, 1)).^2, 2);
    [nnDist, nnIx] = min(distances);
    
    %copy from nearest neighbor
    classes(i, :) = selClasses(nnIx, :);   
end;    

guiStopWaitBar(wbar);