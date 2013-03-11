function guiPlotCellData(args, cellVals, ixs)
%Rysuje kilka wykres�w na jednej formatce. 
%Kolejne warto�ci dla wektora argument�w 'args' w kom�rkach 'cellVals'.
%Rysowane s� tylko zakresy nale��ce do zbior�w indeks�w 'ixs'.

colors = {'r', 'b', 'g', 'y', 'c', 'm', 'k'};

hold on;
for i=ixs
    plot(args, cellVals{i}, colors{ mod(i, 7)+1 });
    plot(args, cellVals{i}, [colors{ mod(i, 7)+1 } '.']);
end;    