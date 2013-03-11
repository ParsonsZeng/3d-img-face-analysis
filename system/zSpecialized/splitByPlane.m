function leftMask = splitByPlane(pts,  n, sn, prn)
%Dzieli punkty 'pts' na le��ce po lewej cz�ci p�aszczyzny wyznaczonej
%przez 3 punkty (n, sn, prn) i na takie kt�re le�� z jej prawej strony.

% wektory wyznaczajace plaszczyzne:
lv = n - prn; 
hv = sn - prn;

% wektor prostopadly do plaszczyzny (skierowany w lewo):
indv = cross(lv, hv);

% wektory od czubka nosa do punkt�w na nosie:
dataLen =  size(pts,1);
pv = pts - repmat(prn, dataLen, 1);

% maska dziel�ca nos na lew� i praw� cze��
leftMask = sum( pv .* repmat(indv, dataLen, 1), 2) > 0;