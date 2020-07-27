c1MA=[0 0 0 0 1 0 0 1 0 0 1 0 0];
ageMA=[1 0 0 0 0 0 0 0 0 0 0 0 0];
elmmMA=[0 1 0 0 0 0 0 0 0 0 0 0 0];
lwidMA=[0 0 1 0 0 0 0 0 0 0 0 0 0];
p1eduMA=[0 0 0 1 0 0 0 0 0 0 0 0 0];

[intensity1,p1]=getintensity(c1MA,GroupStatsMA);
[intensity2,p2]=getintensity(ageMA,GroupStatsMA);
[intensity3,p3]=getintensity(elmmMA,GroupStatsMA);
[intensity4,p4]=getintensity(lwidMA,GroupStatsMA);
[intensity5,p5]=getintensity(p1eduMA,GroupStatsMA);

c1PA=[0 0 0 0 1 0 0 1 0 0 1 0 0];
agePA=[1 0 0 0 0 0 0 0 0 0 0 0 0];
ctoppPA=[0 1 0 0 0 0 0 0 0 0 0 0 0];
lwidPA=[0 0 1 0 0 0 0 0 0 0 0 0 0];
p1eduPA=[0 0 0 1 0 0 0 0 0 0 0 0 0];

[intensity6,p6]=getintensity(c1PA,GroupStatsPA);
[intensity7,p7]=getintensity(agePA,GroupStatsPA);
[intensity8,p8]=getintensity(ctoppPA,GroupStatsPA);
[intensity9,p9]=getintensity(lwidPA,GroupStatsPA);
[intensity10,p10]=getintensity(p1eduPA,GroupStatsPA);
%% Plot the 3D image

% MA
onlypositive=0;
figure

plot(intensity1,onlypositive,p1);
title('MA Easy+Hard+Control')

figure

subplot(2,2,1);
plot(intensity2,onlypositive,p2)
title('MAAGE')
subplot(2,2,2);
plot(intensity3,onlypositive,p3)
title('MAELMM')
subplot(2,2,3);
plot(intensity4,onlypositive,p4)
title('MALWID')
subplot(2,2,4);
plot(intensity5,onlypositive,p5)
title('MAP1_EDU')


% PA
figure

plot(intensity6,onlypositive,p6);
title('PA Easy+Hard+Control')

figure

subplot(2,2,1);
plot(intensity7,onlypositive,p7)
title('PAAGE')
subplot(2,2,2);
plot(intensity8,onlypositive,p8)
title('PACTOPP')
subplot(2,2,3);
plot(intensity9,onlypositive,p9)
title('PALWID')
subplot(2,2,4);
plot(intensity10,onlypositive,p10)
title('PAP1EDU')


%% Functions
function [intensity,p] = getintensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
% intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo')&ismember(Contrasttable.source,[1 2 3 4 5 6 7 8]));
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo'));
p=Contrasttable.p(strcmp(Contrasttable.type,'hbo'));
end

function plot(intensity,onlypositive,p)
load MNIcoordBi.mat % Load Coordinates
mx=4;
mn=-4;

% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
else
    negind=[];
end

insigind=find(p>=0.05);


if ~isempty(negind)
    rind=unique([negind insigind]);
else
    rind=insigind;
end

intensity(rind)=[];
MNIcoordBi(rind,:)=[];

MNIcoordstd=10*ones(length(MNIcoordBi));

Plot3D_channel_registration_result(intensity, MNIcoordBi, MNIcoordstd,mx,mn);

camlight('headlight','infinite');
lighting gouraud
material dull;
end