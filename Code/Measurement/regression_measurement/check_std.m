% check standard deviation

clear all; close all; clc;

gender = 'female';
data_dir = '/home/yan/Data2/NOMO_Project/data/raw_measurement/raw_vs_gt/';
%--------------------------------------------------------------------------
load([data_dir gender '/' gender '_Bust_to_Bust.mat']);
data = female_Bust_to_Bust;

col_num = length(data(1).raw_measurement);  
obj_list = {data(:).name;};
num_obj = length(obj_list);

% load('male_ankle_measurement_new.mat');
% data = ankle_measurement;
% col_num = length(data(1).Circ); 
% num_obj = length(data);
%--------------------------------------------------------------------------
% epsilon = 6; % mm   Allowable Error
%--------------------------------------------------------------------------
MAE_svr = 0;   std_svr = 0;   % percent_svr = 0;
MAE_lin = 0;   std_lin = 0;   % percent_lin = 0;

errVec_svr = [];
errVec_lin = [];
%--------------------------------------------------------------------------
% randomly split the data
rand_idx = randperm(num_obj);
folder_num = round(num_obj / 5);
list_index = ...
  [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, num_obj];
%--------------------------------------------------------------------------
% 5-folder cross validation process
for idx = 1:5               
     test_idx = rand_idx(list_index(idx)+1 : list_index(idx+1));
     train_idx = setdiff(rand_idx, test_idx, 'stable');

     test_gt = [data(test_idx).gt]';
     row_num = length(test_idx);
     test_data = zeros(row_num, col_num);
     for ii = 1:row_num
         for jj = 1:col_num
             test_data(ii, jj) = data(test_idx(ii)).raw_measurement{jj};
%              test_data(ii, jj) = data(test_idx(ii)).Circ(jj);
         end
     end

     train_gt = [data(train_idx).gt]';
     row_num = length(train_idx);
     train_data = zeros(row_num, col_num);
     for ii = 1:row_num
         for jj = 1:col_num
             train_data(ii, jj) = data(train_idx(ii)).raw_measurement{jj};
%              train_data(ii, jj) = data(train_idx(ii)).Circ(jj);
         end
     end
    
     Mdl_svr = fitrsvm(train_data, train_gt);
     yhat_svr = predict(Mdl_svr, test_data);
     diff_svr = yhat_svr - test_gt;
     errVec_svr = [errVec_svr; diff_svr];
     MAE_svr = MAE_svr + mean(abs(diff_svr));
     std_svr = std_svr + std(diff_svr);
%      percent_svr = percent_svr + sum(abs(diff_svr)*10 <= epsilon) / length(diff_svr);
     
     Mdl_lin = fitlm(train_data, train_gt, 'linear');
     yhat_lin = predict(Mdl_lin, test_data);
     diff_lin = yhat_lin - test_gt;
     errVec_lin = [errVec_lin; diff_lin];
     MAE_lin = MAE_lin + mean(abs(diff_lin));
     std_lin = std_lin + std(diff_lin);
%      percent_lin = percent_lin + sum(abs(diff_lin)*10 <= epsilon) / length(diff_lin);
     
end

MAE_svr = MAE_svr / 5;  std_svr = std_svr / 5; % percent_svr = percent_svr / 5;
MAE_lin = MAE_lin / 5;  std_lin = std_lin / 5; % percent_lin = percent_lin / 5;

%--------------------------------------------------------------------------
% disp('non-linear SVR');
% disp(['MAE = ' num2str(MAE_svr*10) '  std = ' num2str(std_svr*10)]);
% disp('linear regression');
% disp(['MAE = ' num2str(MAE_lin*10) '  std = ' num2str(std_lin*10)]);
% 
% histogram(errVec_svr*10, 20)
% xlabel('error [mm]');
% ylabel('num');
% title('male HIP Circ non-linear SVR Error');

errVec_svr_order = sort(errVec_svr*10);  % mm
AbsErr_svr = sort(abs(errVec_svr*10));

errVec_lin_order = sort(errVec_lin*10);  % mm
AbsErr_lin = sort(abs(errVec_lin*10));

disp(['svr mid-err = ' num2str(errVec_svr_order(end/2)) ' mm abs-mid-err = ' num2str(AbsErr_svr(end/2)) ' mm']);
disp(['lin mid-err = ' num2str(errVec_lin_order(end/2)) ' mm abs-min-err = ' num2str(AbsErr_lin(end/2)) ' mm']);





