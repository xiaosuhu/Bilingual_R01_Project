function [intensity,p] = getIntensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
% intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo')&ismember(Contrasttable.source,[1 2 3 4 5 6 7 8]));
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo'));
p=Contrasttable.p(strcmp(Contrasttable.type,'hbo'));
end

