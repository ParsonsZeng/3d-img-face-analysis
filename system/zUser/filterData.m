function [pts ptsClusters removedToSmall clusterSize] = filterData(pts, options)
%Filtruje i wst�pnie przetwarza dane w celu usuni�cia szumu. Implementuje
%filtracj� przez segmentacj� w grupy po��czone.
%Parametry:
% pts - dane do przefiltrowania
% options - opcje filtrowania
%Zwraca:
% pts - przefiltrowane dane
% ptsClusters - przyporz�dkowanie punkt�w do klaster�w
% removedToSmall - liczba usuni�tych (odfiltrowanych punkt�w)
% clusterSize - wektor rozmiar�w klaster�w

%--------------------------------------------------------------------------

%Wymu� utworzenie struktury opcji:
if nargin<2
    options.null = 0; 
end;

maxDistanceCoeff = getOption(options, 'connectivityCoeff', 0.7);
minFractionOfPtsInCluster = getOption(options, 'clusterFrac', 0.1);

%--------------------------------------------------------------------------

%clustering:
ptsClusters = connectionClustering(pts, maxDistanceCoeff);
clusterSize = analiseClusters(ptsClusters);

%simple filtering:
beforeRemovalSize = size(pts, 1);
[pts ptsClusters] = keepEnoughBigClusters(pts, ptsClusters, ...
        clusterSize, minFractionOfPtsInCluster);
removedToSmall = beforeRemovalSize - size(pts, 1);

