% surface measurement
% 2018.05.03  Song Yan

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
%--------------------------------------------------------------------------

function [measurement_results] = surface_measurement(V, gender, DATA_DIR)

    measurement_results = struct();
    
    if strcmp(gender, 'female')
        landmarkDir = [DATA_DIR 'measurement_landmarks/female_landmarks/'];
        circle_landmarks = {...
            'female_Ankle_Circ.txt',    'female_Bicep_Circ.txt',        ...
            'female_BUST_Circ.txt',     'female_Calf_Circ.txt',         ...
            'female_Elbow_Circ.txt',    'female_HIP_Circ.txt',          ...
            'female_Knee_Circ.txt',     'female_NaturalWAIST_Circ.txt', ...
            'female_NeckBase_Circ.txt', 'female_Neck_Circ.txt',         ...
            'female_Thigh_Circ.txt',    'female_TrouserWAIST_Circ.txt', ...
            'female_Underbust_Circ.txt','female_Wrist_Circ.txt'};
        
        line_landmarks = {'female_Bust_to_Bust.txt',         ...
                          'female_NeckSide_to_Wrist.txt',    ...
                          'female_Shoulder_to_Shoulder.txt', ...
                          'female_Shoulder_to_Wrist.txt',    ...
                          'female_SideNeck_to_Bust.txt'};
    else
        landmarkDir = [DATA_DIR 'measurement_landmarks/male_landmarks/'];
        circle_landmarks = {...
            'male_Ankle_Circ.txt',    'male_Bicep_Circ.txt',        ...
            'male_Calf_Circ.txt',     'male_CHEST_Circ.txt',        ...
            'male_Elbow_Circ.txt',    'male_HIP_Circ.txt',          ...
            'male_Knee_Circ.txt',     'male_MAXWAIST_Circ.txt',     ...
            'male_NeckBase_Circ.txt', 'male_Neck_Circ.txt',         ...
            'male_Thigh_Circ.txt',    'male_TrouserWAIST_Circ.txt', ...
            'male_Wrist_Circ.txt'};
        
        line_landmarks = {'male_Shoulder_to_Shoulder.txt', ...
                          'male_Shoulder_to_Wrist.txt'};
    end
    
    for ii = 1:length(circle_landmarks)
        part_name = circle_landmarks{ii}(1:end-4);   % e.g. male_Ankle_Circ
        fid = fopen([landmarkDir circle_landmarks{ii}]);
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
                measurement_results.(part_name){line_id} = circumference(V(v_idx, :));
            end
            tline = fgetl(fid);
            line_id = line_id + 1;
        end
        fclose(fid);
    end
    
    for jj = 1:length(line_landmarks)
        part_name = line_landmarks{jj}(1:end-4);
        fid = fopen([landmarkDir line_landmarks{jj}]);
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
                measurement_results.(part_name){line_id} = line_length(V(v_idx, :));
            end
            tline = fgetl(fid);
            line_id = line_id + 1;
        end
        fclose(fid);
    end
    
end