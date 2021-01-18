% match raw_measurement with gt (ord file)
%--------------------------------------------------------------------------
%    - male_Ankle_Circ.mat    
%    - male_Bicep_Circ.mat          
%    - male_Calf_Circ.mat            
%    - male_CHEST_Circ.mat         
%    - male_Elbow_Circ.mat         
%    - male_HIP_Circ.mat           
%    - male_Knee_Circ.mat          
%    - male_MAXWAIST_Circ.mat     
%    - male_NeckBase_Circ.mat        
%    - male_Neck_Circ.mat           
%    - male_Thigh_Circ.mat         
%    - male_TrouserWAIST_Circ.mat   
%    - male_Wrist_Circ.mat          
%    - male_Shoulder_to_Shoulder.mat
%    - male_Shoulder_to_Wrist.mat    
%--------------------------------------------------------------------------   
%    - female_Ankle_Circ.mat    
%    - female_Bicep_Circ.mat  
%    - female_BUST_Circ.mat
%    - female_Calf_Circ.mat                    
%    - female_Elbow_Circ.mat         
%    - female_HIP_Circ.mat           
%    - female_Knee_Circ.mat          
%    - female_NaturalWAIST_Circ.mat     
%    - female_NeckBase_Circ.mat        
%    - female_Neck_Circ.mat           
%    - female_Thigh_Circ.mat         
%    - female_TrouserWAIST_Circ.mat 
%    - female_Underbust_Circ.mat
%    - female_Wrist_Circ.mat     
%    - female_Bust_to_Bust.mat
%    - female_NeckSide_to_Wrist.mat
%    - female_Shoulder_to_Shoulder.mat
%    - female_Shoulder_to_Wrist.mat
%    - female_SideNeck_to_Bust.mat
%--------------------------------------------------------------------------
%  data structure, for example: 
%      -       name       = ''
%      -        gt        = xxx
%      - raw_measurement  = {}

%--------------------------------------------------------------------------
clear ; close all; clc;

gender = 'male';
data_dir = '/home/yan/Data2/NOMO_Project/data/';

gt_file = [data_dir 'measurement_GT/' gender '_measurement_gt.mat'];
load(gt_file);  % female_measurement_gt OR male_measurement_gt
gt = male_measurement_gt; % or 

gt_name_list = {gt(:).name;};
num_gt = length(gt);
disp(['for ' gender ' : ' num2str(num_gt) ' gt data records']);

raw_measurement_dir = [data_dir 'raw_measurement/' gender '/'];
raw_measurement_list = dir([raw_measurement_dir '*.mat']);
num_raw = length(raw_measurement_list);
disp(['for ' gender ' : ' num2str(num_raw) ' raw measurement records']);

save_dir = [data_dir 'raw_measurement/raw_vs_gt/' gender '/'];

%--------------------------------------------------------------------------
male_Ankle_Circ           = struct();
male_Bicep_Circ           = struct();         
male_Calf_Circ            = struct();           
male_CHEST_Circ           = struct();       
male_Elbow_Circ           = struct();       
male_HIP_Circ             = struct();          
male_Knee_Circ            = struct();          
male_MaxWAIST_Circ        = struct();    
male_NeckBase_Circ        = struct();      
male_Neck_Circ            = struct();           
male_Thigh_Circ           = struct();         
male_TrouserWAIST_Circ    = struct();   
male_Wrist_Circ           = struct();         
male_Shoulder_to_Shoulder = struct();
male_Shoulder_to_Wrist    = struct(); 
%--------------------------------------------------------------------------
% female_Ankle_Circ         = struct();  
% female_Bicep_Circ         = struct();  
% female_BUST_Circ          = struct();
% female_Calf_Circ          = struct();                    
% female_Elbow_Circ         = struct();        
% female_HIP_Circ           = struct();           
% female_Knee_Circ          = struct();          
% female_NaturalWAIST_Circ  = struct();    
% female_NeckBase_Circ      = struct();        
% female_Neck_Circ          = struct();          
% female_Thigh_Circ         = struct();        
% female_TrouserWAIST_Circ  = struct();
% female_Underbust_Circ     = struct();
% female_Wrist_Circ         = struct();     
% female_Bust_to_Bust       = struct();
% female_NeckSide_to_Wrist  = struct();
% female_Shoulder_to_Shoulder = struct();
% female_Shoulder_to_Wrist  = struct();
% female_SideNeck_to_Bust   = struct();
%--------------------------------------------------------------------------
valid_id = 1;

