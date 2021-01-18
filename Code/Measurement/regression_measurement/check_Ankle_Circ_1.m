ankle_data = zeros(192, 7);
for idx = 1:192
ankle_data(idx, 1) = data(idx).gt;
ankle_data(idx, 2) = data(idx).raw_measurement{1};
ankle_data(idx, 3) = data(idx).raw_measurement{2};
ankle_data(idx, 4) = data(idx).raw_measurement{3};
ankle_data(idx, 5) = data(idx).raw_measurement{4};
ankle_data(idx, 6) = data(idx).raw_measurement{5};
ankle_data(idx, 7) = data(idx).raw_measurement{6};
end

% save('/home/yan/Data2/NOMO_Project/data/raw_measurement/raw_vs_gt/female_ankle_data.mat', 'ankle_data');

ankle_data(92, :) = [];  % bad data

% rand_idx = randperm(191);
% test_data = ankle_data(rand_idx(1:38), 2:7);
% test_gt = ankle_data(rand_idx(1:38), 1);
% train_data = ankle_data(rand_idx(39:end), 2:7);
% train_gt = ankle_data(rand_idx(39:end), 1);
% 
% 
% Mdl = fitrsvm(train_data, train_gt);
% y_hat = predict(Mdl, test_data);
% MAE = mean(abs(y_hat - test_gt))


rand_idx = randperm(191);
folder_num = round(191 / 5);
list_index = ...
     [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, 191];
 
MAE = 0; std_v = 0;

for idx = 1:5               
 test_idx = rand_idx(list_index(idx)+1 : list_index(idx+1));
 train_idx = setdiff(rand_idx, test_idx, 'stable');
 
 test_gt = ankle_data(test_idx, 1);
 test_data = ankle_data(test_idx, 2:7);
 
 train_gt = ankle_data(train_idx, 1);
 train_data = ankle_data(train_idx, 2:7);
 
%'linear', 'interactions', 'purequadratic', 'quadratic', 'polyjlk'
%  Mdl = stepwiselm(train_data, train_gt, 'linear');

%  Mdl = fitlm(train_data, train_gt, 'linear');
 Mdl = fitrsvm(train_data, train_gt);
 y_hat = predict(Mdl, test_data);
 
 MAE = MAE + mean(abs(y_hat - test_gt));
 std_v = std_v + std(abs(y_hat - test_gt));
 
end

MAE = MAE / 5
std_v = std_v / 5


