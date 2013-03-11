function markers = markData(pts, mask, r, g, b)
%Przypisuje punktom 3D warto�ci w zale�no�ci od dwuwymiarowej maski.
%Maska powinna by� macierz� tr�jwymiarow� odpowiadaj�c� rzutowi
%punkt�w danych na p�aszczyzn� (x,y). Obszar maski wyznaczony jest przez
%warto�ci ekstremalne (min, max) punkt�w danych. 
%Trzeci wymiar powinien odpowiada� kolorowi.
%Warto�ci 1 (true) przypisane zostan� punktom dla kt�rych warto�� maski 
%wynosi (r,g,b). Pozosta�ym punktom przypisane zostan� warto�ci 0 (false).    

%--------------------------------------------------------------------------
% Rozdzielenie maski na kolory

maskr = mask(:,:,1);
maskg = mask(:,:,2);
maskb = mask(:,:,3);

%--------------------------------------------------------------------------
% Skalowanie danych do sze�cianu 1x1x1 po�o�onego w �rodku uk�adu wsp.

pts(:,1) = pts(:,1) - min( pts(:,1) );
pts(:,2) = pts(:,2) - min( pts(:,2) );
pts(:,3) = pts(:,3) - min( pts(:,3) );

xmax = max( pts(:,1) );
ymax = max( pts(:,2) );
zmax = max( pts(:,3) );

pts(:,1) = pts(:,1) / xmax;
pts(:,2) = pts(:,2) / ymax;
pts(:,3) = pts(:,3) / zmax;

%--------------------------------------------------------------------------
% Obliczenie odpowiadaj�cych punkt�w w masce:

maskXRange = size(mask,2)-1;
maxkYRange = size(mask,1)-1;

x = round(pts(:,1) * maskXRange) + 1;
y = maxkYRange - round(pts(:,2) * maxkYRange) + 1;
ind = sub2ind(size(maskr), y, x);

%--------------------------------------------------------------------------
% Obliczanie kolor�w dla punkt�w:

ptR = maskr(ind);
ptG = maskg(ind);
ptB = maskb(ind);

markers = ptR==r & ptG==g & ptB==b;
%--------------------------------------------------------------------------