for idx = 1:num_raw
    % raw_measurement_XXX.mat  => raw_measurement
    load([raw_measurement_dir raw_measurement_list(idx).name]);
    obj_name = raw_measurement.name;
    % find the corresponding name in gt_name_list
    index = find(contains(gt_name_list, obj_name));
    if ~isempty(index)
        male_Ankle_Circ(valid_id).name           = obj_name;
        male_Bicep_Circ(valid_id).name           = obj_name;         
        male_Calf_Circ(valid_id).name            = obj_name;           
        male_CHEST_Circ(valid_id).name           = obj_name;       
        male_Elbow_Circ(valid_id).name           = obj_name;      
        male_HIP_Circ(valid_id).name             = obj_name;          
        male_Knee_Circ(valid_id).name            = obj_name;         
        male_MaxWAIST_Circ(valid_id).name        = obj_name;    
        male_NeckBase_Circ(valid_id).name        = obj_name;     
        male_Neck_Circ(valid_id).name            = obj_name;           
        male_Thigh_Circ(valid_id).name           = obj_name;         
        male_TrouserWAIST_Circ(valid_id).name    = obj_name;   
        male_Wrist_Circ(valid_id).name           = obj_name;         
        male_Shoulder_to_Shoulder(valid_id).name = obj_name;
        male_Shoulder_to_Wrist(valid_id).name    = obj_name;
        
        male_Ankle_Circ(valid_id).gt           = gt(index).Ankle_Circ;
        male_Bicep_Circ(valid_id).gt           = gt(index).Bicep_Circ;         
        male_Calf_Circ(valid_id).gt            = gt(index).Calf_Circ;           
        male_CHEST_Circ(valid_id).gt           = gt(index).CHEST_Circ;       
        male_Elbow_Circ(valid_id).gt           = gt(index).Elbow_Circ;     
        male_HIP_Circ(valid_id).gt             = gt(index).HIP_Circ;          
        male_Knee_Circ(valid_id).gt            = gt(index).Knee_Circ;         
        male_MaxWAIST_Circ(valid_id).gt        = gt(index).MaxWAIST_Circ;    
        male_NeckBase_Circ(valid_id).gt        = gt(index).NeckBase_Circ;     
        male_Neck_Circ(valid_id).gt            = gt(index).Neck_Circ;           
        male_Thigh_Circ(valid_id).gt           = gt(index).Thigh_Circ;         
        male_TrouserWAIST_Circ(valid_id).gt    = gt(index).TrouserWAIST_Circ;   
        male_Wrist_Circ(valid_id).gt           = gt(index).Wrist_Circ;         
        male_Shoulder_to_Shoulder(valid_id).gt = gt(index).Shoulder_to_Shoulder;
        male_Shoulder_to_Wrist(valid_id).gt    = gt(index).Shoulder_to_Wrist;
        
        male_Ankle_Circ(valid_id).raw_measurement           = raw_measurement.Ankle_Circ;
        male_Bicep_Circ(valid_id).raw_measurement           = raw_measurement.Bicep_Circ;         
        male_Calf_Circ(valid_id).raw_measurement            = raw_measurement.Calf_Circ;           
        male_CHEST_Circ(valid_id).raw_measurement           = raw_measurement.CHEST_Circ;       
        male_Elbow_Circ(valid_id).raw_measurement           = raw_measurement.Elbow_Circ;      
        male_HIP_Circ(valid_id).raw_measurement             = raw_measurement.HIP_Circ;          
        male_Knee_Circ(valid_id).raw_measurement            = raw_measurement.Knee_Circ;         
        male_MaxWAIST_Circ(valid_id).raw_measurement        = raw_measurement.MAXWAIST_Circ;    
        male_NeckBase_Circ(valid_id).raw_measurement        = raw_measurement.NeckBase_Circ;     
        male_Neck_Circ(valid_id).raw_measurement            = raw_measurement.Neck_Circ;           
        male_Thigh_Circ(valid_id).raw_measurement           = raw_measurement.Thigh_Circ;         
        male_TrouserWAIST_Circ(valid_id).raw_measurement    = raw_measurement.TrouserWAIST_Circ;   
        male_Wrist_Circ(valid_id).raw_measurement           = raw_measurement.Wrist_Circ;         
        male_Shoulder_to_Shoulder(valid_id).raw_measurement = raw_measurement.Shoulder_to_Shoulder;
        male_Shoulder_to_Wrist(valid_id).raw_measurement    = raw_measurement.Shoulder_to_Wrist;
        
        
