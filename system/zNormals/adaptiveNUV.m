function [n u v] = adaptiveNUV(pts, selIxs)
%---------------------------Wrapper----------------------------------------
%Pe�na procedura generacji kierunk�w normalnych i p�aszczyzn stycznych dla
%wybranego podzbioru punkt�w.
%Parametry:
% pts - punkty (x,y,z).
% selIxs - wektor indeks�w dla kt�rych wygenerowa� warto�ci (n,u,v).
%Zwracane:
% n,u,v - macierze warto�ci wsp�rz�dnych kierunk�w normalnych i wektor�w 
% okre�laj�cych kierunki stycznych do powierzchni w punkcie. 
% Uwaga: d�ugo�ci (n,u,v) == d�ugo�� pts.

%--------------------------------------------------------------------------
[nSel uSel vSel] = adaptiveNormalsForFeaturePts(pts, pts(selIxs,:) );

ptsSize = size(pts, 1);
n = zeros(ptsSize, 3);
u = zeros(ptsSize, 3);
v = zeros(ptsSize, 3);
n(selIxs,:) = nSel;
u(selIxs,:) = uSel;
v(selIxs,:) = vSel;
%--------------------------------------------------------------------------

%{
neigborhoodRadius = estimatePCANeighborhoodRadius(pts);
[n u v] = findNUV(pts, neigborhoodRadius, selIxs);
n = fixNormalVectors(pts, n);
%}
