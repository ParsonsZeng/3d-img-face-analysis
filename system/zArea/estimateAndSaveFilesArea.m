function [areas] = estimateAndSaveFilesArea(storageFile, ...
        files, areaNoOfTestPts, areaReferenceDistance)
%Estymacja powierzchni dla listy plik�w. Je�li istnieje to jest wczytywana
%z pliku. Je�li nie to jest tworzona i zapisywana w pliku.

if exist(storageFile, 'file')
    areas = ioReadVector(storageFile);
else    
    areas = estimateFilesArea(files, areaNoOfTestPts, areaReferenceDistance);   
    ioStoreVector(storageFile, areas);
end;

