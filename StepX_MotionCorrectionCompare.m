% This piece of code investigates the different motion correction
% techniques for R01 project Data processing.
% 1) We are trying to compare the motion correction techniques
% 2) We will import the motion corrected data for Mapper analysis

datadir=uigetdir();

disp('Loading in .nirs data files...')
raw = nirs.io.loadDirectory(datadir, {'Subject','Task'});
disp('All .nirs files loaded!')
disp('-----------------------')

% set the duration to be 6 sec
for i=1:length(raw)
    for j=1:length(raw(i).stimulus.values{1}.dur)
        raw(i).stimulus.values{1}.dur(j)=6;
    end
    for j=1:length(raw(i).stimulus.values{2}.dur)
        raw(i).stimulus.values{2}.dur(j)=6;
    end
    for j=1:length(raw(i).stimulus.values{3}.dur)
        raw(i).stimulus.values{3}.dur(j)=6;
    end
end

% First Level Analysis
disp('Running data resample...')
resample=nirs.modules.Resample();
resample.Fs=2;
downraw=resample.run(raw);

disp('Converting Optical Density...')
odconv=nirs.modules.OpticalDensity();
od=odconv.run(downraw);

disp('Trimming .nirs files...')
trim=nirs.modules.TrimBaseline();
trim.preBaseline=10;
trim.postBaseline=10;
od_trim=trim.run(od);

% Homer Motion artifact Spline
% Create a job to detect motion artifacts
jM = nirs.modules.Run_HOMER2();
jM.fcn = 'hmrMotionArtifactByChannel';
jM.vars.tMotion = .5;
jM.vars.tMask = 2;
jM.vars.std_thresh = 14;
jM.vars.amp_thresh = .2;
jM.keepoutputs = true;  % Needed to pipe output to the next call into Homer2

% Add on a job to remove artifacts using previously-detected time points
jsp = nirs.modules.Run_HOMER2(jM);
jsp.fcn = 'hmrMotionCorrectSpline';
jsp.vars.tInc = '<linked>:output-tIncCh'; % Use the 'tIncCh' output from the previous function
% job.vars.tInc = '<linked>:output-2'; % ...Or specify the index of the output you want to use
jsp.vars.p = .99;
jsp.vars.turnon=1;
jsp.keepoutputs = true;

% Run both jobs
for i=1:length(od_trim)
    odsp(i) = jsp.run(od_trim(i));
end

% Converting to hb signal
disp('Applying  Modified Beer Lambert Law...')
mbll=nirs.modules.BeerLambertLaw();

hbsp=mbll.run(odsp);

% Signal Demean
for i=1:length(hbsp)
    for j=1:size(hbsp(i).data,2)
        hbsp(i).data(:,j)=hbsp(i).data(:,j)-mean(hbsp(i).data(:,j));
    end
end

hb_trim=mbll.run(od_trim);

% Signal Demean
for i=1:length(hb_trim)
    for j=1:size(hb_trim(i).data,2)
        hb_trim(i).data(:,j)=hb_trim(i).data(:,j)-mean(hb_trim(i).data(:,j));
    end
end

% Motion Correction

%Motion artifact PCA
pc=nirs.modules.PCAFilter();
pc.ncomp=.7;
hbpc=pc.run(hb_trim);

%Motion artifact Wavelet
wv=nirs.modules.WaveletFilter();
wv.sthresh=3;
hbwv=wv.run(hb_trim);

% % Check the average correlation after each motion correction
% for i=1:length(hb_trim)
%     for j=1:size(hb_trim(i).data,2)
%         [rsp(i,j),psp(i,j)]=corr(hb_trim(i).data(:,j),hbsp(i).data(:,j));
%         [rpc(i,j),ppc(i,j)]=corr(hb_trim(i).data(:,j),hbpc(i).data(:,j));
%         [rwv(i,j),pwv(i,j)]=corr(hb_trim(i).data(:,j),hbwv(i).data(:,j));
%     end
% end


% % Bandpass filter 0.009 - 0.2 Hz
% bf=eeg.modules.BandPassFilter();
% bf.do_downsample=0;
% bf.lowpass=0.2;
% bf.highpass=0.009;
% hbf=bf.run(hb_trim);
% hbsp=bf.run(hbsp);
% hbpc=bf.run(hbpc);
% hbwv=bf.run(hbwv);


%% We will try the regular NIRStoolbox pipeline and try to get the group level stats
[SubjStats_sp,GroupStats_sp] = StepXa_NIRStoolpipe(hbsp);
[SubjStats_trim,GroupStats_trim] = StepXa_NIRStoolpipe(hb_trim);
[SubjStats_wv,GroupStats_wv] = StepXa_NIRStoolpipe(hbwv);
[SubjStats_pc,GroupStats_pc] = StepXa_NIRStoolpipe(hbpc);

%% Plot the group level results for each
