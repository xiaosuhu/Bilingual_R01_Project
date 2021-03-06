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

%% Contrast and Plot the group level results for each
easyMA=[1 0 0 0 0 0];
hardMA=[0 0 1 0 0 0];
controlMA=[0 0 0 0 1 0];

easyPA=[0 1 0 0 0 0];
hardPA=[0 0 0 1 0 0];
controlPA=[0 0 0 0 0 1];

onlypositive=1;

% Two digits for intensity and p
% digit 1, 1 = MA, 2= PA
% digit 2, 1= Easy, 2= Hard, 3=Control

% No motion correction
[intensity11t,p11t]=getIntensity(easyMA,GroupStats_trim);
[intensity12t,p12t]=getIntensity(hardMA,GroupStats_trim);
[intensity13t,p13t]=getIntensity(controlMA,GroupStats_trim);

[intensity21t,p21t]=getIntensity(easyPA,GroupStats_trim);
[intensity22t,p22t]=getIntensity(hardPA,GroupStats_trim);
[intensity23t,p23t]=getIntensity(controlPA,GroupStats_trim);

figure
subplot(2,3,1)
plot3Dbrain(intensity11t,onlypositive,p11t);
title('MA Easy')
subplot(2,3,2)
plot3Dbrain(intensity12t,onlypositive,p12t);
title('MA Hard')
subplot(2,3,3)
plot3Dbrain(intensity13t,onlypositive,p13t);
title('MA Control')

subplot(2,3,4)
plot3Dbrain(intensity21t,onlypositive,p21t);
title('PA Easy')
subplot(2,3,5)
plot3Dbrain(intensity22t,onlypositive,p22t);
title('PA Hard')
subplot(2,3,6)
plot3Dbrain(intensity23t,onlypositive,p23t);
title('PA Control')
%------------------------------
% Spline
[intensity11sp,p11sp]=getIntensity(easyMA,GroupStats_sp);
[intensity12sp,p12sp]=getIntensity(hardMA,GroupStats_sp);
[intensity13sp,p13sp]=getIntensity(controlMA,GroupStats_sp);

[intensity21sp,p21sp]=getIntensity(easyPA,GroupStats_sp);
[intensity22sp,p22sp]=getIntensity(hardPA,GroupStats_sp);
[intensity23sp,p23sp]=getIntensity(controlPA,GroupStats_sp);


figure
subplot(2,3,1)
plot3Dbrain(intensity11sp,onlypositive,p11sp);
title('MA Easy')
subplot(2,3,2)
plot3Dbrain(intensity12sp,onlypositive,p12sp);
title('MA Hard')
subplot(2,3,3)
plot3Dbrain(intensity13sp,onlypositive,p13sp);
title('MA Control')

subplot(2,3,4)
plot3Dbrain(intensity21sp,onlypositive,p21sp);
title('PA Easy')
subplot(2,3,5)
plot3Dbrain(intensity22sp,onlypositive,p22sp);
title('PA Hard')
subplot(2,3,6)
plot3Dbrain(intensity23sp,onlypositive,p23sp);
title('PA Control')

%------------------------------
% Wavelet
[intensity11wv,p11wv]=getIntensity(easyMA,GroupStats_wv);
[intensity12wv,p12wv]=getIntensity(hardMA,GroupStats_wv);
[intensity13wv,p13wv]=getIntensity(controlMA,GroupStats_wv);

[intensity21wv,p21wv]=getIntensity(easyPA,GroupStats_wv);
[intensity22wv,p22wv]=getIntensity(hardPA,GroupStats_wv);
[intensity23wv,p23wv]=getIntensity(controlPA,GroupStats_wv);


figure
subplot(2,3,1)
plot3Dbrain(intensity11wv,onlypositive,p11wv);
title('MA Easy')
subplot(2,3,2)
plot3Dbrain(intensity12wv,onlypositive,p12wv);
title('MA Hard')
subplot(2,3,3)
plot3Dbrain(intensity13wv,onlypositive,p13wv);
title('MA Control')

subplot(2,3,4)
plot3Dbrain(intensity21wv,onlypositive,p21wv);
title('PA Easy')
subplot(2,3,5)
plot3Dbrain(intensity22wv,onlypositive,p22wv);
title('PA Hard')
subplot(2,3,6)
plot3Dbrain(intensity23wv,onlypositive,p23wv);
title('PA Control')
%------------------------------
% PCA
[intensity11pc,p11pc]=getIntensity(easyMA,GroupStats_pc);
[intensity12pc,p12pc]=getIntensity(hardMA,GroupStats_pc);
[intensity13pc,p13pc]=getIntensity(controlMA,GroupStats_pc);

[intensity21pc,p21pc]=getIntensity(easyPA,GroupStats_pc);
[intensity22pc,p22pc]=getIntensity(hardPA,GroupStats_pc);
[intensity23pc,p23pc]=getIntensity(controlPA,GroupStats_pc);


figure
subplot(2,3,1)
plot3Dbrain(intensity11pc,onlypositive,p11pc);
title('MA Easy')
subplot(2,3,2)
plot3Dbrain(intensity12pc,onlypositive,p12pc);
title('MA Hard')
subplot(2,3,3)
plot3Dbrain(intensity13pc,onlypositive,p13pc);
title('MA Control')

subplot(2,3,4)
plot3Dbrain(intensity21pc,onlypositive,p21pc);
title('PA Easy')
subplot(2,3,5)
plot3Dbrain(intensity22pc,onlypositive,p22pc);
title('PA Hard')
subplot(2,3,6)
plot3Dbrain(intensity23pc,onlypositive,p23pc);
title('PA Control')