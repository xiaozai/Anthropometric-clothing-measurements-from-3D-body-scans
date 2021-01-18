% compare the raw measurement with the gt

% 1) single path ( the best path)
% 2) multi path  ( the regressor)
% 3) mean path   ( the mean value)


% a) the mean error
% b) the error variances
% c) the error distribution

clear ; close all; clc;
%--------------------------------------------------------------------------
measDataFile = 'data/raw_measurement/raw_vs_gt/male/male_Ankle_Circ.mat';
load(measDataFile);
measData = male_Ankle_Circ;
%--------------------------------------------------------------------------
N_sample = length(measData);
N_circ = length(measData(1).raw_measurement);

gt_meas = zeros(N_sample, 1);
raw_meas = zeros(N_sample, N_circ);

for idx = 1:N_sample
    gt_meas(idx) = measData(idx).gt;
    for jj = 1:N_circ
        raw_meas(idx, jj) = measData(idx).raw_measurement{jj};
    end
end

mean_meas = mean(raw_meas, 2);

%--------------------------------------------------------------------------
raw_meas_err = abs(raw_meas - gt_meas);
mean_raw_err = mean(raw_meas_err, 1);
std_raw = std(raw_meas_err, 1);

mean_meas_err = abs(mean_meas - gt_meas);
mean_mean_err = mean(mean_meas_err, 1);
std_mean = std(mean_meas_err, 1);

