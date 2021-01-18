% test ridgeRegress

clear; close all; clc;

% gender = 'female';
% data_dir = '/home/yan/Data2/NOMO_Project/data/raw_measurement/raw_vs_gt/';
% 
% % get obj file list
% load([data_dir gender '/' gender '_Bust_to_Bust.mat']);
% data = female_Bust_to_Bust;

load('female_ankle_measurement_new.mat');
data = ankle_measurement;

epsilon = 4; 

% col_num = length(data(1).raw_measurement);  % feature num
col_num = length(data(1).Circ);  % feature num

% obj_list = {data(:).name;};
% num_obj = length(obj_list);
num_obj = length(data);

nfold = 4;

final_mae = 0;
final_std = 0;
final_percent = 0;

for iter = 1:100
    
    rand_idx = randperm(num_obj);
    folder_num = round(num_obj / 5);
    list_index = ...
      [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, num_obj];

    MAE = 0;
    std_v = 0;
    percentage = 0;
    
    for idx = 1:5
        test_idx = rand_idx(list_index(idx)+1 : list_index(idx+1));
        train_idx = setdiff(rand_idx, test_idx, 'stable');
        test_gt = [data(test_idx).gt]';
        row_num = length(test_idx);
        test_data = zeros(row_num, col_num);
        for ii = 1:row_num
            for jj = 1:col_num
                test_data(ii, jj) = data(test_idx(ii)).Circ(jj);
%                 test_data(ii, jj) = data(test_idx(ii)).raw_measurement{jj};
            end
        end

        train_gt = [data(train_idx).gt]';
        row_num = length(train_idx);
        train_data = zeros(row_num, col_num);
        for ii = 1:row_num
            for jj = 1:col_num
                train_data(ii, jj) = data(train_idx(ii)).Circ(jj);
%                 train_data(ii, jj) = data(train_idx(ii)).raw_measurement{jj};
            end
        end

        weights_fnl = ridgeRegress(train_data, train_gt, nfold );
        w=weights_fnl(1:end-1,:);
        b=weights_fnl(end,:);

        ypred=test_data*w;
        ypred = ypred + b;
        
        abs_diff = abs(ypred - test_gt) * 10;  % mm
        MAE = MAE + mean(abs_diff);  % mm
        std_v = std_v + std(abs_diff);
        percentage = percentage + sum(abs_diff <= epsilon) / length(abs_diff);
        
    end

    final_mae = final_mae + MAE / 5;
    final_std = final_std + std_v / 5;
    final_percent = final_percent + percentage / 5;
end

final_mae = final_mae / 100
final_std = final_std / 100
final_percent = final_percent / 100