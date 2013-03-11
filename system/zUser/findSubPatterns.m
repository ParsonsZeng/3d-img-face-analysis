function [subPts bgPts ...
          fgSeedPts, bgSeedPts, ...
		  hBgSeedPts bgSeedPtsMovedToFace hFaceSeedPts facePointsMovedToBg ...
		  matchingCost subMask] = findSubPatterns ...
		  (pts, patternAreas, patternDescFiles, options)
%Znajduje w zbiorze punkt�w obrazu 3D podzbi�r mo�liwie zgodny z wzorcem danym
%w postaci zestawu plik�w. Implementuje algorytm hierarchicznej lokalizacji
%region�w.
% 
%Parametry:
% pts - chmura punkt�w (obraz 3D) w kt�rej poszukiwany b�dzie wzorzec.
% patternAreas - wektor powierzchni wzorc�w.
% patternDescFiles - �cie�ki plik�w zawieraj�cych deskryptory wzorc�w
% (r�wnie� w postaci kom�rek). 
% options - struktura zawieraj�ca konfiguracj� zachowania si� procedury. 
%  Obs�ugiwane pola (w przypadku braku pola u�ywana jest warto�� domy�lna):
%  roiMask(ang. region of interest) - wektor binarny o d�ugo�ci r�wnej 
%   liczbie punkt�w: |roiMask| = |pts|. S�u�y on identyfikacji punkt�w 
%   kt�re nale�� do przeszukiwanego regionu i dla kt�rych podzbioru 
%   wygenerowane zostan� deskryptory. 
%  useNoSeedPts - sumaryczna dla wszystkich wzorc�w liczba deskryptor�w do
%   wygenerowania.
%  classifier - typ stosowanego klasyfikatora. Mo�liwe warto�ci: 
%   nn - sie� neuronowa, knn - k-najbli�szych s�said�w, wknn - wa�one k-nn.
%  classifierOptions - parametry specyficzne dla danego klasyfikatora.
% 
%Zwracane:
% subPts - punkty zaklasyfikowane jako nale��ce do wzorca
% bgPts - punkty zaklasyfikowane jako nienale��ce do wzorca
%
% fgSeedPts - punkty ucz�ce (takie dla kt�rych wygenerowano deskryptory) 
%  dopasowane w wyniku wykonania algorytmu w�gierskiego do wzroc�w.
% bgSeedPts - punkty ucz�ce, kt�re nie zosta�y dopasowane do wzorc�w. 
%  Pos�u�y�y one identyfikacji otoczenia poszukiwanego regionu - t�a.
%
% hBgSeedPts = bgSeedPts.
% hBgSeedBadPts - zbi�r punkt�w zaklasyfikowany jako t�o ale odrzuconych
%  w filtrowaniu.
% hFaceSeedPts = fgSeedPts.
% hFaceSeedBadPts - zbi�r punkt�w ucz�cych zaklasyfikowanych jako
%  odpowiadaj�ce wzorcowi, ale odrzuconych po analizie sp�jno�ci.
%
% matchingCost - sumaryczny koszt dopasowania deskryptor�w wzorc�w do
%  deskryptor�w obrazu analizowanego.


%------------------------------------------------ 

% force creation of options:
options.null = 0; 

