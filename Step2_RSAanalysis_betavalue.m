% Check whether the data files in the two groups are in the same order

% for i=1:length(N83MASubjStats)
%     disp('----------------');
%     disp(N83MASubjStats(i).description);
%     disp(N83PASubjStats(i).description);
%     disp('----------------');
% end

%% RSA Analysis
RSAvec=[];
for i=1:78
    RSAvec=[RSAvec;RSAanalysis(N83MASubjStats(i),N83PASubjStats(i))];
end
demovar=readtable('/Users/xiaosuhu/Documents/MATLAB/PROJECT_BilingualRO1/Demo_Variables_N83_NIRStoolbox.xlsx');

for i=2:6
    for j=1:6
        [RSADemoCorr(i-1,j), RSADemop(i-1,j)]=corr(RSAvec(:,j),demovar{:,i});     
    end
end


function RSAvec=RSAanalysis(data1,data2)
    % HbO
    MAbetacond1hbo=data1.beta(1:2:108-1);
    PAbetacond1hbo=data2.beta(1:2:108-1);

    MAbetacond2hbo=data1.beta(325:2:431-1);
    PAbetacond2hbo=data2.beta(325:2:431-1);
    
    MAbetacond3hbo=data1.beta(649:2:756-1);
    PAbetacond3hbo=data2.beta(649:2:756-1);
    
    % HbR
    MAbetacond1hbr=data1.beta(2:2:108);
    PAbetacond1hbr=data2.beta(2:2:108);

    MAbetacond2hbr=data1.beta(326:2:431);
    PAbetacond2hbr=data2.beta(326:2:431);
    
    MAbetacond3hbr=data1.beta(650:2:756);
    PAbetacond3hbr=data2.beta(650:2:756);
    
    RSAvec(1)=atanh(corr(MAbetacond1hbo,PAbetacond1hbo));
    RSAvec(2)=atanh(corr(MAbetacond2hbo,PAbetacond2hbo));
    RSAvec(3)=atanh(corr(MAbetacond3hbo,PAbetacond3hbo));
    
    RSAvec(4)=atanh(corr(MAbetacond1hbr,PAbetacond1hbr));
    RSAvec(5)=atanh(corr(MAbetacond2hbr,PAbetacond2hbr));
    RSAvec(6)=atanh(corr(MAbetacond3hbr,PAbetacond3hbr));
end
