function [spinImgs selIxs n] = createDescriptor ...
 (pts, noOfSpinImgs, distance,  ...
  alfaBins, betaBins, alfaAxes, betaAxes)
%----------------------Wrapper--------------------------------------------
%Tworzy deskryptor o zadanych parametrach dla wybranego zestawu punkt�w.
%Parametry:
% pts - dane dla kt�rych zbudowa� deskryptor
% noOfSpinImgs - jaki powiniene by� rozmiar deskryptora (tj. ile punkt�w
%   dla kt�rych liczone b�d� obrazy obrotu powinno zosta� wylosowanych)
% distance - promie� s�siedztwa stosowany przy liczeniu obraz�w obrotu
% alfaBins/betaBins - rozdzielczo�� deskryptor�w
% alfaAxes/betaAxes - typy skali dla histogram�w: 'lin'/'log'
%Zwracane:
% spinImgs - deskryptor w postaci macierzy. W wierszach zserializowane 
%  obrazy obrot�w dla kolejnych punkt�w.
% selIxs - wektor indeks�w punkt�w dla kt�rych zbudowano obrazy obrot�w.
% n - kierunki normalnych

%--------------------------------------------------------------------------

%Wybranie punkt�w do deskryptora:
selIxs = getSeedPointsNo(pts, noOfSpinImgs);

%Utw�rz deskryptor:
[spinImgs nSel] = createDescriptorForFeaturePts(pts, pts(selIxs,:),  ...
  distance, alfaBins, betaBins, alfaAxes, betaAxes);

%Transform (n,u,v) in a way that value is given for every point:
ptsSize = size(pts, 1);
n = zeros(ptsSize, 3);
n(selIxs,:) = nSel;

%--------------------------------------------------------------------------
%{
%Estymacja kierunk�w normalnych: 
n = adaptiveNUV(pts, selIxs);

%Zbudowanie deskryptora:
spinImgs = buildModelDescriptor ...
    (pts, n, selIxs, distance, alfaBins, betaBins, alfaAxes, betaAxes);
%}