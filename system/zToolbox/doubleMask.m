function  [selIxs mask] = doubleMask(outerMask, innerMask, dataLength)
%Wybiera indeksy za pomoc� dwupoziomowej maski (wektor�w bitowych lub
%list indeks�w).
%
%Pierwsza maska wybiera elementy z danych wej�ciowych. Jej rozmiar jest 
%r�wny datalenght. Druga maska wybiera elementy z danych wybranych
% przez pierwsz� (wst�pnie przefiltrowanych). Rozmiar drugiej maski
%jest r�wny liczbie indeks�w wybranych przez pierwsz� mask�.
%
%Parametry:
% dataLength - rozmiar danych kt�re s� maskowane.
%Zwracane:
% selIxs - indeksy danych wej�ciowych kt�re zosta�y wybrane
% mask - maska (wektor bitowy) danych wej�ciowych wybieraj�ca elementy. 
    
try
    %Wybranie indeks�w:
    if isnumeric(outerMask) %indeksy :
        selIxs = outerMask;
    else %maska binarna:
        dataLength = length(outerMask);
        selIxs = find(outerMask);
    end;
    selIxs = selIxs(innerMask);

    %Zbudowanie maski:
    mask = zeros(dataLength, 1);
    mask(selIxs) = 1;
    mask = logical(mask);
    
catch e
    selIxs = [];
    mask = ones(dataLength, 0 ) == 0;
end;    