%         female_Ankle_Circ(valid_id).name           = obj_name;  
%         female_Bicep_Circ(valid_id).name           = obj_name;  
%         female_BUST_Circ(valid_id).name            = obj_name;
%         female_Calf_Circ(valid_id).name            = obj_name;                    
%         female_Elbow_Circ(valid_id).name           = obj_name;       
%         female_HIP_Circ(valid_id).name             = obj_name;           
%         female_Knee_Circ(valid_id).name            = obj_name;          
%         female_NaturalWAIST_Circ(valid_id).name    = obj_name;    
%         female_NeckBase_Circ(valid_id).name        = obj_name;        
%         female_Neck_Circ(valid_id).name            = obj_name;          
%         female_Thigh_Circ(valid_id).name           = obj_name;        
%         female_TrouserWAIST_Circ(valid_id).name    = obj_name;
%         female_Underbust_Circ(valid_id).name       = obj_name;
%         female_Wrist_Circ(valid_id).name           = obj_name;     
%         female_Bust_to_Bust(valid_id).name         = obj_name;
%         female_NeckSide_to_Wrist(valid_id).name    = obj_name;
%         female_Shoulder_to_Shoulder(valid_id).name = obj_name;
%         female_Shoulder_to_Wrist(valid_id).name    = obj_name;
%         female_SideNeck_to_Bust(valid_id).name     = obj_name;
%         
%         female_Ankle_Circ(valid_id).gt           = gt(index).Ankle_Circ;
%         female_Bicep_Circ(valid_id).gt           = gt(index).Bicep_Circ;
%         female_BUST_Circ(valid_id).gt            = gt(index).BUST_Circ;
%         female_Calf_Circ(valid_id).gt            = gt(index).Calf_Circ;                
%         female_Elbow_Circ(valid_id).gt           = gt(index).Elbow_Circ;     
%         female_HIP_Circ(valid_id).gt             = gt(index).HIP_Circ;          
%         female_Knee_Circ(valid_id).gt            = gt(index).Knee_Circ;         
%         female_NaturalWAIST_Circ(valid_id).gt    = gt(index).NaturalWAIST_Circ;    
%         female_NeckBase_Circ(valid_id).gt        = gt(index).NeckBase_Circ;     
%         female_Neck_Circ(valid_id).gt            = gt(index).Neck_Circ;           
%         female_Thigh_Circ(valid_id).gt           = gt(index).Thigh_Circ;         
%         female_TrouserWAIST_Circ(valid_id).gt    = gt(index).TrouserWAIST_Circ;  
%         female_Underbust_Circ(valid_id).gt       = gt(index).Underbust_Circ;
%         female_Wrist_Circ(valid_id).gt           = gt(index).Wrist_Circ;
%         female_Bust_to_Bust(valid_id).gt         = gt(index).Bust_to_Bust;
%         female_NeckSide_to_Wrist(valid_id).gt    = gt(index).NeckSide_to_Wrist;
%         female_Shoulder_to_Shoulder(valid_id).gt = gt(index).Shoulder_to_Shoulder;
%         female_Shoulder_to_Wrist(valid_id).gt    = gt(index).Shoulder_to_Wrist;
%         female_SideNeck_to_Bust(valid_id).gt     = gt(index).SideNeck_to_Bust;
% 
%         
%         female_Ankle_Circ(valid_id).raw_measurement           = raw_measurement.Ankle_Circ;  
%         female_Bicep_Circ(valid_id).raw_measurement           = raw_measurement.Bicep_Circ;  
%         female_BUST_Circ(valid_id).raw_measurement            = raw_measurement.BUST_Circ;
%         female_Calf_Circ(valid_id).raw_measurement            = raw_measurement.Calf_Circ;                    
%         female_Elbow_Circ(valid_id).raw_measurement           = raw_measurement.Elbow_Circ;       
%         female_HIP_Circ(valid_id).raw_measurement             = raw_measurement.HIP_Circ;           
%         female_Knee_Circ(valid_id).raw_measurement            = raw_measurement.Knee_Circ;          
%         female_NaturalWAIST_Circ(valid_id).raw_measurement    = raw_measurement.NaturalWAIST_Circ;    
%         female_NeckBase_Circ(valid_id).raw_measurement        = raw_measurement.NeckBase_Circ;        
%         female_Neck_Circ(valid_id).raw_measurement            = raw_measurement.Neck_Circ;          
%         female_Thigh_Circ(valid_id).raw_measurement           = raw_measurement.Thigh_Circ;        
%         female_TrouserWAIST_Circ(valid_id).raw_measurement    = raw_measurement.TrouserWAIST_Circ;
%         female_Underbust_Circ(valid_id).raw_measurement       = raw_measurement.Underbust_Circ;
%         female_Wrist_Circ(valid_id).raw_measurement           = raw_measurement.Wrist_Circ;     
%         female_Bust_to_Bust(valid_id).raw_measurement         = raw_measurement.Bust_to_Bust;
%         female_NeckSide_to_Wrist(valid_id).raw_measurement    = raw_measurement.NeckSide_to_Wrist;
%         female_Shoulder_to_Shoulder(valid_id).raw_measurement = raw_measurement.Shoulder_to_Shoulder;
%         female_Shoulder_to_Wrist(valid_id).raw_measurement    = raw_measurement.Shoulder_to_Wrist;
%         female_SideNeck_to_Bust(valid_id).raw_measurement     = raw_measurement.SideNeck_to_Bust;
        
        
        valid_id = valid_id + 1;
    end
    
