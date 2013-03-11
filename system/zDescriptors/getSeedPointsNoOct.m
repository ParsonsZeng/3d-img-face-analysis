function selIxs = getSeedPointsNoOct(pts, noOfSeedPoints)
% Wybiera z punkt�w 'pts' podzbi�r punkt�w (indeksy) wykorzystuj�c 
% segmentacj� octClustering.
% Dane s� dzielone na 'noOfSeedPoints' grup. Dla ka�dej grupy wybierany
% jest jeden punkt najbli�szy �rodkowi.

%----------------------------

noOfSeedPoints = min([noOfSeedPoints size(pts,1)]);

%----------------------------
%Metod� segmentacji octClustering

clusters =  octClustering(pts, noOfSeedPoints);

centroids = zeros(noOfSeedPoints, 3);
for i = 1:noOfSeedPoints
    centroids(i,:) = mean( pts(clusters==i, :) );
end;    

%----------------------------
%Rozwi�zanie kt�re zjada za du�o pami�ci:
%distMatrix = buildDistanceMatrix(centroids, pts);
%[pt selIxs] = min(distMatrix');
%Permutacja powoduje �e wynik nie jest deterministyczny.
%selIxs = selIxs( randperm( length(selIxs) ) )'; 

%-------

%Rozwi�zanie wolniejsze ale oszcz�dniejsze pami�ciowo:
selIxs = zeros(noOfSeedPoints, 1);
for i = 1: noOfSeedPoints
    distMatrix      = buildDistanceMatrix( centroids(i,:), pts);
    [pt selIxs(i)]	= min(distMatrix');
end;    
%Permutacja powoduje �e wynik nie jest deterministyczny.
selIxs = selIxs( randperm( length(selIxs) ) ); 

%----------------------------
