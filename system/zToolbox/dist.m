function d = dist(pt1, pt2)
%Oblicza odleg�o�� euklidesow� mi�dzy dwoma punktami.

d = sqrt( sum( (pt1 - pt2).^2 ) );
