% train SVR regression Mdl
% 2018.05.03 Song Yan

clear; close all; clc;

DATA_DIR = '/home/yan/Data2/NOMO_Project_P1/data/raw_measurement/raw_vs_gt/female/';
SAVE_DIR = '/home/yan/Data2/NOMO_Project_P1/data/regression_model/female/';

load([DATA_DIR 'female_SideNeck_to_Bust.mat']); %% 
data = female_SideNeck_to_Bust;                 %%

train_data = [];
train_gt = [];
% train data
for ii = 1:length(data)
    train_data = [train_data; data(ii).raw_measurement{:}];
    train_gt   = [train_gt; data(ii).gt;];
end

Mdl = fitrsvm(train_data, train_gt);
save([SAVE_DIR 'SideNeck_to_Bust_Mdl.mat'], 'Mdl');  %%