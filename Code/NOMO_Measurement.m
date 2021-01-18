% The whole process of 3D human body measurement
%
% input   : scan mesh (the path to .obj file)
% output  : measurement results (after regrssion)
%
% 2018.05.03  Song Yan
%--------------------------------------------------------------------------

% 1) change these paths to your own folder, where all code is saved

% 2) scan_mesh : the path to scan mesh, which is scaled and rotated already
% 3) gender    : 'female',  or , 'male'
% 4) NOMO_DIR  : the NOMO code folder e.g.'/home/yan/Data2/NOMO_Project_P1/';
% 5) SAVE_DIR  : where the results are saved (e.g. registered mesh ...)

function [measurement_result] = NOMO_Measurement(scan_mesh, gender, NOMO_DIR, SAVE_DIR)
    % add the specified folders to search the functions
    addpath([NOMO_DIR 'NonRigid_ICP/'])
    addpath([NOMO_DIR 'Measurement/regression_measurement/'])
    % where the data (meshes, scans, models) is saved
    DATA_DIR = [NOMO_DIR 'data/'];

    % Stage 1: Registration Process
    disp('Registration Process ...');
    %----------------------------------------------------------------------
    Options.gamm = 1;
    Options.epsilon = 1e-4;
    Options.maxIter = 500;
    Options.alphaSet = linspace(100, 1, 100);
    
    if strcmp(gender,'female')
        source_obj = [DATA_DIR 'smpl_mesh/init_template_female.obj'];
    else
        source_obj = [DATA_DIR 'smpl_mesh/init_template_male.obj'];
    end
    [source.vertices, source.faces] = loadObj(source_obj);
    [target.vertices, target.faces] = loadObj(scan_mesh);
    NonRigid_ICP(source, target, [SAVE_DIR 'registered_mesh.obj'], Options);
    
    % Stage 2: Surface Measurement
    disp('Surface Measurement ... ');
    %----------------------------------------------------------------------
    [V, ~] = loadObj([SAVE_DIR 'registered_mesh.obj']);
    raw_result = surface_measurement(V, gender, DATA_DIR);
    save([SAVE_DIR 'raw_result.mat'], 'raw_result');
    
    % Stage 3: Optimization (SVR Regression)
    disp('SVR Regression ...');
    %----------------------------------------------------------------------
    measurement_result = struct();
    
    if strcmp(gender, 'female')
        MODEL_DIR = [DATA_DIR 'regression_model/female/'];
        Ankle_Circ_Mdl        = load([MODEL_DIR 'Ankle_Circ_Mdl.mat']);
        Bicep_Circ_Mdl        = load([MODEL_DIR 'Bicep_Circ_Mdl.mat']);
        Bust_Circ_Mdl         = load([MODEL_DIR 'BUST_Circ_Mdl.mat']);
        Calf_Circ_Mdl         = load([MODEL_DIR 'Calf_Circ_Mdl.mat']);
        Elbow_Circ_Mdl        = load([MODEL_DIR 'Elbow_Circ_Mdl.mat']);
        HIP_Circ_Mdl          = load([MODEL_DIR 'HIP_Circ_Mdl.mat']);
        Knee_Circ_Mdl         = load([MODEL_DIR 'Knee_Circ_Mdl.mat']);
        NaturalWAIST_Circ_Mdl = load([MODEL_DIR 'NaturalWAIST_Circ_Mdl.mat']);
        NeckBase_Circ_Mdl     = load([MODEL_DIR 'NeckBase_Circ_Mdl.mat']);
        Neck_Circ_Mdl         = load([MODEL_DIR 'Neck_Circ_Mdl.mat']);
        Thigh_Circ_Mdl        = load([MODEL_DIR 'Thigh_Circ_Mdl.mat']);
        TrouserWAIST_Circ_Mdl = load([MODEL_DIR 'TrouserWAIST_Circ_Mdl.mat']);
        Underbust_Circ_Mdl    = load([MODEL_DIR 'Underbust_Circ_Mdl.mat']);
        Wrist_Circ_Mdl        = load([MODEL_DIR 'Wrist_Circ_Mdl.mat']);
        Bust_to_Bust_Mdl      = load([MODEL_DIR 'Bust_to_Bust_Mdl.mat']);
        NeckSide_to_Wrist_Mdl = load([MODEL_DIR 'NeckSide_to_Wrist_Mdl.mat']);
        S_to_S_Mdl            = load([MODEL_DIR 'Shoulder_to_Shoulder_Mdl.mat']);
        S_to_Wrist_Mdl        = load([MODEL_DIR 'Shoulder_to_Wrist_Mdl.mat']);
        SideNeck_to_Bust_Mdl  = load([MODEL_DIR 'SideNeck_to_Bust_Mdl.mat']);
        
        measurement_result.female_Ankle_Circ           = ...
                 predict(Ankle_Circ_Mdl.Mdl, [raw_result.female_Ankle_Circ{:}]);
        measurement_result.female_Bicep_Circ           = ...
                 predict(Bicep_Circ_Mdl.Mdl, [raw_result.female_Bicep_Circ{:}]);
        measurement_result.female_Bust_Circ            = ...
                 predict(Bust_Circ_Mdl.Mdl, [raw_result.female_Bust_Circ{:}]);
        measurement_result.female_Calf_Circ            = ...
                 predict(Calf_Circ_Mdl.Mdl, [raw_result.female_Calf_Circ{:}]);
        measurement_result.female_Elbow_Circ           = ...
                 predict(Elbow_Circ_Mdl.Mdl, [raw_result.female_Elbow_Circ{:}]);
        measurement_result.female_HIP_Circ             = ...
                 predict(HIP_Circ_Mdl.Mdl, [raw_result.female_HIP_Circ{:}]);
        measurement_result.female_Knee_Circ            = ...
                 predict(Knee_Circ_Mdl.Mdl, [raw_result.female_Knee_Circ{:}]);
        measurement_result.female_NaturalWAIST_Circ    = ...
                 predict(NaturalWAIST_Circ_Mdl.Mdl, [raw_result.female_NaturalWAIST_Circ{:}]);
        measurement_result.female_NeckBase_Circ        = ...
                 predict(NeckBase_Circ_Mdl.Mdl, [raw_result.female_NeckBase_Circ{:}]);
        measurement_result.female_Neck_Circ            = ...
                 predict(Neck_Circ_Mdl.Mdl, [raw_result.female_Neck_Circ{:}]);
        measurement_result.female_Thigh_Circ           = ...
                 predict(Thigh_Circ_Mdl.Mdl, [raw_result.female_Thigh_Circ{:}]);
        measurement_result.female_TrouserWAIST_Circ    = ...
                 predict(TrouserWAIST_Circ_Mdl.Mdl, [raw_result.female_TrouserWAIST_Circ{:}]);
        measurement_result.female_Underbust_Circ       = ...
                 predict(Underbust_Circ_Mdl.Mdl, [raw_result.female_Underbust_Circ{:}]);
        measurement_result.female_Wrist_Circ           = ...
                 predict(Wrist_Circ_Mdl.Mdl, [raw_result.female_Wrist_Circ{:}]);
        measurement_result.female_Bust_to_Bust         = ...
                 predict(Bust_to_Bust_Mdl.Mdl, [raw_result.female_Bust_to_Bust{:}]);
        measurement_result.female_NeckSide_to_Wrist    = ...
                 predict(NeckSide_to_Wrist_Mdl.Mdl, [raw_result.female_NeckSide_to_Wrist{:}]);
        measurement_result.female_Shoulder_to_Shoulder = ...
                 predict(S_to_S_Mdl.Mdl, [raw_result.female_Shoulder_to_Shoulder{:}]);
        measurement_result.female_Shoulder_to_Wrist    = ...
                 predict(S_to_Wrist_Mdl.Mdl, [raw_result.female_Shoulder_to_Wrist{:}]);
        measurement_result.female_SideNeck_to_Bust     = ...
                 predict(SideNeck_to_Bust_Mdl.Mdl, [raw_result.female_SideNeck_to_Bust{:}]);
        
    else
        MODEL_DIR = [DATA_DIR 'regression_model/male/'];
        Ankle_Circ_Mdl        = load([MODEL_DIR 'Ankle_Circ_Mdl.mat']);
        Bicep_Circ_Mdl        = load([MODEL_DIR 'Bicep_Circ_Mdl.mat']);
        CHEST_Circ_Mdl        = load([MODEL_DIR 'CHEST_Circ_Mdl.mat']);
        Calf_Circ_Mdl         = load([MODEL_DIR 'Calf_Circ_Mdl.mat']);
        Elbow_Circ_Mdl        = load([MODEL_DIR 'Elbow_Circ_Mdl.mat']);
        HIP_Circ_Mdl          = load([MODEL_DIR 'HIP_Circ_Mdl.mat']);
        Knee_Circ_Mdl         = load([MODEL_DIR 'Knee_Circ_Mdl.mat']);
        MAXWAIST_Circ_Mdl     = load([MODEL_DIR 'MaxWAIST_Circ_Mdl.mat']);
        NeckBase_Circ_Mdl     = load([MODEL_DIR 'NeckBase_Circ_Mdl.mat']);
        Neck_Circ_Mdl         = load([MODEL_DIR 'Neck_Circ_Mdl.mat']);
        Thigh_Circ_Mdl        = load([MODEL_DIR 'Thigh_Circ_Mdl.mat']);
        TrouserWAIST_Circ_Mdl = load([MODEL_DIR 'TrouserWAIST_Circ_Mdl.mat']);
        Wrist_Circ_Mdl        = load([MODEL_DIR 'Wrist_Circ_Mdl.mat']);
        S_to_S_Mdl            = load([MODEL_DIR 'Shoulder_to_Shoulder_Mdl.mat']);
        S_to_Wrist_Mdl        = load([MODEL_DIR 'Shoulder_to_Wrist_Mdl.mat']);
        
        measurement_result.male_Ankle_Circ           = ...
                 predict(Ankle_Circ_Mdl.Mdl, [raw_result.male_Ankle_Circ{:}]);
        measurement_result.male_Bicep_Circ           = ...
                 predict(Bicep_Circ_Mdl.Mdl, [raw_result.male_Bicep_Circ{:}]);
        measurement_result.male_CHEST_Circ            = ...
                 predict(CHEST_Circ_Mdl.Mdl, [raw_result.male_CHEST_Circ{:}]);
        measurement_result.male_Calf_Circ            = ...
                 predict(Calf_Circ_Mdl.Mdl, [raw_result.male_Calf_Circ{:}]);
        measurement_result.male_Elbow_Circ           = ...
                 predict(Elbow_Circ_Mdl.Mdl, [raw_result.male_Elbow_Circ{:}]);
        measurement_result.male_HIP_Circ             = ...
                 predict(HIP_Circ_Mdl.Mdl, [raw_result.male_HIP_Circ{:}]);
        measurement_result.male_Knee_Circ            = ...
                 predict(Knee_Circ_Mdl.Mdl, [raw_result.male_Knee_Circ{:}]);
        measurement_result.male_MaxWAIST_Circ    = ...
                 predict(MAXWAIST_Circ_Mdl.Mdl, [raw_result.male_MAXWAIST_Circ{:}]);
        measurement_result.male_NeckBase_Circ        = ...
                 predict(NeckBase_Circ_Mdl.Mdl, [raw_result.male_NeckBase_Circ{:}]);
        measurement_result.male_Neck_Circ            = ...
                 predict(Neck_Circ_Mdl.Mdl, [raw_result.male_Neck_Circ{:}]);
        measurement_result.male_Thigh_Circ           = ...
                 predict(Thigh_Circ_Mdl.Mdl, [raw_result.male_Thigh_Circ{:}]);
        measurement_result.male_TrouserWAIST_Circ    = ...
                 predict(TrouserWAIST_Circ_Mdl.Mdl, [raw_result.male_TrouserWAIST_Circ{:}]);
        measurement_result.male_Wrist_Circ           = ...
                 predict(Wrist_Circ_Mdl.Mdl, [raw_result.male_Wrist_Circ{:}]);
        measurement_result.male_Shoulder_to_Shoulder = ...
                 predict(S_to_S_Mdl.Mdl, [raw_result.male_Shoulder_to_Shoulder{:}]);
        measurement_result.male_Shoulder_to_Wrist    = ...
                 predict(S_to_Wrist_Mdl.Mdl, [raw_result.male_Shoulder_to_Wrist{:}]);
    end
   
    save([SAVE_DIR 'measurement_result.mat'], 'measurement_result');
    disp('Done ...');
end





