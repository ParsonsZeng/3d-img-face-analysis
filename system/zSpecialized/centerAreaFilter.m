function [pts mask] = centerAreaFilter(pts, radius)
%Wycina punkty le��ce w kuli o �rodku w punkcie ci�ko�ci i zadanym
%promieniu. 

centroid = getCentroid(pts);
[pts mask] = getNeighbours(centroid, radius, pts);
