% Circle Ablation Experiments

%--------------------------------------------------------------------------
% Bicep : 8 Circles male, 8 Circles female
% Calf  : 6 Circles male, 6 Circles female
% Chest : 5 Circles male, 3 Circles female
% Elbow : 9 Circles male, 6 Circles female
% Knee  : 6 Circles male, 6 Circles female
% Thigh : 8 Circles male, 9 Circles female
% Wrist : 6 Circles male, 8 Circles female

% Ankle : 6 Circls
% Neck  : 4 male 5 female

% Regression Model : non-linear SVR
%--------------------------------------------------------------------------
clear all; close all; clc;

gender = 'male';
data_dir = '/home/yan/Data2/NOMO_Project/data/raw_measurement/raw_vs_gt/';

load([data_dir gender '/' gender '_Neck_Circ.mat']);
data = male_Neck_Circ;

% load('male_ankle_measurement_new.mat');
% data = ankle_measurement;

epsilon = 6;  % mm

col_num = length(data(1).raw_measurement);
% col_num = length(data(1).Circ);
num_obj = length(data);

% num_Circ = 2, 4, 6, 8

final_mae1 = 0; final_mae2 = 0;   final_mae3 = 0;   final_mae4 = 0; % final_mae5 = 0;
final_std1 = 0; final_std2 = 0;   final_std3 = 0;   final_std4 = 0; % final_std5 = 0;
final_per1 = 0; final_per2 = 0;   final_per3 = 0;   final_per4 = 0; % final_per5 = 0;

for iter = 1:100
  rand_idx = randperm(num_obj);
  folder_num = round(num_obj / 5);
  list_index = ...
    [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, num_obj];
  
  MAE1 = 0;   MAE2 = 0;    MAE3 = 0;      MAE4 = 0;    %  MAE5 = 0;
  std_v1 = 0; std_v2 = 0;  std_v3 = 0;    std_v4 = 0;  %  std_v5 = 0;
  per1 = 0;   per2 = 0;    per3 = 0;      per4 = 0;    %  per5 = 0;
   
  for idx = 1: 5
     test_idx = rand_idx(list_index(idx)+1 : list_index(idx+1));
     train_idx = setdiff(rand_idx, test_idx, 'stable');
     
     test_gt = [data(test_idx).gt]';
     row_num = length(test_idx);
     
     test_data1 = zeros(row_num, 1);
     test_data2 = zeros(row_num, 2);
     test_data3 = zeros(row_num, 3);
     test_data4 = zeros(row_num, 4);
%      test_data5 = zeros(row_num, 5);
     
      for ii = 1:row_num
%          test_data1(ii, 1) = data(test_idx(ii)).Circ(1);
%          test_data1(ii, 2) = data(test_idx(ii)).Circ(4);
%          
%          test_data2(ii, 1) = data(test_idx(ii)).Circ(1);
%          test_data2(ii, 2) = data(test_idx(ii)).Circ(4);
%          test_data2(ii, 3) = data(test_idx(ii)).Circ(2);
%          test_data2(ii, 4) = data(test_idx(ii)).Circ(5);
%          
%          test_data3(ii, 1) = data(test_idx(ii)).Circ(1);
%          test_data3(ii, 2) = data(test_idx(ii)).Circ(4);
%          test_data3(ii, 3) = data(test_idx(ii)).Circ(2);
%          test_data3(ii, 4) = data(test_idx(ii)).Circ(5);
%          test_data3(ii, 5) = data(test_idx(ii)).Circ(3);
%          test_data3(ii, 6) = data(test_idx(ii)).Circ(6);
         

         test_data1(ii, 1) = data(test_idx(ii)).raw_measurement{1};
%          test_data1(ii, 2) = data(test_idx(ii)).raw_measurement{6};
         
         test_data2(ii, 1) = data(test_idx(ii)).raw_measurement{1};
         test_data2(ii, 2) = data(test_idx(ii)).raw_measurement{2};
%          test_data2(ii, 3) = data(test_idx(ii)).raw_measurement{2};
%          test_data2(ii, 4) = data(test_idx(ii)).raw_measurement{6};
%          
         test_data3(ii, 1) = data(test_idx(ii)).raw_measurement{1};
         test_data3(ii, 2) = data(test_idx(ii)).raw_measurement{2};
         test_data3(ii, 3) = data(test_idx(ii)).raw_measurement{3};
