function [n u v] = adaptiveNormalsForFeaturePts(pts, descPts)
%Pe�na procedura generacji kierunk�w normalnych i p�aszczyzn stycznych dla
%wybranych punkt�w.
%Parametry:
% pts - punkty (x,y,z).
% descPts - punkty dla kt�rych wygenerowane zostan� kierunki normalnych.
%Zwracane:
% n,u,v - macierze warto�ci wsp�rz�dnych kierunk�w normalnych i wektor�w 
% okre�laj�cych kierunki stycznych do powierzchni w punkcie. 

%--------------------------------------------------------------------------

neigborhoodRadius = estimatePCANeighborhoodRadius(pts);
[n u v] = findNormals(pts, neigborhoodRadius, descPts);
n = fixNormals(pts, descPts, n);

%--------------------------------------------------------------------------