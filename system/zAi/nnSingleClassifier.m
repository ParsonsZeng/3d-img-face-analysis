function net = nnSingleClassifier(seedData, labels, mins, maxs, options)
%Tworzy klasyfikator w postaci sieci neuronowej. 
%Parametry:
% seedData - dane ucz�ce
% labels - klasy
% mins/maxs - przedzia�y danych ucz�cych
%Zwracane: 
% net - obiekt sieci neuronowej

%--------------------------------------------------------------------------

%Liczba ukrytych neuron�w:
hiddenNeurons = getOption(options, 'hiddenNeurons', 5);
%Epoki uczenia wsteczn� propagacj� b��d�w:
bpEpochs = getOption(options, 'bpEpochs', 250);
%Epoki uczenia metod� L-M:
lmEpochs = getOption(options, 'lmEpochs', 100); 

%--------------------------------------------------------------------------

%budowa sieci:
net = newff([mins' maxs'], [hiddenNeurons 1], {'logsig' 'logsig'} );
net = init(net);
net = teachNetwork(net, seedData', labels', bpEpochs, lmEpochs, 0.0001);

%--------------------------------------------------------------------------

