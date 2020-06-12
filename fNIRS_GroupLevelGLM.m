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

%% Group Level GLM Needed for the correlation plot
grouplevelpipeline = nirs.modules.MixedEffects();
grouplevelpipeline.formula ='beta ~ -1 + Session:cond + (1|Subject)';

load N56_GLMwDCT.mat
SubjStats1=SubjStats;
load N56_GLMwDCTwDerivative.mat
SubjStats2=SubjStats;
load N56_NIRS_SPM.mat
SubjStats3=SubjStats;
load N56_PCA60Percent.mat
SubjStats4=SubjStats;
load N56_PCA60Percent_ChannelRemoved.mat
SubjStats5=SubjStats;
load N56_PCA30Percent_ChannelRemoved.mat
SubjStats6=SubjStats;
load N56_PCA30Percent_woDCT_ChannelRemoved.mat
SubjStats7=SubjStats;
load N56_PCA80Percent_woDCT_ChannelRemoved.mat
SubjStats8=SubjStats;

GroupStats1 = grouplevelpipeline.run(SubjStats1);
GroupStats2 = grouplevelpipeline.run(SubjStats2);
GroupStats3 = grouplevelpipeline.run(SubjStats3);
GroupStats4 = grouplevelpipeline.run(SubjStats4);
GroupStats5 = grouplevelpipeline.run(SubjStats5);
GroupStats6 = grouplevelpipeline.run(SubjStats6);
GroupStats7 = grouplevelpipeline.run(SubjStats7);
GroupStats8 = grouplevelpipeline.run(SubjStats8);


