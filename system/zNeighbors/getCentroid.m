function [centroid] = getCentroid(pts)
%Znajduje punkt ci�kosci zbioru punkt�w.
%Parametr:
% pts - punkty (x,y,z) w kolejnych wierszach macierzy.
%Wyj�cie
% centroid - wsp�rz�dne �rodka ci�ko�ci (wektor poziomy wsp�rz�dnych)

centroid = sum(pts, 1)/size(pts, 1);

end