%          test_data3(ii, 4) = data(test_idx(ii)).raw_measurement{6};
%          test_data3(ii, 5) = data(test_idx(ii)).raw_measurement{3};
%          test_data3(ii, 6) = data(test_idx(ii)).raw_measurement{7};
         
         test_data4(ii, 1) = data(test_idx(ii)).raw_measurement{1};
         test_data4(ii, 2) = data(test_idx(ii)).raw_measurement{2};
         test_data4(ii, 3) = data(test_idx(ii)).raw_measurement{3};
         test_data4(ii, 4) = data(test_idx(ii)).raw_measurement{4};
%          test_data4(ii, 5) = data(test_idx(ii)).raw_measurement{3};
%          test_data4(ii, 6) = data(test_idx(ii)).raw_measurement{7};
%          test_data4(ii, 7) = data(test_idx(ii)).raw_measurement{4};
%          test_data4(ii, 8) = data(test_idx(ii)).raw_measurement{8};

%          test_data5(ii, 1) = data(test_idx(ii)).raw_measurement{1};
%          test_data5(ii, 2) = data(test_idx(ii)).raw_measurement{2};
%          test_data5(ii, 3) = data(test_idx(ii)).raw_measurement{3};
%          test_data5(ii, 4) = data(test_idx(ii)).raw_measurement{4};
%          test_data5(ii, 5) = data(test_idx(ii)).raw_measurement{5};
      end
     
     train_gt = [data(train_idx).gt]';
     row_num = length(train_idx);
     train_data1 = zeros(row_num, 1);
     train_data2 = zeros(row_num, 2);
     train_data3 = zeros(row_num, 3);
     train_data4 = zeros(row_num, 4);
%      train_data5 = zeros(row_num, 5);
     
     for ii = 1:row_num
%          train_data1(ii, 1) = data(train_idx(ii)).Circ(1);
%          train_data1(ii, 2) = data(train_idx(ii)).Circ(4);
%          
%          train_data2(ii, 1) = data(train_idx(ii)).Circ(1);
%          train_data2(ii, 2) = data(train_idx(ii)).Circ(4);
%          train_data2(ii, 3) = data(train_idx(ii)).Circ(2);
%          train_data2(ii, 4) = data(train_idx(ii)).Circ(5);
% %          
%          train_data3(ii, 1) = data(train_idx(ii)).Circ(1);
%          train_data3(ii, 2) = data(train_idx(ii)).Circ(4);
%          train_data3(ii, 3) = data(train_idx(ii)).Circ(2);
%          train_data3(ii, 4) = data(train_idx(ii)).Circ(5);
%          train_data3(ii, 5) = data(train_idx(ii)).Circ(3);
%          train_data3(ii, 6) = data(train_idx(ii)).Circ(6);
         
         train_data1(ii, 1) = data(train_idx(ii)).raw_measurement{1};
%          train_data1(ii, 2) = data(train_idx(ii)).raw_measurement{6};
%          
         train_data2(ii, 1) = data(train_idx(ii)).raw_measurement{1};
         train_data2(ii, 2) = data(train_idx(ii)).raw_measurement{2};
%          train_data2(ii, 3) = data(train_idx(ii)).raw_measurement{2};
%          train_data2(ii, 4) = data(train_idx(ii)).raw_measurement{6};
% %          
         train_data3(ii, 1) = data(train_idx(ii)).raw_measurement{1};
         train_data3(ii, 2) = data(train_idx(ii)).raw_measurement{2};
         train_data3(ii, 3) = data(train_idx(ii)).raw_measurement{3};
%          train_data3(ii, 4) = data(train_idx(ii)).raw_measurement{6};
%          train_data3(ii, 5) = data(train_idx(ii)).raw_measurement{3};
%          train_data3(ii, 6) = data(train_idx(ii)).raw_measurement{7};
         
         train_data4(ii, 1) = data(train_idx(ii)).raw_measurement{1};
         train_data4(ii, 2) = data(train_idx(ii)).raw_measurement{2};
         train_data4(ii, 3) = data(train_idx(ii)).raw_measurement{3};
         train_data4(ii, 4) = data(train_idx(ii)).raw_measurement{4};
%          train_data4(ii, 5) = data(train_idx(ii)).raw_measurement{3};
%          train_data4(ii, 6) = data(train_idx(ii)).raw_measurement{7};
%          train_data4(ii, 7) = data(train_idx(ii)).raw_measurement{4};
%          train_data4(ii, 8) = data(train_idx(ii)).raw_measurement{8};

