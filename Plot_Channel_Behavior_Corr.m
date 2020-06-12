function Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats)
% Plot correlation map between beta values and behavior scores
% by Xiaosu Hu, version 11-26-2019

% Check for Nan
nonusable=[];
for i=1:length(SubjStats)
    if isnan(SubjStats(i).demographics.values{3})|isnan(SubjStats(i).demographics.values{4})|...
            isnan(SubjStats(i).demographics.values{5})|isnan(SubjStats(i).demographics.values{6})
        nonusable=[nonusable;i];
    end
end
SubjStats(nonusable)=[];

for i=1:length(SubjStats)
    Stable=SubjStats(i).table;
    beta(i,1)=Stable.beta(Stable.source==SourceIndex...
        &Stable.detector==DetectorIndex...
        &strcmp(Stable.type,hbohbr)...
        &strcmp(Stable.cond,condition));
    AGE(i,1)=SubjStats(i).demographics.values{3};
    PPVTr(i,1)=SubjStats(i).demographics.values{4};
    CTOPr(i,1)=SubjStats(i).demographics.values{5};
    LWIDr(i,1)=SubjStats(i).demographics.values{6};
end

f1=fit(beta,AGE,'poly1');
f2=fit(beta, PPVTr,'poly1');
f3=fit(beta,CTOPr,'poly1');
f4=fit(beta, LWIDr,'poly1');

figure
subplot(2,2,1)
plot(f1,beta,AGE);
xlabel('beta')
ylabel('AGE')
title(['Source',num2str(SourceIndex),'-Detector',num2str(DetectorIndex)]);
subplot(2,2,2)
plot(f2,beta,PPVTr);
xlabel('beta')
ylabel('PPVTr')
title(['Source',num2str(SourceIndex),'-Detector',num2str(DetectorIndex)]);
subplot(2,2,3)
plot(f3,beta,CTOPr);
xlabel('beta')
ylabel('CTOPr')
title(['Source',num2str(SourceIndex),'-Detector',num2str(DetectorIndex)]);
subplot(2,2,4)
plot(f4,beta,LWIDr);
xlabel('beta')
ylabel('LWIDr')
title(['Source',num2str(SourceIndex),'-Detector',num2str(DetectorIndex)]);

end

