function [fgSeedIxs bgSeedIxs  matchingCost matchingCostMatrix] = ...
matchToPatternDescFile( patternDescFile, patternSeedPtsNo, ...
                        spinImgs, selIxs, options)
%Dopasowuje deskryptory analizowanego obrazu do deskryptor�w wzorca.
%
%Parametry:
% patternDescFile - plik zawieraj�cy deskryptory wzorca.
% patternSeedPtsNo - liczba deskryptor�w wzorca kt�ra powinna zosta� u�yta 
%  przy dopasowywaniu.
% spinImgs - deskryptory analizowanego obrazu kt�re b�d� dopasowywane do
%  wzorca.
% selIxs - zbi�r numer�w punkt�w analizowanego obrazu dla kt�rych
%  wygenerowano deskryptory 'spinImgs'.
% options - opcje
%
%Zwracane:
% fgSeedIxs - indeksy punkt�w z 'selIxs' kt�re dopasowano do wzorca
% bgSeedIxs - indeksy punkt�w z 'selIxs' kt�rych nie dopasowano do wzorca
% matchingCost - sumaryczny koszt dopasowania
% matchingCostMatrix - macierz koszt�w dopasowania

%--------------------------------------------------------------------------
%Parametry:

% force creation of options:
options.null = 0; 

% dopasowywanie:
matchingRule = getOption(options, 'matchingRule', 'OR');
matchingDistanceType = getOption(options, 'matchingDistanceType', 1);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Za�adowanie deskryptor�w wzorca:

% �adowanie punkt�w wzorcowych:
patternSpinImgs = ioRestoreModelDescriptor(patternDescFile);

% wyci�cie deskryptor�w w wymaganej liczbie:
patternSeedPtsNo = min([patternSeedPtsNo size(patternSpinImgs,1)]); %granica
patternSpinImgs = patternSpinImgs(1:patternSeedPtsNo, :);  

%------------------------------------------------    
%------------------------------------------------    
%Dopasowanie deskryptor�w:

%macierz koszt�w dopasowania:
matchingCostMatrix = buildMatchingCost(patternSpinImgs, spinImgs, ...
                                       matchingRule, matchingDistanceType);
%dopasowanie:
[assignment matchingCost] = matchDescriptors(matchingCostMatrix);  

%----------------

%podzial na punkty zaklasyfikowane do podwzorca (~twarzy):
assigned = assignment(assignment~=0);
fgSeedIxs = selIxs( assigned );

%znalezienie punktow odrzuconych:
notAssigned = ones( length(selIxs), 1);
notAssigned(assigned) = 0;
bgSeedIxs   = selIxs( notAssigned == 1 );
