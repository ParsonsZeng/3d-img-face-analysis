function [noOfClusters clusterPts selIxs n spinImgs] =  ...
    generateClusterData(pts, ptCluster, noOfSeedPoints, ...
    neigborhoodRadius, spinDistance, alfaBins, betaBins, alfaAxes, betaAxes)
%Generuje dane potrzebne do analizy klasterow.
%
%Parametry:
% pts - punkty
% ptCluster -  przypisanie punktow do klasterow
% noOfSeedPoints - ile punktow wybranych = ile deksryptorow zbudowa� dla
%  ka�dego klastera przy dopasowywaniu dla wzorca
% neigborhoodRadius - promien sasiedztwa uzywany przy liczeniu normalnych
% spinDistance, alfaBins, betaBins, alfaAxes, betaAxes - parametry
%  (generowanych dla kolejnych klaster�w) deskryptorow
%
%Zwraca: 
% noOfClusters - liczba klasterow (kom�rek)
% dane w kom�rkach dla kolejnych klasterow:
%  clusterPts - zbi�r punkt�w nale��cych do klastera
%  selIxs - zbi�r indeks�w punkt�w w klasterze dla kt�rych budowane s�
%   deskryptory
%  n - obliczone dla klaster�w kierunki wektor�w normalnych
%  spinImgs - obliczone dla klaster�w deskryptory


%retrieve number of clusters:
noOfClusters = max(ptCluster);

%output buffers:
clusterPts  = cell(noOfClusters, 1);
selIxs      = cell(noOfClusters, 1);
n           = cell(noOfClusters, 1);
spinImgs    = cell(noOfClusters, 1);


%for every cluster:
for clusterNo = 1:noOfClusters    
    
    %filter cluster points:
    clusterPts{clusterNo} = pts( ptCluster==clusterNo, :);    
    %cluter size:
    clusterSize = size(clusterPts{clusterNo}, 1);
    
    %Filter empty clusters:
    if clusterSize < 1 
        selIxs{clusterNo}   = [];
        n{clusterNo}        = [];
        spinImgs{clusterNo} = [];
        continue;
    end;        
    
    %generate feature points:
    selIxs{clusterNo} = getSeedPointsNo(clusterPts{clusterNo}, noOfSeedPoints);    
    
    %generate normal vectors:
    n{clusterNo} = findNUV(clusterPts{clusterNo}, neigborhoodRadius, selIxs{clusterNo});
    n{clusterNo} = fixNormalVectors(clusterPts{clusterNo}, n{clusterNo});
    
    %build descriptor:
    spinImgs{clusterNo} = buildModelDescriptor(clusterPts{clusterNo}, n{clusterNo}, ...
        selIxs{clusterNo}, spinDistance, alfaBins, betaBins, alfaAxes, betaAxes);    
        
end;    
