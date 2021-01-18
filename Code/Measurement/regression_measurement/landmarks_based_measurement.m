%% 
%           LANDMARKS                      TYPE      NUM
%--------------------------------------------------------------------------
%     male_Ankle_Circ.txt                 circle      6
%     male_Bicep_Circ.txt                 circle      8
%     male_Calf_Circ.txt                  circle      6
%     male_CHEST_Circ.txt                 circle      5
%     male_Elbow_Circ.txt                 circle      9
%     male_HIP_Circ.txt                   circle      4
%     male_Knee_Circ.txt                  circle      6
%     male_MAXWAIST_Circ.txt              circle      4
%     male_NeckBase_Circ.txt              circle      3
%     male_Neck_Circ.txt                  circle      4
%     male_Thigh_Circ.txt                 circle      8
%     male_TrouserWAIST_Circ.txt          circle      3
%     male_Wrist_Circ.txt                 circle      6

%     male_Shoulder_to_Shoulder.txt       line        4
%     male_Shoulder_to_Wrist.txt          line        6
%--------------------------------------------------------------------------
%     female_Ankle_Circ.txt               circle      6
%     female_Bicep_Circ.txt               circle      8
%     female_BUST_Circ.txt                circle      3
%     female_Calf_Circ.txt                circle      6
%     female_Elbow_Circ.txt               circle      6
%     female_HIP_Circ.txt                 circle      4
%     female_Knee_Circ.txt                circle      6
%     female_NaturalWAIST_Circ.txt        circle      5
%     female_NeckBase_Circ.txt            circle      3
%     female_Neck_Circ.txt                circle      5
%     female_Thigh_Circ.txt               circle      9
%     female_TrouserWAIST_Circ.txt        circle      3
%     female_Underbust_Circ.txt           circle      2
%     female_Wrist_Circ.txt               circle      8

%     female_Bust_to_Bust.txt             line        9
%     female_NeckSide_to_Wrist.txt        line        4
%     female_Shoulder_to_Shoulder.txt     line        4
%     female_Shoulder_to_Wrist.txt        line        8
%     female_SideNeck_to_Bust.txt         line        6

%%
clear all; close all; clc;
%--------------------------------------------------------------------------
gender = 'male';  % female
type = 'Circle';    % Line

data_dir = '/home/yan/Data2/NOMO_Project/data/';
%
landmarks_dir = [data_dir 'measurement_landmarks/' gender '_landmarks/'];
landmarks_list = dir([landmarks_dir '*.txt']);
num_landmakrs = length(landmarks_list);
disp(['for ' gender ' : ' num2str(num_landmakrs) ' landmarks files']);
%
mesh_dir = [data_dir 'registered_mesh/' gender '_nonrigidICP_boarder/'];
mesh_list = dir([mesh_dir '*.obj']);
num_mesh = length(mesh_list);
disp(['for ' gender ' : ' num2str(num_mesh) ' registered meshes']);
%
save_dir = [data_dir 'raw_measurement/' gender '/'];
%
for mesh_id = 1:num_mesh
    mesh_name = mesh_list(mesh_id).name;
    [V, ~] = loadObj([mesh_dir mesh_name]);
    
    raw_measurement = struct();
    raw_measurement.name = mesh_name;
    
    for idx = 1:num_landmakrs
        file_name = landmarks_list(idx).name;
        %
        if strcmp(file_name(end-7:end-4), 'Circ')
            type = 'Circle';
        else
            type = 'Line';
        end
        %
        if strcmp(gender,'male')
            part_name = file_name(6:end-4);
        elseif strcmp(gender,'female')
            part_name = file_name(8:end-4);
        end
        %
        fid = fopen([landmarks_dir file_name]);
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
                if strcmp(type, 'Circle')
                    raw_measurement.(part_name){line_id} = circumference(V(v_idx, :));
                elseif strcmp(type, 'Line')
                    raw_measurement.(part_name){line_id} = line_length(V(v_idx, :));
                end
            end
            tline = fgetl(fid);
            line_id = line_id + 1;
        end
        fclose(fid);
    end
    %
    save([save_dir 'raw_measurement_' num2str(mesh_id) '.mat'], 'raw_measurement');
end

