function [evec mu eval] = getPcaVec(features)

    mu = mean(features);	%obliczenie sredniej
	features = features - repmat( mu, size(features,1), 1);	%odjecie sredniej
	cmx = cov(features);	%kowariancja
	[evec eval] = eig(cmx); % wektory i warto�ci w�asne
	eval = sum(eval);		%zamiana macierzy na wektor
	[eval evid] = sort(eval);	%sortowanie po warto�ciach wlasnych
	eval = eval(size(eval,2):-1:1);	%odwrocenie kolejnosci wartosci wlasnych
	evec = evec(:, evid(size(eval,2):-1:1) ); %posortowanie w odwroconej kolejnosci wektorow wlasnych