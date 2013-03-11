function [classificationCost] = evaluateSingleClassifier(net, seedData, labels, options)
%Ocenia jako� pojedynczego klasyfikatora (sieci neuronowej) dla zadanych danych.
%Zwraca:
% classificationCost - koszt klasyfikacji danych ucz�cych

%--------------------------------------------------------------------------

%Pr�g klasyfikacji:
threshold = getOption(options, 'threshold', 0.5); 

%--------------------------------------------------------------------------

%obliczenie jako�ci (wg specyficznego schematu!):
positiveElements = labels==1;
dataClassification = ( sim(net, seedData') >= threshold )';

positiveReject = sum( positiveElements & ~dataClassification);
negativeReject = sum( ~positiveElements & dataClassification);
classificationCost = 0.5 * positiveReject  +  0.5 * negativeReject;