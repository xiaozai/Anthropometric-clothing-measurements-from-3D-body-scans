% Non Rigid ICP Registration Process
% 2018.01.19, Song Yan

clear; close all; clc;
%--------------------------------------------------------------------------
Options.gamm = 1;
Options.epsilon = 1e-3;
Options.maxIter = 100;
Options.alphaSet = linspace(100, 1, 100);

data_folder = '/home/yan/Data2/NOMO_Project_P1/data/';
out_folder = '/home/yan/Desktop/';

%--------------------------------------------------------------------------
% use the same initial template
source_obj = [data_folder 'smpl_mesh/init_template_male.obj'];
[source.vertices, source.faces] = loadObj(source_obj);
source.vertices = source.vertices - mean(source.vertices);

for idx = 0:0
%     obj_name = targetList(idx).name;
    obj_name = sprintf('male_%04d.obj', idx);
    target_obj = ['/home/yan/Data2/CVPR2019/Dataset/NOMO_Dataset/NOMO3D_Dataset2/male/' obj_name];
    out_mesh = [out_folder obj_name];
    
    [target.vertices, target.faces] = loadObj(target_obj);
    target.vertices = target.vertices - mean(target.vertices);
    
    NonRigid_ICP(source, target, out_mesh, Options);
end



