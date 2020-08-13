function [] = powerdensity_for_epoch
% This is a subfunction of Sleep Scorer and must be included in the
% "Sleepscorer" folder. It calculates the estimated power values for the
% current 10 second epoch.
%--------------------------------------------------------------------------
% Modified by Brooks A. Gross on Nov-2-2012
% --Turned off Spectrum obsolete warning.  It will need to be updated
% before Mathworks removes it.

% Modified by Brooks A. Gross on Jan-15-2010
% --Created as an independent m-file.
%--------------------------------------------------------------------------
global EPOCHSIZE EMG_SAMPLES EEG_SAMPLES Fs EPOCH_StartPoint D_lo D_hi T_lo...
    T_hi S_lo S_hi B_lo B_hi P_emg st_power dt_ratio

%W = hann(64);  % WINDOW Definition. The EPOCHSIZEOF10sec is chosen to be 64 
df=EPOCHSIZE;
% This is taking integral in time domain 
Vj=double(EMG_SAMPLES(EPOCH_StartPoint:EPOCH_StartPoint+EPOCHSIZE-1));
absVj=abs(Vj).^2;                       % absolute square
P_emg=sum(absVj)/length(absVj);  % sum of all squared Vj's

% This is calculating power in frequency domain
fft_in=double(EEG_SAMPLES(EPOCH_StartPoint:EPOCH_StartPoint+EPOCHSIZE-1));

% Turn off warning for spectrum
warning off 'signal:spectrum:obsoleteFunction'

[Pxx2,F2]=spectrum(double(fft_in),df,0,ones(size(fft_in)),Fs);
%index_delta=[];index_theta=[];index_sigma=[]; index_beta=[];
%For the EEG signal
index_delta=find(F2(1)+D_lo<F2 & F2 < F2(1)+D_hi);      % Default delta band 0.4 -4 Hz
index_theta=find(F2(1)+T_lo < F2 & F2 < F2(1)+T_hi);    % Default theta band 5-9 Hz
index_sigma=find(F2(1)+S_lo< F2 & F2 < F2(1)+S_hi);     % Default sigma band 10-14 Hz
index_beta =find(F2(1)+B_lo< F2 & F2 < F2(1)+B_hi);     % Default Beta band 15-20 Hz
delta_power=sum(Pxx2(index_delta))/df *2; %#ok<*FNDSB>
theta_power=sum(Pxx2(index_theta))/df *2;
sigma_power=sum(Pxx2(index_sigma))/df *2;
beta_power = sum(Pxx2(index_beta))/df *2;
st_power=abs(sigma_power*theta_power);   % Used to indicate waking
dt_ratio=abs(delta_power/theta_power);   
clear index_delta index_theta index_sigma index_beta
handles=guihandles(sleepscorer);
set(handles.emg_edit,'String',P_emg);
set(handles.delta_edit,'String',delta_power);
set(handles.theta_edit,'String',theta_power);
set(handles.sigma_edit,'String',sigma_power);
set(handles.beta_edit,'String',beta_power);
set(handles.sigmatheta,'String',st_power);
set(handles.deltatheta,'String',dt_ratio);

%sec_fft;