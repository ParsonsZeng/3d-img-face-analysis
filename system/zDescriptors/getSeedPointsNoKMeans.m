function selIxs = getSeedPointsNoKMeans(pts, noOfSeedPoints)
% Wybiera z punkt�w 'pts' podzbi�r punkt�w (indeksy) wykorzystuj�c 
% segmentacj� k-means.
% Dane s� dzielone na 'noOfSeedPoints' grup. Dla ka�dej grupy wybierany
% jest jeden punkt najbli�szy �rodkowi.

%----------------------------

noOfSeedPoints = min([noOfSeedPoints size(pts,1)]);

%----------------------------
%Metod� k-�rednich:
[clusters centroids] = kmeans(pts, noOfSeedPoints);
distMatrix = buildDistanceMatrix(centroids, pts);
[pt selIxs] = min(distMatrix');
selIxs = selIxs';
