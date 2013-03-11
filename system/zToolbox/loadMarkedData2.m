function [pts markers fpts] = loadMarkedData2(dataPath, maskPath)
%�aduje plik oraz mask�. Nast�pnie wykorzystuje mask� do wyboru cz�ci
%punkt�w z danych. 

pts     = ioLoad3dData(dataPath);
mask    = imread(maskPath);

markers = markData(pts, mask, 0, 0, 0); 
fpts	= pts(markers, :);