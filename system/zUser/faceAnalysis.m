function [face_Mask center_FaceMask nose_FaceMask noseNear_FaceMask ... 
          leftNose_FaceMask rightNose_FaceMask ...
          prn_FaceMask n_FaceMask sn_FaceMask lal_FaceMask ral_FaceMask ...
          prn n sn lal ral ...
          costs t success noseFoundFlag] = faceAnalysis(pts)
% Procedura dokonuje analizy twarzy. Przeprowadzanaych jest kolejnych 7 faz
% lokalizacji: lokalizacja twarzy, nosa, punkt�w: prn, n, sn, lal, ral.
% Dodatkowo po fazie lokalizacji twarzy przeprowadzana jest heurystyka
% ograniczaj�ca zakres przeszukiwania do obszaru centralnego. Po fazie nosa
% uruchamiana jest procedura 'pogrubiaj�ca' nosa s�u��ca zwi�kszeniu
% obszaru przeszukiwa� i wype�nieniu nieci�g�o�ci w danych. Po
% zlokalizowaniu punkt�w (prn, n, sn) obszar nosa dzielony jest na praw� i
% lew� cz��. ��cznie wykonywanych jest 10 faz.
% Parametry:
%  pts - chmura punkt�w zawieraj�ca twarz
% Warto�ci zwracane:
%  face_Mask - maska wybieraj�ca punkty nale��ce do twarzy z 'pts'
%  maski wybieraj�ce z twarzy (tj. z punkt�w pts(face_Mask,:) ):
%   center_FaceMask - region centralny twarzy
%   nose_FaceMask - region nosa
%   noseNear_FaceMask - poszerzony i skorygowany region nosa 
%   leftNose_FaceMask - lew� cz�� nosa
%   rightNose_FaceMask - praw� cz�� nosa
%   prn_FaceMask - otoczenie punktu: prn
%   n_FaceMask - otoczenie punktu: nasion
%   sn_FaceMask - otoczenie punktu: subnaasale
%   lal_FaceMask - otoczenie punktu: lewe alare
%   ral_FaceMask - otoczenie punktu: prawe alare
%  prn n sn lal ral - warto�ci �rednie region�w nosa
%  costs - sumaryczne koszty dopasowa� do wzorc�w uzyskiwane w kolejnych
%   fazach: znajdowania twarzy, nosa i kolejnych pi�ciu region�w nosa.
%  Domy�lnie r�wne inf.
%  t - czasy kolejnych 10 stopni oblicze�. W przypadku gdy kt�ra� z faz 
%   si� nie powiod�a (b��d) odpowiednia warto�� w wektorze t r�wna jest inf.
%  success - maska binarna o zawieraj�ca informacj� o wyniku dzia�ania 
%   kolejnej fazy lokalizacji (7 faz). Je�li faza zako�czy�a si� sukcesem -
%   - region zlokalizowano, to maska zawiera warto�� 1. Je�li pora�k� to 0. 
%  noseFoundFlag - flaga m�wi�ca o tym czy region nosa jest wiarygodny.
%-----------------------------------
%
% Format stosowanych masek: A_XMask gdzie:
%  A - co konkretnie wybiera maska (np. nos).
%  X - z czego maska wybiera (np. twarz)
% np. lewyNosa_TwarzMask - maska wybieraj�ca lew� cz�� nosa z twarzy
%-----------------------------------

%czasy wykonania:
t = ones(10, 1) * inf;
%koszty przypisania
costs = ones(7, 1) * inf;
%wyniki
success = ones(7,1);

try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
    costs(1) face_Mask] = findFace(pts);
    facePts = subPts;
    if size(subPts, 1) <= 0
         warning('[Face localization failure] Face not found. \n');
         success(1) = 0;
    end;    
    t(1) = toc;
catch e
    warning(['[Face localization error] ' e.message '\n']);

    success(1) = 0;
    face_Mask = logical( ones( size(pts,1), 1) );
    facePts = pts;      
end;       

%-----------

try
    tic;
    [faceCenterPts center_FaceMask] = centerAreaFilter(facePts, 70);
    t(2) = toc;
catch e
    warning(['[Face center localization error] ' e.message '\n']);   
    
    center_FaceMask = face_Mask;
    faceCenterPts = facePts;    
end;

%-----------------------------------

try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ... 
    costs(2) nose_FaceMask] = findNose(facePts, center_FaceMask);
    nosePts = subPts;
    if size(subPts, 1) <= 0
         warning('[Nose localization failure] Not found. \n')
         success(2) = 0;
    end;    
    t(3) = toc;
