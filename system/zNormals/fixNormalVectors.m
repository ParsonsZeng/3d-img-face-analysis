function n = fixNormalVectors(pts, n)
%function n = fixNormalVectors(pts, n)
%
%Koryguje zwroty wektor�w normalnych wykorzystuj�c po�o�enie 
%�rodka ci�ko�ci danych. Ustawia zwroty na zgodne z wektorem od 
%�rodka ci�ko�ci do punktu zaczepenia normalnej do powierzchni.
%Parametery:
% pts - macierz wierszy (x,y,z) wsp�rz�dnych punkt�w 
% n - macierz wierszy (x,y,z) odpowiadaj�cych wsp�rz�dnym wektor�w
% normalnych
%Zwraca:
% n - skorygowana macierz (poprawione zwroty)

%--------------------------------------------------------------------------
%unify orientation according to data mean direction:
n = fixNormals(pts, pts, n);
%--------------------------------------------------------------------------