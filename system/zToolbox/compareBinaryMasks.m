function [truePositive trueNegative falsePositive falseNegative] = ...
    compareBinaryMasks(mask1, mask2)
%Por�wnuje zgodno�� dw�ch masek binarnych:
% mask1 - wzorzec
% mask2 - maska por�wnywana

truePositive  = sum( mask1 &  mask2);
trueNegative  = sum(~mask1 & ~mask2);

falsePositive = sum(~mask1 &  mask2);
falseNegative = sum( mask1 & ~mask2);
