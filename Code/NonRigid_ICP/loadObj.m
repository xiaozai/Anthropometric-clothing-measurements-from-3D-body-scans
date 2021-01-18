% To load .obj file
% 2018.01.19, Song Yan
%
% input : file_path
% output: vertices, faces

function [vertices, faces] = loadObj(mesh_file)
    vertices = [];
    faces = [];
    
    fid = fopen(mesh_file, 'r');
    while ~feof(fid)
        line = fgetl(fid);
        C = strsplit(line);
        
        if C{1} == 'v'
            x = str2double(C{2});
            y = str2double(C{3});
            z = str2double(C{4});
            vertices = [vertices; [x, y, z]];
            
        elseif C{1} == 'f'
            v1 = str2double(C{2});
            v2 = str2double(C{3});
            v3 = str2double(C{4});
            
            faces = [faces; [v1, v2, v3]];
        end
    end
    fclose(fid);
end