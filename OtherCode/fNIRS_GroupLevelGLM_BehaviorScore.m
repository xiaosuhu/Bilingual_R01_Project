%% fNIRS Data Analyses - Bilingual Litercy Project
%% Morphosyntax Grammaticality Judgement Task
% Script 3 of 4
%
% Neelima Wagley
%
% Modified: 08/07/18
%
% Updated by Xiaosu Hu Feb 11 2019
%% GLM Second (group) Level Analyses

% Data Analyses Pipile as listed below using Huppert et al NIRS Toolbox and
% inidividualized scripts created by Frank Hu.
%% Behavior Score integration

% Demographics Behavioral Correlation
Demo = nirs.modules.AddDemographics();
Demo.demoTable = readtable('/Users/xiaosuhu/Documents/MATLAB/Bilingual R01/BEHAVESCORE_ENMAPA.xlsx');
Demo.varToMatch='Subject';

load N56_GLMwDCT.mat
SubjStats1=SubjStats;
SubjStats1 = Demo.run(SubjStats1);

load N56_GLMwDCTwDerivative.mat
SubjStats2=SubjStats;
SubjStats2 = Demo.run(SubjStats2);

load N56_NIRS_SPM.mat
SubjStats3=SubjStats;
SubjStats3 = Demo.run(SubjStats3);

load N56_PCA60Percent.mat
SubjStats4=SubjStats;
SubjStats4 = Demo.run(SubjStats4);

load N56_PCA60Percent_ChannelRemoved.mat
SubjStats5=SubjStats;
SubjStats5 = Demo.run(SubjStats5);

load N56_PCA30Percent_ChannelRemoved.mat
SubjStats6=SubjStats;
SubjStats6 = Demo.run(SubjStats6);

load N56_PCA30Percent_woDCT_ChannelRemoved.mat
SubjStats7=SubjStats;
SubjStats7 = Demo.run(SubjStats7);

load N56_PCA80Percent_woDCT_ChannelRemoved.mat
SubjStats8=SubjStats;
SubjStats8 = Demo.run(SubjStats8);


%% Plot the correlation between channels of interest and behaviror score
% The channel of interest are S7-D1,S1-D1,S1-D3, S2-D3, S2-D5, S3-D5
SourceIndex=1;
DetectorIndex=3;
hbohbr='hbo';
condition='stim_channel1';
condition_der='stim_channel1:01';
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats1)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition_der, SubjStats2)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats3)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats4)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats5)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats6)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats7)
Plot_Channel_Behavior_Corr(SourceIndex, DetectorIndex, hbohbr, condition, SubjStats8)


%% Run the LME model with 
grouplevelpipeline = nirs.modules.MixedEffects();
grouplevelpipeline.formula ='beta ~ -1 + Session:cond + Age + PPVT_r + CTOPP_r + LWID_r + (1|Subject)';

GroupStats1 = grouplevelpipeline.run(SubjStats1);
GroupStats2 = grouplevelpipeline.run(SubjStats2);
GroupStats3 = grouplevelpipeline.run(SubjStats3);
GroupStats4 = grouplevelpipeline.run(SubjStats4);
GroupStats5 = grouplevelpipeline.run(SubjStats5);
GroupStats6 = grouplevelpipeline.run(SubjStats6);
GroupStats7 = grouplevelpipeline.run(SubjStats7);
GroupStats8 = grouplevelpipeline.run(SubjStats8);