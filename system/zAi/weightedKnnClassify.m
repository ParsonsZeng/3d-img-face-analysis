function [positiveSubData negativeSubData assignment] = ...
    weightedKnnClassify(data, positiveSeedData, negativeSeedData, options)
%Dokonuje podzia�u zbioru danych wykorzysuj�c k-nn. Klasy maj� r�ne wagi.
%Parametry:
% data - dane do podzielenia. W wierszach kolejne encje.
% positiveSeedData - wzorce do klasyfikacji pozytywnej.
% negativeSeedData - wzorce do klasyfikacji negatywnej.
%Zwracane:
% positiveSubData - dane zaklasyfikowane jako klasa pozytywna.
% negativeSubData - dane zaklasyfikowane jako klasa negatywna.
% assignment - wektor 0/1 m�wi�cy o przypisaniu do klas.
    
%--------------------------------------------------------------------------
%Opcje:
options.null = 0;
k = getOption(options, 'k', 5);
positiveWeight = getOption(options, 'positiveWeight', 2);
negativeWeight = getOption(options, 'negativeWeight', 1);

%--------------------------------------------------------------------------
%Przygotowanie danych ucz�cych i bufor�w:
dataSize = size(data,1);
posSize = size(positiveSeedData,1);
negSize = size(negativeSeedData,1);

assignment = zeros( dataSize, 1);
featurePts = [positiveSeedData; negativeSeedData];
markers = [ones(posSize, 1); zeros(negSize, 1)];

%--------------------------------------------------------------------------
%Klasyfikacja:
w = guiStartWaitBar(0, ['w' num2str(k) '-nn [+' ...
    num2str(posSize) '*' num2str(positiveWeight) '/-' ...
    num2str(negSize) '*' num2str(negativeWeight) ' ' ...
    '] classification of ' num2str(dataSize) ' points ...']);
for i = 1: dataSize
    guiSetWaitBar(i/dataSize);
    assignment(i) = weightedKnnClassifier( data(i,:), ...
        featurePts, markers, negativeWeight, positiveWeight, k);
end;
guiStopWaitBar(w);

%--------------------------------------------------------------------------
%Rozdzielenie danych po klasyfikacji:
assignment = logical(assignment);


positiveSubData = data(assignment, :);
negativeSubData = data(~assignment, :);

