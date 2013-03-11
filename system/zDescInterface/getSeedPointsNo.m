function [selIxs noOfSeedPoints] = getSeedPointsNo(pts, noOfSeedPoints, method)
% Selects index of points on which descriptors will be based.
%
% Wybiera z punkt�w podzbi�r punkt�w (ich indeksy).
% Parametry: 
%  pts - punkty
%  noOfSeedPoints - liczba punkt�w kt�re maj� zosta� wybrane
%  method - nazwa algorytmu wyboru punkt�w: rand/kmeans/oct
% Zwraca:
%  selIxs - wektor indeks�w wybranych punkt�w
%  noOfSeedPoints - ile punkt�w uda�o si� wybra�



global seedMethod;

if exist('method', 'var')
    algorithm = method;
elseif length(seedMethod) > 0
    algorithm = seedMethod;
else
    algorithm = 'oct';
end;    

%------------------------

%fprintf('getSeedPointsNo: algorithm = %s\n', algorithm);
noOfSeedPoints = min( [noOfSeedPoints, size(pts,1)] );
switch algorithm
        case 'rand'
            selIxs = getSeedPointsNoRand(pts, noOfSeedPoints);        
        case 'kmeans'
            selIxs = getSeedPointsNoKMeans(pts, noOfSeedPoints);        
        case 'oct'        
            selIxs = getSeedPointsNoOct(pts, noOfSeedPoints); 
        otherwise
            error('Bad `method` value [use rand/kmeans/oct]!');
end; %switch
