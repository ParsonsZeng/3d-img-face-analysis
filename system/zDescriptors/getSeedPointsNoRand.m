function selIxs = getSeedPointsNoRand(pts, noOfSeedPoints)
% Wybiera z punkt�w 'pts' losowy podzbi�r 'noOfSeedPoints' punkt�w (indeksy).

%----------------------------

noOfSeedPoints = min([noOfSeedPoints size(pts,1)]);

%----------------------------
%Losowy wyb�r punkt�w:

selIxs = randperm( size(pts,1) );
selIxs = selIxs( 1:noOfSeedPoints )';