function [n] = fixNormals(pts, descPts, n)
%function [n] = fixNormals(pts, descPts, n)
%
%Koryguje zwroty wektor�w normalnych wykorzystuj�c po�o�enie 
%�rodka ci�ko�ci danych. Ustawia zwroty na zgodne z wektorem od 
%�rodka ci�ko�ci do punktu zaczepenia normalnej do powierzchni.
%Parametery:
% pts - macierz wierszy (x,y,z) wsp�rz�dnych punkt�w 
% descPts - punkty dla kt�rych policzono kierunki normalnych
% n - macierz wierszy (x,y,z) odpowiadaj�cych wsp�rz�dnym wektor�w
% normalnych
%Zwraca:
% n - skorygowana macierz (poprawione zwroty)

%--------------------------------------------------------------------------

%unify orientation according to data mean direction:
centroid = getCentroid(pts);
cDirection = descPts - repmat(centroid, size(descPts,1), 1); %centroid direction
invNIxs = dot(n, cDirection, 2)<0; %wrong normal orientation
n(invNIxs, :) = -n(invNIxs, :);    %inverts wrongly oriented normal vectors

%--------------------------------------------------------------------------