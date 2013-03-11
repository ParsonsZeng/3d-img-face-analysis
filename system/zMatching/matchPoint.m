function [no cost spinNo spinCost] = matchPoint(patternSpinImgs, spinImgs, options)
%Znajduje punkt najbardziej podobny do punkt�w zadanych jako wzorce.
%Parametry:
% patternSpinImgs - deskryptory punkt�w wzorcowych. 
% spinImgs - deskryptory punkt�w z kt�rych wybierany b�dzie najlepiej
% pasuj�cy punkt.
%Zwracane:
% no - numer deskryptora dla kt�rego znaleziono najlepsze dopasowanie.
% cost - koszt dopasowania dla najlepszego punktu
% spinNo - pionowy wektor indeks�w deskryptor�w pocz�wszy od tych z
%  najmniejszym kosztem
% spinCost - pionowy wektor posortowanych koszt�w dla wszystkich 
%   testowanych deskryptor�w 


%--------------------------------------------------------------------------
%Parametry:

% force creation of options:
options.null = 0; 

% dopasowywanie:
matchingRule = getOption(options, 'matchingRule', 'OR');
matchingDistanceType = getOption(options, 'matchingDistanceType', 1);

%--------------------------------------------------------------------------

%Koszt ca�kowity jako suma koszt�w wzgl�dem poszczeg�lnych wzorc�w:
costMatrix = buildMatchingCost(spinImgs, patternSpinImgs, ...
    matchingRule, matchingDistanceType);
costs = sum(costMatrix, 2); 

%Posortowanie:
ix = ( 1:size(spinImgs,1) )';
costs = sortrows([ix costs], 2);

%Wybranie wynik�w:
spinNo = costs(:,1);
spinCost = costs(:,2);

no = spinNo(1);
cost = spinCost(1);



