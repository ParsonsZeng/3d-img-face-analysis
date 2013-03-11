function [estimatedArea ptsDensity] = estimateArea ...
    (pts, noOfTestPts, referenceDistance)
%Estymuje powierzchni� modelu.
%Parametry:
% pts - punkty modelu w wierszach (x,y,z)
% noOfTestPts - dla ilu punkt�w dokonuje si� estymaty g�sto�ci powierzchniowej.
% referenceDistance - promie� s�siedztwa dla jakiego 
% 	dokonuje si� estymaty g�sto�ci powierzchniowej modelu. 

	
ptsDensity = estimatePtsDensity(pts, noOfTestPts, referenceDistance);
estimatedArea = size(pts,1) / ptsDensity;