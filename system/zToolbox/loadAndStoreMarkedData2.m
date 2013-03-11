function [pts markers fpts] = loadAndStoreMarkedData2(dataPath, maskPath, outPath)
%�aduje plik oraz mask�. 
%Nast�pnie wycina z wczytanych danych punkty odpowiadaj�ce masce i zapisuje je do pliku.

pts     = ioLoad3dData(dataPath);
mask    = imread(maskPath);

markers = markData(pts, mask, 0, 0, 0); 
fpts	= pts(markers, :);

%fprintf('Saving %i pts to %s\n', size(fpts,1), outPath);
ioStore3dRawData(outPath, fpts);