%          train_data5(ii, 1) = data(train_idx(ii)).raw_measurement{1};
%          train_data5(ii, 2) = data(train_idx(ii)).raw_measurement{2};
%          train_data5(ii, 3) = data(train_idx(ii)).raw_measurement{3};
%          train_data5(ii, 4) = data(train_idx(ii)).raw_measurement{4};
%          train_data5(ii, 5) = data(train_idx(ii)).raw_measurement{5};
     end
     
     Mdl1 = fitrsvm(train_data1, train_gt);
     y_hat1 = predict(Mdl1, test_data1);
     abs_diff1 = abs(y_hat1 - test_gt) * 10;  % mm
     MAE1 = MAE1 + mean(abs_diff1);
     std_v1 = std_v1 + std(abs_diff1);
     per1 = per1 + sum(abs_diff1 <= epsilon) / length(abs_diff1);
     
     Mdl2 = fitrsvm(train_data2, train_gt);
     y_hat2 = predict(Mdl2, test_data2);
     abs_diff2 = abs(y_hat2 - test_gt) * 10;  % mm
     MAE2 = MAE2 + mean(abs_diff2);
     std_v2 = std_v2 + std(abs_diff2);
     per2 = per2 + sum(abs_diff2 <= epsilon) / length(abs_diff2);
     
     Mdl3 = fitrsvm(train_data3, train_gt);
     y_hat3 = predict(Mdl3, test_data3);
     abs_diff3 = abs(y_hat3 - test_gt) * 10;  % mm
     MAE3 = MAE3 + mean(abs_diff3);
     std_v3 = std_v3 + std(abs_diff3);
     per3 = per3 + sum(abs_diff3 <= epsilon) / length(abs_diff3);
%      
     Mdl4 = fitrsvm(train_data4, train_gt);
     y_hat4 = predict(Mdl4, test_data4);
     abs_diff4 = abs(y_hat4 - test_gt) * 10;  % mm
     MAE4 = MAE4 + mean(abs_diff4);
     std_v4 = std_v4 + std(abs_diff4);
     per4 = per4 + sum(abs_diff4 <= epsilon) / length(abs_diff4);
     
%      Mdl5 = fitrsvm(train_data5, train_gt);
%      y_hat5 = predict(Mdl5, test_data5);
%      abs_diff5 = abs(y_hat5 - test_gt) * 10;  % mm
%      MAE5 = MAE5 + mean(abs_diff5);
%      std_v5 = std_v5 + std(abs_diff5);
%      per5 = per5 + sum(abs_diff5 <= epsilon) / length(abs_diff5);
     
  end
  
  final_mae1 = final_mae1 + MAE1 / 5;
  final_std1 = final_std1 + std_v1 / 5;
  final_per1 = final_per1 + per1 / 5;
  
  final_mae2 = final_mae2 + MAE2 / 5;
  final_std2 = final_std2 + std_v2 / 5;
  final_per2 = final_per2 + per2 / 5;
  
  final_mae3 = final_mae3 + MAE3 / 5;
  final_std3 = final_std3 + std_v3 / 5;
  final_per3 = final_per3 + per3 / 5;
%   
  final_mae4 = final_mae4 + MAE4 / 5;
  final_std4 = final_std4 + std_v4 / 5;
  final_per4 = final_per4 + per4 / 5;
%   
%   final_mae5 = final_mae5 + MAE5 / 5;
%   final_std5 = final_std5 + std_v5 / 5;
%   final_per5 = final_per5 + per5 / 5;
%   
  
end


final_mae1 = final_mae1 / 100;
final_std1 = final_std1 / 100;
final_per1 = final_per1 / 100;

final_mae2 = final_mae2 / 100;
final_std2 = final_std2 / 100;
final_per2 = final_per2 / 100;

final_mae3 = final_mae3 / 100;
final_std3 = final_std3 / 100;
final_per3 = final_per3 / 100;
% 
final_mae4 = final_mae4 / 100;
final_std4 = final_std4 / 100;
final_per4 = final_per4 / 100;

% final_mae5 = final_mae5 / 100;
% final_std5 = final_std5 / 100;
% final_per5 = final_per5 / 100;
% display results

disp('num_circles = 1');
disp(['MAE = ' num2str(final_mae1) '  std = ' num2str(final_std1) '  percent = ' num2str(final_per1)]);

disp('num_circles = 2');
disp(['MAE = ' num2str(final_mae2) '  std = ' num2str(final_std2) '  percent = ' num2str(final_per2)]);

disp('num_circles = 3');
disp(['MAE = ' num2str(final_mae3) '  std = ' num2str(final_std3) '  percent = ' num2str(final_per3)]);

disp('num_circles = 4');
disp(['MAE = ' num2str(final_mae4) '  std = ' num2str(final_std4) '  percent = ' num2str(final_per4)]);

% disp('num_circles = 5');
% disp(['MAE = ' num2str(final_mae5) '  std = ' num2str(final_std5) '  percent = ' num2str(final_per5)]);

% 
% 
% 
