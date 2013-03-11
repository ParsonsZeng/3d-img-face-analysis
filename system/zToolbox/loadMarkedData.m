function [pts markers] = loadMarkedData(dirPath, fileName)
%�aduje plik oraz mask�. 
%Plik i maska powinny r�ni� si� tylko rozszerzeniem. 
%U�ywane w obliczaniu parametr�w dla wycinania danych.

pts = ioLoad3dData([dirPath fileName '.txt']);
mask = imread([dirPath fileName '.png']);

markers = markData(pts, mask, 0, 0, 0); 