% Non Rigid ICP Registration Process
% 2018.01.19, Song Yan

clear; close all; clc;
%--------------------------------------------------------------------------
Options.gamm = 1;
Options.epsilon = 1e-4;
Options.maxIter = 100;
Options.alphaSet = linspace(100, 1, 100);

data_folder = '/home/yan/Data2/BodyMeasure/Experiments/data/female/';
out_folder = '/home/yan/Data2/BodyMeasure/Experiments/data/female_nonrigidICP/';


source_obj = '/home/yan/Data2/NOMO_Project_P1/data/smpl_mesh/init_template_female.obj';
[source.vertices, source.faces] = loadObj(source_obj);

targetList = dir([data_folder '*.obj']);
targetNum = size(targetList, 1);

for idx = 1:length(targetList)
    obj_name = targetList(idx).name;
    target_obj = [data_folder obj_name];
    out_mesh = [out_folder obj_name];
    
    [target.vertices, target.faces] = loadObj(target_obj);
    NonRigid_ICP(source, target, out_mesh, Options);
end



