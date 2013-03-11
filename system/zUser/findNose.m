function [subPts bgPts,  fgSeedPts, bgSeedPts, ...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  matchingCost subMask]...
= findNose(pts, roiMask)

%--------------------------------------------------------------------------
%Ustawienia:

%deskryptory:
distance = 70;
alfaBins = 10;
betaBins = 10;
alfaAxes = 'log';
betaAxes = 'log';

options.matchingRule = 'OR';
options.matchingDistanceType = 1;

%po ile deskryptor�w zbudowa� we wzorcach:
noOfSpinImgs = 30; 

%ile deskryptor�w u�y� we wszystkich wzorcach ��cznie:
%(musi ich by� mniej ni� noOfSpinImgs*liczba wzorc�w)
options.useNoSeedPts = 150;

%filtrowanie punkt�w poszukiwanego regionu:
options.connectivityCoeff = 1.0;
options.clusterFraction = 0.5;

%filtrowanie punkt�w t�a:
options.k = 3;
options.positiveWeight = 2;
options.negativeWeight = 1;

%klasyfikator:
options.force = 1;
options.classifier = 'wknn';
options.altClassifier = 'knn';

options.classifierOptions.k = 3;
options.classifierOptions.positiveWeight = 3;
options.classifierOptions.positiveWeight = 1;
options.classifierOptions.hiddenNeurons = 3;
options.classifierOptions.bpEpochs = 150;
options.classifierOptions.lmEpochs = 50;
options.classifierOptions.noOfNetworks = 3;

%Filtrowanie wynik�w klasyfikacji
options.classifierOptions.connectivityCoeff = 0.4;
options.classifierOptions.clusterFraction = 0.5;

%ustawienie regionu zainteresowania:
if exist('roiMask', 'var')
    options.roiMask = roiMask;
end;    

%----------------------------------
%Wzorce i maski:

areasFile = 'patterns\wycNosa\patternsAreas';

f1  = 'patterns\wycNosa\cara8_abajo_pattern.txt';
fm1 = 'patterns\wycNosa\cara8_abajo_nose.png';
fn1 = 'patterns\wycNosa\cara8_abajo_nose.txt';
fd1 = 'patterns\wycNosa\nosedesc_cara8_abajo_nose.txt';

f2  = 'patterns\wycNosa\cara9_frontal2_pattern.txt';
fm2  = 'patterns\wycNosa\cara9_frontal2_nose.png';
fn2  = 'patterns\wycNosa\cara9_frontal2_nose.txt';
fd2 = 'patterns\wycNosa\nosedesc_cara9_frontal2_nose.txt';

f3  = 'patterns\wycNosa\cara10_risa_pattern.txt';
fm3  = 'patterns\wycNosa\cara10_risa_nose.png';
fn3  = 'patterns\wycNosa\cara10_risa_nose.txt';
fd3 = 'patterns\wycNosa\nosedesc_cara10_risa_nose.txt';


f4  = 'patterns\wycNosa\cara11_frontal1_pattern.txt';
fm4  = 'patterns\wycNosa\cara11_frontal1_nose.png';
fn4  = 'patterns\wycNosa\cara11_frontal1_nose.txt';
fd4 = 'patterns\wycNosa\nosedesc_cara11_frontal1_nose.txt';

f5  = 'patterns\wycNosa\cara12_frontal2_pattern.txt';
fm5  = 'patterns\wycNosa\cara12_frontal2_nose.png';
fn5  = 'patterns\wycNosa\cara11_frontal1_nose.txt';
fd5 = 'patterns\wycNosa\nosedesc_cara12_frontal2_nose.txt';

%------------------------------------------------

options.spinDistance = distance;
options.alfaBins = alfaBins;
options.betaBins = betaBins;
options.alfaAxes = char(alfaAxes);
options.betaAxes = char(betaAxes);

%--------------------------------------------------------------------------
%Za�adowanie (zbudowanie) wzorc�w:

%wyb�r punkt�w:
global seedMethod;
seedMethod = 'kmeans';

[mpts markers] = loadMarkedData2(f1, fm1);
 buildAndStoreDescriptorSub(mpts, markers, fd1, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);


[mpts markers ] = loadMarkedData2(f2, fm2);
buildAndStoreDescriptorSub(mpts, markers, fd2, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

[mpts markers ] = loadMarkedData2(f3, fm3);
buildAndStoreDescriptorSub(mpts, markers, fd3, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);


[mpts markers ] = loadMarkedData2(f4, fm4);
buildAndStoreDescriptorSub(mpts, markers, fd4, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);


[mpts markers ] = loadMarkedData2(f5, fm5);
buildAndStoreDescriptorSub(mpts, markers, fd5, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

    
%--------------------------------------------------------------------------

%wyb�r punkt�w:
global seedMethod;
seedMethod = 'oct';

%Wyszukanie regionu:
patternAreas = estimateAndSaveFilesArea(areasFile, {fn1, fn2, fn3, fn4, fn5}, 100, 2);
[subPts bgPts ...
 fgSeedPts, bgSeedPts,...
 hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
 matchingCost subMask] = findSubPatterns...
 (pts, patternAreas, {fd1, fd2, fd3, fd4, fd5}, options);

%--------------------------------------------------------------------------
