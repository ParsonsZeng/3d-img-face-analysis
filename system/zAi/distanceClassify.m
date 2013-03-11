function [ack rej assignment] = distanceClassify(data, positiveSeedData, radius)
%Klasyfikuje dane w ten spos�b, �e do klasy pozytywnej przyporz�dkowane s�
%dane w odleg�o�ci nie wi�kszej ni� 'radius' od danych pozytywnej.
%
%Zwracane:
% ack - zaakceptowane
% rej - odrzucone

dataSize = size(data,1);
minDist = zeros(dataSize, 1);

wbar = guiStartWaitBar(0, ['Classifying ' num2str(dataSize) ' points...']);
for ptNo = 1:dataSize    
   guiSetWaitBar(ptNo/dataSize);
    
   dist =  buildDistanceMatrix( data(ptNo,:), positiveSeedData);
   minDist(ptNo) = min(dist);
end;    
guiStopWaitBar(wbar);

assignment = minDist<=radius;
ack = data(assignment,:);
rej = data(~assignment,:);