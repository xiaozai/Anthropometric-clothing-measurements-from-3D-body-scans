% check Ankle_Circ measurement

%% draw red color on Landmakrs
clear all; close all; clc;

gender = 'female';
data_dir = '/home/yan/Data2/NOMO_Project/data/';
landmark_file = [data_dir 'measurement_landmarks/' gender '_landmarks/' gender '_Ankle_Circ.txt'];

mesh_dir = [data_dir 'registered_mesh/' gender '_nonrigidICP_boarder/'];
mesh_list = dir([mesh_dir '*.obj']);

save_dir = [data_dir 'test_mesh/' gender '/'];

landmarks = [];
fid = fopen(landmark_file, 'r');
tline = fgetl(fid);
while ischar(tline)
    C = strsplit(tline);
    if length(C) < 1
        continue;
    end
    if strcmp(C{1}, 'v')
        v_idx = cellfun(@str2num, C(2:end));
        v_idx = v_idx + 1;
        landmarks = [landmarks v_idx];
    end
    tline = fgetl(fid);
end
fclose(fid);

num_obj = length(mesh_list);
rand_idx = randperm(num_obj);

for ii = 1:30
    objName = mesh_list(rand_idx(ii)).name;
    [V, F] = loadObj([mesh_dir objName]);
    
    new_V = [V zeros(size(V, 1), 3)];
    new_V(landmarks, 4) = 255;
    
    fid = fopen([save_dir objName], 'w');
    for vv = 1: size(V, 1)
        fprintf(fid, 'v %f %f %f %d %d %d\n', ...
            new_V(vv, 1),new_V(vv, 2), new_V(vv, 3), new_V(vv, 4), new_V(vv, 5), new_V(vv, 6));
    end
    
    for ff = 1:size(F, 1)
        fprintf(fid, 'f %d %d %d\n', F(ff, 1), F(ff, 2), F(ff, 3));
    end
    fclose(fid);
end

%% get raw measurements based on Landmarks

clear all; close all; clc;


gender = 'female';  % female
type = 'Circle';    % Line

data_dir = '/home/yan/Data2/NOMO_Project/data/';

landmarks_dir = [data_dir 'measurement_landmarks/' gender '_landmarks/'];
ankle_landmarks = [landmarks_dir 'female_Ankle_Circ.txt'];


mesh_dir = [data_dir 'registered_mesh/' gender '_nonrigidICP_boarder/'];
mesh_list = dir([mesh_dir '*.obj']);
num_mesh = length(mesh_list);
disp(['for ' gender ' : ' num2str(num_mesh) ' registered meshes']);

ankle_measurement = struct();

for mesh_id = 1:num_mesh
    mesh_name = mesh_list(mesh_id).name;
    [V, ~] = loadObj([mesh_dir mesh_name]);
    
    ankle_measurement(mesh_id).name = mesh_name;

    fid = fopen(ankle_landmarks, 'r');
    line_id = 1;
    tline = fgetl(fid);
    while ischar(tline)
        C = strsplit(tline, ' ');
        if length(C) < 1
            continue;
        end
        if C{1} == 'v'
            v_idx = cellfun(@str2num, C(2:end));
            v_idx = v_idx + 1;
            ankle_measurement(mesh_id).Circ(line_id) = circumference(V(v_idx, :));
            line_id = line_id + 1;
        end
        tline = fgetl(fid);
    end
    fclose(fid);
end

%% match with GT

gt_file = [data_dir 'measurement_GT/' gender '_measurement_gt.mat'];
load(gt_file);  % female_measurement_gt OR male_measurement_gt
gt = female_measurement_gt; % or 

gt_name_list = {gt(:).name;};
num_gt = length(gt);
disp(['for ' gender ' : ' num2str(num_gt) ' gt data records']);

for mesh_id = 1:num_mesh
    mesh_name = ankle_measurement(mesh_id).name;
    index = find(contains(gt_name_list, mesh_name));
    if ~isempty(index)
        ankle_measurement(mesh_id).gt = gt(index).Ankle_Circ;
    end
end

%%  remove some bad data  g.t. = -0.01 or 8.5
ankle_measurement(70) = [];
ankle_measurement(180) = [];
ankle_measurement(180) = [];
ankle_measurement(105) = [];

%%  regression
epsilon = 4; % Allowable Error

data = ankle_measurement;
num_valid_mesh = length(ankle_measurement);

rand_idx = randperm(num_valid_mesh);
folder_num = round(num_valid_mesh / 5);
list_index = ...
     [0, folder_num, folder_num * 2, folder_num * 3, folder_num * 4, num_valid_mesh];
 
MAE = 0; std_v = 0;
percentage = 0;

col_num = 6;
for idx = 1:5               
 test_idx = rand_idx(list_index(idx)+1 : list_index(idx+1));
 train_idx = setdiff(rand_idx, test_idx, 'stable');
 
 test_gt = [data(test_idx).gt]';
 row_num = length(test_idx);
 test_data = zeros(row_num, col_num);
 for ii = 1:row_num
%      test_data(ii, 1) = data(test_idx(ii)).Circ(1);
%      test_data(ii, 2) = data(test_idx(ii)).Circ(2);
%      test_data(ii, 3) = data(test_idx(ii)).Circ(4);
%      test_data(ii, 4) = data(test_idx(ii)).Circ(5);
     for jj = 1:col_num
         test_data(ii, jj) = data(test_idx(ii)).Circ(jj);
     end
 end
 
 train_gt = [data(train_idx).gt]';
 row_num = length(train_idx);
 train_data = zeros(row_num, col_num);
 for ii = 1:row_num
%      train_data(ii, 1) = data(train_idx(ii)).Circ(1);
%      train_data(ii, 2) = data(train_idx(ii)).Circ(2);
%      train_data(ii, 3) = data(train_idx(ii)).Circ(4);
%      train_data(ii, 4) = data(train_idx(ii)).Circ(5);
     for jj = 1:col_num
         train_data(ii, jj) = data(train_idx(ii)).Circ(jj);
     end
 end
 
%'linear', 'interactions', 'purequadratic', 'quadratic', 'polyjlk'
%  Mdl = stepwiselm(train_data, train_gt, 'linear');

 Mdl = fitlm(train_data, train_gt, 'linear');
%  Mdl = fitrsvm(train_data, train_gt);
 y_hat = predict(Mdl, test_data);
 
 abs_diff = abs(y_hat - test_gt)*10; %mm
 percentage = percentage + sum(abs_diff <= epsilon) / length(abs_diff);
 
 MAE = MAE + mean(abs_diff);
 std_v = std_v + std(abs_diff);
 
end

MAE = MAE / 5
std_v = std_v / 5
percentage = percentage / 5


















