function [SubjStats,GroupStats] = StepXa_NIRStoolpipe(data)
% A nirstoolbox pipeline for data process and export both subject level and
% group level results

disp('Now running subject-level GLM!')
firstlevelglm=nirs.modules.AR_IRLS();
firstlevelbasis = nirs.design.basis.Canonical();
disp('Initial GLM complete')

firstlevelbasis.peakTime = 6;
firstlevelglm.basis('default') = firstlevelbasis;
disp('Peak time set at 6s')

tic
SubjStats=firstlevelglm.run(data);
disp('Ready to save SubjStats...')
toc

%% Group Level Analysis
% Run GLM with SEPARATE conditions and NO REGRESSORS. Only TASK (conditions) vs. REST
% Interaction between task and condition (compare two tasks in one model)
tic
disp('Running GroupStats GLM')
grouplevelpipeline=nirs.modules.MixedEffects();
grouplevelpipeline.formula ='beta ~ -1 + Task:cond + (1|Subject)';
GroupStats = grouplevelpipeline.run(SubjStats);
disp('GroupStats done!')
toc

end

