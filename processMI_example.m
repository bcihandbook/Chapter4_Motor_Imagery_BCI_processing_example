clear;close all;clc;

%% Add necessary functions/toolboxes, modify paths as needed
addpath(genpath('./biosig/'));
addpath(genpath('./utilities/'));


%% Define useful hardcoded variables

% Please, fill in here the full path to the data on your machine
DataPath = '';

ChannelLabels = {'Fz','FC3','FC1','FCz','FC2','FC4','C3','C1','Cz','C2',...
    'C4','CP3','CP1','CPz','CP2','CP4'};

SubjectID = {'a7','b3','f1','i3','i6','i9','j6','j7','j9','k1'};

SamplingRate = 512; % This is fixed for the data used in this assignment

% PSD feature extraction parameters
PSDparams.psdwinsec = 0.5; % Length of Power Spectral Density (PSD bandpower) window in seconds
PSDparams.psdwin = PSDparams.psdwinsec*SamplingRate; % Length of PSD window in EEG samples
PSDparams.psdovl = 0.5; % Overlapping (in decimal percentage) of consecutive PSD windows
PSDparams.freqs = [4:2:48]; % Frequency bands on which to compute PSD in Hertz (Hz)

% Butterworth band-pass filter parameters
BPfilter.order = 4;
BPfilter.lowcutoff = 4; 
BPfilter.highcutoff = 48;
[BPfilter.b, BPfilter.a] = butter(BPfilter.order,[BPfilter.lowcutoff,...
    BPfilter.highcutoff]/(SamplingRate/2), 'bandpass');

% Channel location files for topoplots (creates chanlocs16 variable with
% locations). Modify path as needed.
load('./utilities/chanlocs16.mat');


%% Iterate over all subjects in the database to produce motor imagery trial 
%% classification results 
for subject = 1:length(SubjectID)

    %% 1) Extract trials and labels in all runs/files of this subject
    [trials, labels] = getTrials(DataPath, SubjectID{subject}, SamplingRate);

    %% 2) Visualize raw data for some channel in some trial
    showRawTrial(trials, ChannelLabels, 9, 25);
   
    psd = [];
    lpsd = [];
    for tr=1:size(trials,1)
    
        %% 3) Apply pre-processing operations on each trial
        disp(['Pre-processing trial ' num2str(tr)]);
        
        % Remove DC
        processedtrial = removeDC(squeeze(trials(tr,:,:)));

        % Apply spatial filter
        %trial = car(trial); % CAR
        processedtrial = laplacianSP(processedtrial); % Cross Laplacian
        
        % Apply band-pass filter
        processedtrial = filter(BPfilter.b, BPfilter.a, processedtrial);

        %% 4) Feature extraction
        disp(['Extracting PSD features for trial ' num2str(tr)]);
        % Extract PSD for the whole trial
        for ch=1:size(processedtrial,2)
            psd(tr,ch,:) = extractPSD(processedtrial(:,ch),PSDparams.psdwin,...
                PSDparams.psdovl, PSDparams.freqs, SamplingRate);
        end
    end

    %% 5) Post-process and transform PSDs to make their distribution more "normal" (Gaussian) 
    lpsd = transformLogarithmic(psd);

    %% 6) Plot grand average PSD spectrum for all channels and MI classes
    % Does it look like EEG/physiological signal spectrum?
    % Can you find channels with distinct differences for different MI
    % classes?
    [gapsd_rh, gapsd_lh] = showGrandAverages(psd, labels, ChannelLabels, PSDparams.freqs);
    
    
    %% 7) Compare the spectra of Left Hand MI to Right Hand MI of specific channels  
    showSpectrumComparisonRHLH(lpsd, labels, 7, ChannelLabels); % Channel 7 is C3
    
    %% 8) Make topoplots of grand average logPSD for RH MI vs LH MI task
    showTopographicComparisonRHLH(gapsd_rh, gapsd_lh, chanlocs16);
    
    %% 9) Feature selection    
    [SelFeatInd, fvec, fvec_rh, lbl_rh, fvec_lh, lbl_lh] = ...
        FeatureSelection(lpsd, labels, ChannelLabels, chanlocs16);

    %% 10) Classify MI pairs
    Accuracy(subject) = classifyMI(SelFeatInd, fvec_rh, lbl_rh, fvec_lh, lbl_lh, SubjectID{subject});
end

%% 11) Plot bargraph with subject accuracy
plotAccuracy(Accuracy, SubjectID);