function [sm] = subMask(outerMask, innerMask)
%Obie maski s� tego samego rozmiaru. Wyj�ciowa maska ma rozmiar liczby
%element�w wybieranych przez zewn�trzn� mask� i jedynki w miejscach w
%kt�rych wyznacza wewn�trzna maska.

sm = innerMask(outerMask);