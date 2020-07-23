%% Get the beta values
channelremove=0;

for i=1:length(SubjStats)
    c1=[1 0 0];
    intensity1=getintensity(c1,SubjStats(i));
    
    c2=[0 1 0];
    intensity2=getintensity(c2,SubjStats(i));
    
    c3=[0 0 1];
    intensity3=getintensity(c3,SubjStats(i));
    
    c4=[1 1 1];
    intensity4=getintensity(c4,SubjStats(i));
    
    % Plot the 3D image
    figure
    onlypositive=1;
    
    subplot(2,2,1);
    plot(intensity1,onlypositive,channelremove);
    title('Easy')
    subplot(2,2,2);
    plot(intensity2,onlypositive,channelremove)
    title('Hard')
    subplot(2,2,3);
    plot(intensity3,onlypositive,channelremove)
    title('Ct')
    subplot(2,2,4);
    plot(intensity4,onlypositive,channelremove)
    title('ALL')
    
    %====== You will need to modify the address
    saveas(gcf,['/Users/xiaosuhu/Documents/MATLAB/Bilingual R01/Figures/Subject',num2str(i),'.png']); 
    close
    
end


%% Functions
function intensity = getintensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo')&ismember(Contrasttable.source,[1 2 3 4 5 6 7 8]));
end

function plot(intensity,onlypositive,channelremove)
load MNIcoordTwoNewSource.mat % Load Coordinates
mx=4;
mn=-4;

% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
    intensity(negind)=[];
    MNIcoordNEW(negind,:)=[];
end

if channelremove
    MNIcoordNEW(end-7+1:end,:)=[];
end

MNIcoordstd=10*ones(length(MNIcoordNEW));

Plot3D_channel_registration_result(intensity, MNIcoordNEW, MNIcoordstd,mx,mn);

camlight('headlight','infinite');
lighting gouraud
material dull;
end