function guiDraw3d(pts, ptSize, color, symbol)
% Rysuje tr�jwymiarow� chmur� punkt�w. 

if ~exist('ptSize', 'var')
    ptSize = 3;
end;    

if ~exist('color', 'var')
    color = pts(:,3);
end;    

if ~exist('symbol', 'var')
    symbol = 'filled';
end;    

scatter3(pts(:,1), pts(:,2), pts(:,3), ptSize, color, symbol);

