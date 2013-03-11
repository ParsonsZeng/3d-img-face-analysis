function [spinImgs selIxs] = getDescriptorSub(pts, mask, filePath, ...
    noOfSeedPoints, distance, ...
    alfaBins, betaBins, alfaAxes, betaAxes)
%Wczytuje deskryptor z pliku. 
%Je�li plik nie istnieje to jest on tworzony zgodnie z parametrami.
%Deskryptor budowany jest tylko na punktach dla kt�rych maska binarna jest
%ustawiona (==1), ale w oparciu o wszystkie punkty.

if exist(filePath, 'file')
    %Za�adowanie z pliku:
    [spinImgs selIxs] = ioRestoreModelDescriptor(filePath);
    
    %Walidacja:
    noOfSeedPoints = min([noOfSeedPoints length(selIxs)]);
    if size(spinImgs, 2) ~= alfaBins* betaBins
        error(['Bad length of descriptors! Is ' num2str(size(spinImgs,2)) ...
            ' and should be ' num2str(alfaBins) 'x' num2str(betaBins)]);
    end;
    
    %Wyci�cie tylu deskryptor�w ilu potrzeba:
    spinImgs = spinImgs(1:noOfSeedPoints, :);
    selIxs = selIxs(1:noOfSeedPoints, :);
    
else     
    
    %Wybranie punkt�w do deskryptora z przefiltrowanych danych:
    maskSelIxs = getSeedPointsNo( pts(mask,:), noOfSeedPoints);
    selIxs = doubleMask(mask, maskSelIxs, size(pts,1) );
    descPts = pts(selIxs,:);
    %fprintf('Seed points selected.\n');    
    
    %Wizualizacja regionu z kt�rego wybierane s� punkty:
    %guiDraw3d(pts, 1); hold on; guiDraw3d(pts(selIxs,:), 3);
    %guiDraw3d(pts(selIxs,:), 30, 'r', '*');    
            
    %Estymacja kierunk�w normalnych: 
    descPtsN = adaptiveNormalsForFeaturePts(pts, descPts);
    %fprintf('Normals found.\n');
    
    %Zbudowanie deskryptora:
    spinImgs = buildDescriptor (pts, descPts, descPtsN, ...
     distance, alfaBins, betaBins, alfaAxes, betaAxes);
    %fprintf('Descriptor built.\n');

 
    %Zapisanie deskryptora do pliku
    %ioStoreModelDescriptor(filePath, spinImgs, selIxs);
end;
