function [selectedClusterNo selectedClusterCost clusterMatchingCosts] = ...
matchToPatternCluster(patterSpinImgs, noOfClusters, ...
 selIxs, spinImgs, ... 
 matchingRule, matchingDistanceType)
%Dopasowuje klaster do klastra wzorca.
% 
%Parametry:
% patterSpinImgs - deskryptory wzorca
% noOfClusters - liczba klaster�w
% selIxs - kom�rki zawieraj�ce wektory indeks�w punkt�w w klasterach dla
%  kt�rych liczono deskryptory
% spinImgs - deskryptory dla kolejnych klaster�w (w kolejnych kom�rkach) 
% matchingRule - regu�a dopasowywania klaster�w do wzorca
% matchingDistanceType - metoda liczenia odleg�o�ci mi�dzy deskryptorami
% 
%Zwraca:
% selectedClusterNo - numer klastera najlepiej dopasowanego do wzorca
% selectedClusterCost - koszt dopasowania najlepiej pasuj�cego klastera
% clusterMatchingCosts - wektor koszt�w dopasowania dla wszystkich
%  klaster�w

%retrieve number of descriptors in pattern desc
noOfPatternDescs = size(patterSpinImgs, 1);

%output buffers:
clusterMatchingCosts = zeros(noOfClusters, 1);

%for every cluster:
for clusterNo = 1:noOfClusters    
    
    %retrieve cluster's descriptor size
    clusterNoOfDescs = length( selIxs{clusterNo} );
    
    %filter empty clusters:
    if clusterNoOfDescs < 1
        clusterMatchingCosts(clusterNo) = inf;
        continue;
    end;    
     
    %build descriptor:
    patternSpin = patterSpinImgs(1:clusterNoOfDescs, :);
    matchingCostMatrix = buildMatchingCost(patternSpin, spinImgs{clusterNo}, ...
        matchingRule, matchingDistanceType);
    %try matching:
    [assignment clusterMatchingCosts(clusterNo)] = matchDescriptors(matchingCostMatrix);        
    
    %jesli udalo sie zrobic mniej deskryptorow niz bylo we wzorcu to
    %przeskaluj koszt dopasowania tak zeby liczba deskryptorow nie miala
    %wplywu na jakosc dopasowania:
    clusterMatchingCosts(clusterNo) = ...
        clusterMatchingCosts(clusterNo) * noOfPatternDescs/clusterNoOfDescs;
    
end;    

%find face cluster:
[selectedClusterCost selectedClusterNo] = min(clusterMatchingCosts);
