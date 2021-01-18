clear; close all; clc;

gender = 'male';
data_dir = '/home/yan/Data2/NOMO_Project/data/raw_measurement/raw_vs_gt/';

load([data_dir gender '/' gender '_Bicep_Circ.mat']);
data = male_Bicep_Circ;

% load('female_ankle_measurement_new.mat');
% data = ankle_measurement;

epsilon = 6; % mm

error_vector_svr = [];
error_vector_linear = [];


col_num = length(data(1).raw_measurement);  % feature num
% col_num = length(data(1).Circ);  % feature num
% 
obj_list = {data(:).name;};
num_obj = length(obj_list);
% 
% num_obj = length(data);

% nfold = 4;

final_mae1 = 0;        final_mae2 = 0;
final_std1 = 0;        final_std2 = 0;
final_percent1 = 0;    final_percent2 = 0;

final_sigma1 = 0;
final_sigma2 = 0;

% final_mae3 = 0;
% final_std3 = 0;
% final_percent3 = 0;
% 
% final_mae4 = 0;
% final_std4 = 0;
% final_percent4 = 0;
% 
% final_mae5 = 0;
% final_std5 = 0;
% final_percent5 = 0;
% 
% final_mae6 = 0;
% final_std6 = 0;
% final_percent6 = 0;

nIter = 1;

for iter = 1:nIter
    rand_idx = randperm(num_obj);
    folder_num = round(num_obj / 5);
    list_index = ...
      [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, num_obj];

    MAE1 = 0;          MAE2 = 0; 
    std_v1 = 0;        std_v2 = 0;
    percentage1 = 0;   percentage2 = 0;
    
    sigma1 = 0;
    sigma2 = 0;
    
%     MAE3 = 0;
%     std_v3 = 0;
%     percentage3 = 0;
%     
%     MAE4 = 0;
%     std_v4 = 0;
%     percentage4 = 0;
%     
%     MAE5 = 0;
%     std_v5 = 0;
%     percentage5 = 0;
%     
%     MAE6 = 0;
%     std_v6 = 0;
%     percentage6 = 0;
%     
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

    %'linear', 'interactions', 'purequadratic', 'quadratic', 'polyjlk'

    %  Mdl = fitlm(train_data, train_gt, 'linear');
    
     Mdl1 = fitrsvm(train_data, train_gt);
     y_hat1 = predict(Mdl1, test_data);
     MAE1 = MAE1 + mean(abs(y_hat1 - test_gt));
     std_v1 = std_v1 + std(y_hat1 - test_gt);
     percentage1 = percentage1 + sum(abs(y_hat1-test_gt)*10 <= epsilon) / length(y_hat1);
     %calculate std manually
     diff1 = y_hat1 - test_gt;
     error_vector_svr = [error_vector_svr diff1];
     
     mu = mean(diff1);
     sigma1 = sigma1 + sqrt(sum((diff1-mu).^2) / (length(diff1)-1));  % why N-1 not N
     
     Mdl2 = fitlm(train_data, train_gt, 'linear');
     y_hat2 = predict(Mdl2, test_data);
     MAE2 = MAE2 + mean(abs(y_hat2 - test_gt));
     std_v2 = std_v2 + std(y_hat2 - test_gt);
     percentage2 = percentage2 + sum(abs(y_hat2-test_gt)*10 <= epsilon) / length(y_hat2);
     
     diff2 = y_hat2 - test_gt;
     error_vector_linear = [error_vector_linear diff2];
     
     mu = mean(diff2);
     sigma2 = sigma2 + sqrt(sum((diff2-mu).^2) / (length(diff2)-1));
     
