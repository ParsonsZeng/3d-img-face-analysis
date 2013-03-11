function [positiveSubData negativeSubData positiveClassification] ...
    = nnClassify(data, positiveSeedData, negativeSeedData, options)
%Dokonuje podzia�u na dwa zbioru danych wykorzysuj�c sie� neuronow�.
%Parametry:
% data - dane do podzielenia. W wierszach kolejne encje.
% positiveSeedData - wzorce do klasyfikacji pozytywnej.
% negativeSeedData - wzorce do klasyfikacji negatywnej.
% options - opcje.
%Zwracane:
% positiveSubData - dane zaklasyfikowane jako klasa pozytywna.
% negativeSubData - dane zaklasyfikowane jako klasa negatywna.
% positiveClassification - mapa binarna danych (jedynki dla klasy
%  pozytywnej).

%--------------------------------------------------------------------------
%Ustawienia:

%Pr�g klasyfikacji:
threshold = getOption(options, 'threshold', 0.5); 
%Z ilu sieci wybiera�:
noOfNetworks = getOption(options, 'noOfNetworks', 3);

%--------------------------------------------------------------------------
%Analiza danych:

%przygotowanie zbiorow dla uczenia klasyfikatora:
seedData = [negativeSeedData; positiveSeedData];
labels  = [zeros( size(negativeSeedData,1), 1); ones( size(positiveSeedData,1), 1)];

%przedzialy danych wejsciowych
mins = min(seedData);
maxs = max(seedData);

%--------------------------------------------------------------------------
%Budowa klasyfikatora i klasyfikacja:
wbar = guiStartWaitBar(0, ['Building ' num2str(noOfNetworks) ' network(s)...']);

%------------Wyb�r najlepszego z puli:------------------------------

%Stworzenie sieci:
net = nnSingleClassifier( ...
    seedData, labels, mins, maxs, options);
classificationCost = evaluateSingleClassifier(...
    net, seedData, labels, options);

%Wyb�r sieci o najlepszej charakterystyce uczenia:
for tryNo = 1: noOfNetworks-1
    
    currentNet = nnSingleClassifier( ...
        seedData, labels, mins, maxs, options);
    currClassificationCost = evaluateSingleClassifier(...
        currentNet, seedData, labels, options);

    if currClassificationCost<classificationCost
       net = currentNet;
       classificationCost = currClassificationCost;
    end;
    
end; %for    

%klasyfikacja encji:
dataClassification = sim(net, data')';
positiveClassification = dataClassification >= threshold; 


%------------G�osowanie:-----------------------------------------
%{
%Budowanie sieci i zliczanie ich g�os�w:
positiveClassification = zeros( size(data,1), 3);
for netNo = 1:3
    net = nnSingleClassifier( ...
        seedData, labels, mins, maxs, options);
    dataClassification = sim(net, data')' ;
    positiveClassification(:,netNo) = dataClassification >= threshold;
end;    

positiveClassification = mode(positiveClassification, 2) == 1;
%}

guiStopWaitBar(wbar);
%--------------------------------------------------------------------------
%Wyci�cie danych:

positiveSubData = data(positiveClassification, :);
negativeSubData = data(~positiveClassification, :);