catch e
    warning(['[Nose localization error] ' e.message '\n']);  
    
    success(2) = 0;    
    nose_FaceMask = center_FaceMask;
    nosePts = faceCenterPts;
end;    

%------

if  costs(2) < 15
    noseFoundFlag = true;
else
    noseFoundFlag = false;
end;    

%-----------

try
    tic;
    [noseNearPts bgPts noseNear_FaceMask] = distanceClassify(facePts, nosePts, 6);
    t(4) = toc;
catch e
    warning(['[Nose correction error] ' e.message '\n']);  
    
    noseNear_FaceMask = nose_FaceMask;
    noseNearPts = nosePts;
end;  
%-----------------------------------

try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
    costs(3) prn_FaceMask] = findPoint(facePts, noseNear_FaceMask, 1);
    prnPts = subPts;
    if size(subPts, 1) <= 0
         warning('[Prn localization failure] Not found. \n')
         success(3) = 0;
    end;       
    t(5) = toc;
catch e
    warning(['[Prn localization error] ' e.message '\n']);
    
    success(3) = 0;
    prn_FaceMask = noseNear_FaceMask;
    prnPts = noseNearPts;    
end;    
prn = mean(prnPts);
    
try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
    costs(4) n_FaceMask] = findPoint(facePts, noseNear_FaceMask, 2);
    nPts = subPts;
    if size(subPts, 1) <= 0
         warning('[Nasion localization failure] Not found. \n')
         success(4) = 0;
    end;       
    t(6) = toc;    
catch e
     warning(['[Nasion localization error] ' e.message '\n']);
     
     success(4) = 0;
    n_FaceMask = noseNear_FaceMask;
    nPts = noseNearPts;  
end;    
n = mean(nPts);

try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
    costs(5) sn_FaceMask] = findPoint(facePts, noseNear_FaceMask, 5);
    snPts = subPts;
    if size(subPts, 1) <= 0
         warning('[Subnaasale localization failure] Not found. \n')
         success(5) = 0;
    end;       
    t(7) = toc;
    
    sn = mean(snPts);
catch e
    warning(['[Subnaasale localization error] ' e.message '\n']);
    
    success(5) = 0;
	sn_FaceMask = noseNear_FaceMask;
    snPts = noseNearPts;  
    sn = mean(snPts);
end;    

% jakakolwiek lokalizacja sn jest wa�na w procesie dzielenia przy lal i ral
if isnan(sn)
    warning('[Fixing sn coordinates] \n');
    sn = mean(snPts);
end;    

%--------------------------------------------------------------------------

try
    tic;

    %Poszerzenie obszaru nosa:
    [noseDNearPts bgPts noseDNear_FaceMask] = distanceClassify(facePts, nosePts, 7);

    %Podzielenie nosa na lew� i praw� cz��:
    left_DNoseMask      = splitByPlane(noseDNearPts,  n, sn, prn);
    %leftNoseNearPts     = noseDNearPts(left_DNoseMask, :);
    %rightNoseNearPts	= noseDNearPts(~left_DNoseMask, :);

    %Aktualizacja masek:
    leftNose_FaceMask = doubleMask(noseDNear_FaceMask, left_DNoseMask);
    rightNose_FaceMask = doubleMask(noseDNear_FaceMask, ~left_DNoseMask); 

    t(8) = toc;
catch e
     warning(['[Nose splitting error] ' e.message '\n']);
     
     leftNose_FaceMask = noseNear_FaceMask;
     rightNose_FaceMask = noseNear_FaceMask;
end;    

%-------------------------------------------------------------------------

try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
    costs(6) lal_FaceMask] = findPoint(facePts, leftNose_FaceMask, 3);
    lalPts = subPts;
    if size(subPts, 1) <= 0
         warning('[Left alare localization failure] Not found. \n')
         success(6) = 0;
    end;       
    t(9) = toc;
catch e
     warning(['[Left alare localization error] ' e.message '\n']);
     
     success(6) = 0;
    lal_FaceMask = noseNear_FaceMask;
    lalPts = noseNearPts;  
end;   
lal = mean(lalPts);

try
    tic;
    [subPts bgPts,  fgSeedPts, bgSeedPts, ...
    hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
    costs(7) ral_FaceMask] = findPoint(facePts, rightNose_FaceMask, 4);
    ralPts = subPts;
    if size(subPts, 1) <= 0
         warning('[Right alare localization failure] Not found. \n')
         success(7) = 0;
    end;       
    t(10) = toc;

catch e
    warning(['[Right alare localization error] ' e.message '\n']);
    
    success(7) = 0;
    ral_FaceMask = noseNear_FaceMask;
    ralPts = noseNearPts;  
end;    
ral = mean(ralPts);

success = logical(success);
