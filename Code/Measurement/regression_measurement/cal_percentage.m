% regression and calculate the percentage

clear all; close all;  clc;

gender = 'male';
data_dir = '/home/yan/Data2/NOMO_Project/data/raw_measurement/raw_vs_gt/';

load([data_dir gender '/' gender '_Neck_Circ.mat']);
data = male_Neck_Circ;

% load('male_ankle_measurement_new.mat');
% data = ankle_measurement;

%%
clc;

epsilon = 4; % Allowable Error mm

obj_list = {data(:).name;};
num_obj = length(obj_list);
% num_obj = length(data);

% randomly split: 4 subsets for training, 1 subset for testing
rand_idx = randperm(num_obj);
folder_num = round(num_obj / 5);
list_index = ...
  [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, num_obj];

col_num = length(data(1).raw_measurement); % how many circles or lines
% col_num = length(data(1).Circ);

errVec = [];
MAE = 0;   std_v = 0;
percentage = 0;

for idx = 1:5               
 test_idx = rand_idx(list_index(idx)+1 : list_index(idx+1));
 train_idx = setdiff(rand_idx, test_idx, 'stable');
 
 test_gt = [data(test_idx).gt]';
 row_num = length(test_idx);
 test_data = zeros(row_num, col_num);
 for ii = 1:row_num
     for jj = 1:col_num
         test_data(ii, jj) = data(test_idx(ii)).raw_measurement{jj};
%          test_data(ii, jj) = data(test_idx(ii)).Circ(jj);
     end
 end
 
 train_gt = [data(train_idx).gt]';
 row_num = length(train_idx);
 train_data = zeros(row_num, col_num);
 for ii = 1:row_num
     for jj = 1:col_num
         train_data(ii, jj) = data(train_idx(ii)).raw_measurement{jj};
%          train_data(ii, jj) = data(train_idx(ii)).Circ(jj);
     end
 end
 
%'linear', 'interactions', 'purequadratic', 'quadratic', 'polyjlk'
%  Mdl = stepwiselm(train_data, train_gt, 'linear');

%  Mdl = fitlm(train_data, train_gt, 'linear');
 Mdl = fitrsvm(train_data, train_gt);
 y_hat = predict(Mdl, test_data);
 
 abs_diff = abs(y_hat - test_gt)*10; %mm
 errVec = [errVec; (y_hat - test_gt) * 10];
 percentage = percentage + sum(abs_diff <= epsilon) / length(abs_diff);
 
 MAE = MAE + mean(abs_diff);
 std_v = std_v + std(abs_diff);
 
end

MAE = MAE / 5
std_v = std_v / 5
percentage = percentage / 5





