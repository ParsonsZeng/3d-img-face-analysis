function [p] = probability(value, mu, sigma)
%Oblicza wiarygodno�� probabilistyczn� zdarzenia.

p = 2*(1-cdf('Normal', abs(mu-value)+mu, mu, sigma));