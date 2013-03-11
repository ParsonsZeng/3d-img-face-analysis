function [spinImgs descPtsN] = createDescriptorForFeaturePts ...
 (pts, descPts,  ...
  distance, alfaBins, betaBins, alfaAxes, betaAxes)
%Tworzy deskryptor o zadanych parametrach dla wybranego zestawu punkt�w.
%Parametry:
% pts - dane dla kt�rych zbudowa� deskryptor
% descPts - punkty dla kt�rych wygenerowany zostanie deskryptor
%
% distance - promie� s�siedztwa stosowany przy liczeniu obraz�w obrotu
% alfaBins/betaBins - rozdzielczo�� deskryptor�w
% alfaAxes/betaAxes - typy skali dla histogram�w: 'lin'/'log'
%Zwracane:
% spinImgs - deskryptor w postaci macierzy. W wierszach zserializowane 
%  obrazy obrot�w dla kolejnych punkt�w.
% descPtsN - kierunki normalnych


%--------------------------------------------------------------------------

%Estymacja kierunk�w normalnych: 
descPtsN = adaptiveNormalsForFeaturePts(pts, descPts);

%Zbudowanie deskryptora:
spinImgs = buildDescriptor(pts,  descPts, descPtsN, ...
     distance, alfaBins, betaBins, alfaAxes, betaAxes);
 
%--------------------------------------------------------------------------