function [ptsDensity] = estimatePtsDensity ...
                        (pts, noOfTestPts, referenceDistance)
%function [ptsDensity] = estimatePtsDensity(pts, noOfTestPts, referenceDistance) 
%
%Estymuje �redni� gesto�� powierzchniow� punkt�w.
%Parametry:
% pts - punkty modelu.
% noOfTestPts - liczba punkt�w na kt�rych wykonywany b�dzie test g�sto�ci.
% referenceDistance - promie� s�siedztwa (kuli otaczaj�cej) dla ka�dego z 
% 	testowanych punkt�w.

%-------------------------------------------------------------------------

%wybieramy punkty testowe:
[selIxs noOfTestPts] = getSeedPointsNo(pts, noOfTestPts, 'rand');  %!

noOfNeighbors = zeros(noOfTestPts, 1); %liczba punktow w obszarze testowym
for i = 1:noOfTestPts
    pt = pts(selIxs(i), :);
    [neighbors] = getNeighbours(pt, referenceDistance, pts); 
    noOfNeighbors(i) = size(neighbors, 1);
end;

%estymata gestosci powierzchniowej liczby punktow:
noOfPts = mean(noOfNeighbors);
area = pi * referenceDistance * referenceDistance;
ptsDensity = noOfPts / area;
