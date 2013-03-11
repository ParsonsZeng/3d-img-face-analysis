function [models, descriptors] = ioReadModels(modelFiles, descFiles)
%[models, descriptors] = ioReadModels(modelFiles, descFiles)
%Wczytuje z plik�w zestaw modeli wraz z deskryptorami.
%Parametry:
% modelFiles - kom�rki zawieraj�ce �cie�ki modeli do wczytania.
% descFiles - kom�rki zawieraj�ce �cie�ki odpowiadaj�cych modelom deskryptor�w.
%Zwracane:
% models - kom�rki zawieraj�ce modele.
% descriptors - kom�rki zawieraj�ce deskryptory modeli.

noOfModels 	= length(modelFiles);
models 		= cell(noOfModels, 1);
descriptors	= cell(noOfModels, 1);

for i = 1: noOfModels	
	models{i} 		= ioLoad3dData( modelFiles{i} );
	descriptors{i} 	= ioRestoreModelDescriptor( descFiles{i} );
end;