%        % Elastic Net Regularization
%        [B,FitInfo] = lasso(train_data,train_gt,'Alpha',0.75,'CV',4);  % 4 folder cross 
%        idxLambda1SE = FitInfo.Index1SE;
%        coef = B(:,idxLambda1SE);
%        coef0 = FitInfo.Intercept(idxLambda1SE);
%        y_hat1 = test_data * coef + coef0;
%        abs_diff1 = abs(y_hat1 - test_gt) * 10;
%        MAE1 = MAE1 + mean(abs_diff1);
% %        std_v1 = std_v1 + std(abs_diff1);
%        std_v1 = std_v1 + std(y_hat1 - test_gt);
%        percentage1 = percentage1 + sum(abs_diff1 <= epsilon) / length(abs_diff1);
% %      
% %        % linear SVR
%        Mdl2 = fitrlinear(train_data, train_gt);
%        y_hat2 = predict(Mdl2, test_data);
%        abs_diff2 = abs(y_hat2 - test_gt)*10;
%        MAE2 = MAE2 + mean(abs_diff2);
% %        std_v2 = std_v2 + std(abs_diff2);
%        std_v2 = std_v2 + std(y_hat2 - test_gt);
%        percentage2 = percentage2 + sum(abs_diff2 <= epsilon) / length(abs_diff2);
% % 
% %        % stepwise lm
%        Mdl3 = stepwiselm(train_data, train_gt, 'linear');
%        y_hat3 = predict(Mdl3, test_data);
%        abs_diff3 = abs(y_hat3 - test_gt)*10;
%        MAE3 = MAE3 + mean(abs_diff3);
% %        std_v3 = std_v3 + std(abs_diff3);
%        std_v3 = std_v3 + std(y_hat3 - test_gt);
%        percentage3 = percentage3 + sum(abs_diff3 <= epsilon) / length(abs_diff3);
% %      
% %        % Gaussian Process regression (GPR) Model
%        Mdl4 = fitrgp(train_data, train_gt);
%        y_hat4 = predict(Mdl4, test_data);
%        abs_diff4 = abs(y_hat4 - test_gt)*10;
%        MAE4 = MAE4 + mean(abs_diff4);
% %        std_v4 = std_v4 + std(abs_diff4);
%        std_v4 = std_v4 + std(y_hat4 - test_gt);
%        percentage4 = percentage4 + sum(abs_diff4 <= epsilon) / length(abs_diff4);
% %      
%        % stepwise regression
% %        b5 = stepwisefit(train_data, train_gt);
% %        y_hat5 = test_data * b5;
% %        abs_diff5 = abs(y_hat5 - test_gt)*10;
% %        MAE5 = MAE5 + mean(abs_diff5);
% %        std_v5 = std_v5 + std(abs_diff5);
% %        percentage5 = percentage5 + sum(abs_diff5 <= epsilon) / length(abs_diff5);
%         
%        % Gaussian Kernel Regression
% %        Mdl5 = fitrkernel(train_data, train_gt);
% %        y_hat5 = predict(Mdl5,test_data);
% 
%        % ensemble of learners for regression
%        Mdl5 = fitrensemble(train_data, train_gt);
%        y_hat5 = predict(Mdl5, test_data);
%        abs_diff5 = abs(y_hat5 - test_gt)*10;
%        MAE5 = MAE5 + mean(abs_diff5);
% %        std_v5 = std_v5 + std(abs_diff5);
%        std_v5 = std_v5 + std(y_hat5 - test_gt);
%        percentage5 = percentage5 + sum(abs_diff5 <= epsilon) / length(abs_diff5);
%         
%        % Binary regression decision tree
%        tree = fitrtree(train_data, train_gt);
%        y_hat6 = predict(tree, test_data);
%        abs_diff6 = abs(y_hat6 - test_gt)*10;
%        MAE6 = MAE6 + mean(abs_diff6);
% %        std_v6 = std_v6 + std(abs_diff6);
%        std_v6 = std_v6 + std(y_hat6 - test_gt);
%        percentage6 = percentage6 + sum(abs_diff6 <= epsilon) / length(abs_diff6);
        
    end

    final_mae1 = final_mae1 + MAE1 / 5;
    final_std1 = final_std1 + std_v1 / 5;
    final_percent1 = final_percent1 + percentage1 / 5;
    
    final_mae2 = final_mae2 + MAE2 / 5;
    final_std2 = final_std2 + std_v2 / 5;
    final_percent2 = final_percent2 + percentage2 / 5;
    
    final_sigma1 = final_sigma1 + sigma1 / 5;
    final_sigma2 = final_sigma2 + sigma2 / 5;
