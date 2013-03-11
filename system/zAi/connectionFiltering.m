function [fgPts bgPts keptPointsMask] = connectionFiltering(fgPts, options)
%Filtruje punkty. Pozostawia punkty nale��ce do du�ych klastr�w i usuwa te
%nale��ce do ma�ych.
%Zwracane:
% fgPts - punkty zaklasyfikowane jako te do zatrzymania.
% bgPts - punkty odrzucone
% keptPointsMask - maska maj�ca '1' w indeksach odpowiadaj�cym punktom do
%  zatrzymania i '0' w indeksach do odrzucenia

%Test parametr�w:
if size(fgPts, 1) <= 0
    bgPts = [];
    keptPointsMask = [];
    return;
end;    

%--------------------------------------------------------------------------
%Opcje:
connectivityCoeff	= getOption(options, 'connectivityCoeff', 0.7);
clusterFraction     = getOption(options, 'clusterFraction', 0.4);

%--------------------------------------------------------------------------

%analiza przypisania do segmentow:
ptCluster = connectionClustering(fgPts, connectivityCoeff); 
clusterSize = analiseClusters(ptCluster);

%Wersja zachowuj�ca wszystkie odpowiednio du�e segmenty:
[fgPts faceSeedPtsClusters keptPointsMask bgPts] = ...
    keepEnoughBigClusters(fgPts, ptCluster, clusterSize, clusterFraction);