end

% male
save([save_dir 'male_Ankle_Circ.mat'], 'male_Ankle_Circ');
save([save_dir 'male_Bicep_Circ.mat'], 'male_Bicep_Circ');
save([save_dir 'male_Calf_Circ.mat'], 'male_Calf_Circ');
save([save_dir 'male_CHEST_Circ.mat'], 'male_CHEST_Circ');
save([save_dir 'male_Elbow_Circ.mat'], 'male_Elbow_Circ');
save([save_dir 'male_HIP_Circ.mat'], 'male_HIP_Circ');
save([save_dir 'male_Knee_Circ.mat'], 'male_Knee_Circ');
save([save_dir 'male_MaxWAIST_Circ.mat'], 'male_MaxWAIST_Circ');
save([save_dir 'male_NeckBase_Circ.mat'], 'male_NeckBase_Circ');
save([save_dir 'male_Neck_Circ.mat'], 'male_Neck_Circ');
save([save_dir 'male_Thigh_Circ.mat'], 'male_Thigh_Circ');
save([save_dir 'male_TrouserWAIST_Circ.mat'], 'male_TrouserWAIST_Circ');
save([save_dir 'male_Wrist_Circ.mat'], 'male_Wrist_Circ');
save([save_dir 'male_Shoulder_to_Shoulder.mat'], 'male_Shoulder_to_Shoulder');
save([save_dir 'male_Shoulder_to_Wrist.mat'], 'male_Shoulder_to_Wrist');

% female
% save([save_dir 'female_Ankle_Circ.mat'], 'female_Ankle_Circ');    
% save([save_dir 'female_Bicep_Circ.mat'], 'female_Bicep_Circ');  
% save([save_dir 'female_BUST_Circ.mat'], 'female_BUST_Circ');
% save([save_dir 'female_Calf_Circ.mat'], 'female_Calf_Circ');                    
% save([save_dir 'female_Elbow_Circ.mat'], 'female_Elbow_Circ');        
% save([save_dir 'female_HIP_Circ.mat'], 'female_HIP_Circ');           
% save([save_dir 'female_Knee_Circ.mat'], 'female_Knee_Circ');          
% save([save_dir 'female_NaturalWAIST_Circ.mat'], 'female_NaturalWAIST_Circ');    
% save([save_dir 'female_NeckBase_Circ.mat'], 'female_NeckBase_Circ');       
% save([save_dir 'female_Neck_Circ.mat'], 'female_Neck_Circ');           
% save([save_dir 'female_Thigh_Circ.mat'], 'female_Thigh_Circ');         
% save([save_dir 'female_TrouserWAIST_Circ.mat'], 'female_TrouserWAIST_Circ'); 
% save([save_dir 'female_Underbust_Circ.mat'], 'female_Underbust_Circ');
% save([save_dir 'female_Wrist_Circ.mat'], 'female_Wrist_Circ');    
% save([save_dir 'female_Bust_to_Bust.mat'], 'female_Bust_to_Bust');
% save([save_dir 'female_NeckSide_to_Wrist.mat'], 'female_NeckSide_to_Wrist');
% save([save_dir 'female_Shoulder_to_Shoulder.mat'], 'female_Shoulder_to_Shoulder');
% save([save_dir 'female_Shoulder_to_Wrist.mat'], 'female_Shoulder_to_Wrist');
% save([save_dir 'female_SideNeck_to_Bust.mat'], 'female_SideNeck_to_Bust');