%maska regionu dla kt�rego budowa� deskryptory (region of interest)
options.roiMask = getOption(options, 'roiMask', logical( 1:size(pts,1) )' );
roiMask = options.roiMask;

%deskryptory:
spinDistance = getOption(options, 'spinDistance', 100);
alfaBins     = getOption(options, 'alfaBins', 10);
betaBins     = getOption(options, 'betaBins', 10);
alfaAxes     = getOption(options, 'alfaAxes', 'log');
betaAxes     = getOption(options, 'betaAxes', 'log');

% parametry:
noOfPatterns	= min( [length(patternDescFiles) length(patternAreas)] );

%ile maksymalnie deskryptor�w wygenerowa� dla danych testowanych (na wzorzec):
maxSeedPtsNo            = getOption(options, 'maxSeedPtsNo', 10000);
%  ile obraz�w obrotu u�y� z wzorc�w ��cznie:
useNoSeedPts            = getOption(options, 'useNoSeedPts', 150); 
% ustawienie liczby deskryptor�w przypadaj�cej na kazdy z plikow wzorca:
seedPtsPerPatternNo 	= round(useNoSeedPts/noOfPatterns);

% jakiego klasyfikatora u�y�:
classifier      = getOption(options, 'classifier', 'nn');
% klasyfikator awaryjny (gdy powy�szy nie daje rady z klasyfikacj�):
altClassifier   = getOption(options, 'altClassifier', 'knn');
% opcje przekazywane do klasyfikatora:
cOptions        = getOption(options, 'classifierOptions', struct);
forceFinding    = getOption(options, 'force', 0);

% parametry estymacji powierzchni:
areaNoOfTestPts = getOption(options, 'areaNoOfTestPts', 100);
areaReferenceDistance = getOption(options, 'areaReferenceDistance', 2);

%------------------------------------------------ 
%------------------------------------------------ 
%Wygenerowanie deskryptor�w w analizowanych danych:

% estymacja powierzchni analizowanych danych:
area = estimateArea( pts(roiMask,:), areaNoOfTestPts, areaReferenceDistance);
                    
% wygenerowanie deskryptor�w dla analizowanego obszaru:
seedPtsNo = round(seedPtsPerPatternNo * area./patternAreas);
[spinImgs selIxs] = getDescriptorSub(pts, roiMask, '', ...
    sum(seedPtsNo), spinDistance, alfaBins, betaBins, alfaAxes, betaAxes);     

%hold on;
%scatter3(pts(:,1), pts(:,2), pts(:,3), 1, pts(:,3), 'filled' );
%scatter3(pts(roiMask,1), pts(roiMask,2), pts(roiMask,3), 10, 'g', 'filled' );
%scatter3(pts(selIxs,1), pts(selIxs,2), pts(selIxs,3), 30, 'r','filled' );

% korekta gdy czasem nie ma wystarczajaco duzo punktow:
%noOfGeneratedDescs = length(selIxs);
%seedPtsNo = floor(seedPtsNo./sum(seedPtsNo) * noOfGeneratedDescs);
while length(selIxs) < sum(seedPtsNo)
    selIxs = [selIxs; selIxs];
    spinImgs = [spinImgs; spinImgs];
end; %while   


%------------------------------------------------ 
%------------------------------------------------ 
%Dopasowanie deskryptor�w z analizowanych danych do deskryptor�w wzorc�w:
%(Faza I budowania zbioru ucz�cego).

% generacja z wzorc�w punkt�w do uczenia
fgSeedPts = [];
bgSeedPts = [];
matchingCost = 0;
selPointer = 1; 
for patternNo = 1: noOfPatterns

    %wyci�cie cz�ci deskryptor�w z deskryptor�w analizowanego obrazu:
    ixs = selPointer: selPointer+seedPtsNo(patternNo)-1;
    selPointer = selPointer + seedPtsNo(patternNo);   
    spinImgsForPattern  = spinImgs(ixs,:);
    selIxsForPattern    = selIxs(ixs,:);
    
	%dopasowanie obliczonych deskryptor�w do wzorca:
    [fgSeedIxs bgSeedIxs  matchingCost1] = ...
    matchToPatternDescFile( patternDescFiles{patternNo}, ...
     seedPtsPerPatternNo, spinImgsForPattern, selIxsForPattern, options);
    
	%zaktualizowanie deskryptor�w:
	fgSeedPts = [fgSeedPts; pts(fgSeedIxs, :)];	
	bgSeedPts = [bgSeedPts; pts(bgSeedIxs, :)];
	matchingCost = matchingCost + matchingCost1;
    
end; %for		

%------------------------------------------------ 
%------------------------------------------------ 
%Przygotowanie zbioru ucz�cego (filtrowanie danych):

%zapisanie punkt�w ucz�cych (dane historyczne dla wizualizacji):
hBgSeedPts = bgSeedPts; %zapisanie do historii
hFaceSeedPts = fgSeedPts; %zapisanie do historii
%bgSeedPtsMovedToFace = [];
%facePointsMovedToBg = [];

%------------------------------------------------ 

%Reklasyfikacja punkt�w twarzy na podstawie po��czenia klastr�w:
[fgSeedPts facePointsMovedToBg] = connectionFiltering(fgSeedPts, options);
bgSeedPts = [bgSeedPts; facePointsMovedToBg];

%-------

%Reklasyfikacja punkt�w t�a metod� k-nn:
[bgSeedPtsMovedToFace bgSeedPts] = ...
    weightedKnnClassify(bgSeedPts, fgSeedPts, bgSeedPts, options);
fgSeedPts = [fgSeedPts; bgSeedPtsMovedToFace];

%------------------------------------------------ 
%------------------------------------------------ 
%Klasyfikacja:
for iteration = 1:6
    switch classifier
        case 'nn'
            [subPts bgPts subMask] = nnClassify( pts(roiMask,:), ...
                fgSeedPts, bgSeedPts, cOptions);    
        case 'knn'
            [subPts bgPts subMask] = knnClassify( pts(roiMask,:), ...
                fgSeedPts, bgSeedPts, cOptions);
        case 'wknn'
             [subPts bgPts subMask] = weightedKnnClassify( pts(roiMask,:), ...
                 fgSeedPts, bgSeedPts, cOptions);
             
        otherwise
            error('Bad classifier name! Allowed values: nn/knn/wknn');
    end; %switch 
    
    %Warunek zako�czenia: albo co� znaleziono, albo nie trzeba znale��
    if size(subPts, 1) > 0 || forceFinding == 0
        break;
    end;
    
    %Warunek ratunkowego u�ycia klasyfikatora:
    if iteration == 3
       classifier = altClassifier;
    end;
end; %for

bgPts = [bgPts; pts(~roiMask,:)];
[selIxs subMask] = doubleMask(roiMask, subMask, size(pts,1) );

%------------------------------------------------ 
%------------------------------------------------ 
%Filtrowanie ko�cowe wyniku:

%Zachowuje wszystkie odpowiednio du�e segmenty punkt�w:
[subPts  subPointsMovedToBg keptPts] = connectionFiltering(subPts, cOptions);
[selIxs subMask] = doubleMask(subMask, keptPts);
bgPts = [bgPts; subPointsMovedToBg];