%     final_mae3 = final_mae3 + MAE3 / 5;
%     final_std3 = final_std3 + std_v3 / 5;
%     final_percent3 = final_percent3 + percentage3 / 5;
%     
%     final_mae4 = final_mae4 + MAE4 / 5;
%     final_std4 = final_std4 + std_v4 / 5;
%     final_percent4 = final_percent4 + percentage4 / 5;
% %     
%     final_mae5 = final_mae5 + MAE5 / 5;
%     final_std5 = final_std5 + std_v5 / 5;
%     final_percent5 = final_percent5 + percentage5 / 5;
% 
%     final_mae6 = final_mae6 + MAE6 / 5;
%     final_std6 = final_std6 + std_v6 / 5;
%     final_percent6 = final_percent6 + percentage6 / 5;
end

clc

final_mae1 = final_mae1 / nIter;
final_std1 = final_std1 / nIter;
final_percent1 = final_percent1 / nIter;

final_mae2 = final_mae2 / nIter;
final_std2 = final_std2 / nIter;
final_percent2 = final_percent2 / nIter;

final_sigma1 = final_sigma1 / nIter *10
final_sigma2 = final_sigma2 / nIter *10
% 
% final_mae3 = final_mae3 / nIter;
% final_std3 = final_std3 / nIter;
% final_percent3 = final_percent3 / nIter;
% 
% final_mae4 = final_mae4 / nIter;
% final_std4 = final_std4 / nIter;
% final_percent4 = final_percent4 / nIter;
% % 
% final_mae5 = final_mae5 / nIter;
% final_std5 = final_std5 / nIter;
% final_percent5 = final_percent5 / nIter;
% 
% final_mae6 = final_mae6 / nIter;
% final_std6 = final_std6 / nIter;
% final_percent6 = final_percent6 / nIter;

% display results
disp('non-linear SVR');
disp(['MAE = ' num2str(final_mae1*10) '  std = ' num2str(final_std1*10) '  percent = ' num2str(final_percent1)]);

disp('Linear Regression');
disp(['MAE = ' num2str(final_mae2*10) '  std = ' num2str(final_std2*10) '  percent = ' num2str(final_percent2)]);


% 
% disp('Elastice Net');
% disp(['MAE = ' num2str(final_mae1) '  std = ' num2str(final_std1) '  percent = ' num2str(final_percent1)]);
% 
% disp('Linear SVR');
% disp(['MAE = ' num2str(final_mae2) '  std = ' num2str(final_std2) '  percent = ' num2str(final_percent2)]);

% disp('stepwiselm');
% disp(['MAE = ' num2str(final_mae3) '  std = ' num2str(final_std3) '  percent = ' num2str(final_percent3)]);
% 
% disp('Gaussian Process Regression(GPR)');
% disp(['MAE = ' num2str(final_mae4) '  std = ' num2str(final_std4) '  percent = ' num2str(final_percent4)]);
% 
% % disp('Gaussian Kernel Regression'); % fitrkernel trains a Gaussian kernel regression model for nonlinear regression.
% % disp(['MAE = ' num2str(final_mae5) '  std = ' num2str(final_std5) '  percent = ' num2str(final_percent5)]);
% % % 
% % 
% disp('Ensemble of learners for regression');
% disp(['MAE = ' num2str(final_mae5) '  std = ' num2str(final_std5) '  percent = ' num2str(final_percent5)]);
% % 
% 
% disp('Binary Regression Decision Tree');
% disp(['MAE = ' num2str(final_mae6) '  std = ' num2str(final_std6) '  percent = ' num2str(final_percent6)]);
% % 
% 
