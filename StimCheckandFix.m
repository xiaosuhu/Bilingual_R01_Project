clear
datadir=uigetdir();
data=nirs.io.loadDirectory(datadir,{'Subject','Task'});

count=1;
for i=1:length(data)
    load(data(i).description,'-mat');
    if size(s,2)==1
       datawithoutstim{count}=data(i).description;
       count=count+1;
    end
end

% Fix the stim marks
stimdur=.18;
DataOrganization_auxtos(datawithoutstim, stimdur)

% Check whether the stim marks got fixed
figure
for i=1:length(datawithoutstim)
    load(datawithoutstim{i},'-mat');
    subplot(6,6,i);
    plot(s);
end

%% Check the stim mark

clear
datadir=uigetdir();
data=nirs.io.loadDirectory(datadir,{'Subject','Task'});
figure
for i=1:length(data)
    load(data(i).description,'-mat');
    subplot(20,10,i);
    plot(s);
end



