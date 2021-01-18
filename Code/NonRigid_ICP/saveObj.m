% To save .obj file
% 2018.01.19, Song Yan
%
% input:  file_path, vertices, faces, colorV = None
% 
function saveObj(out_path, vertices, faces, colorVertices)

    if nargin == 3
        colorV = zeros(0,3);
    elseif nargin == 4
        colorV = colorVertices;
    end
    
    fid = fopen(out_path, 'w');
    for v_id = 1:length(vertices)
        v = vertices(v_id, :);
        if find(ismember(colorV, v, 'rows'))
            fprintf(fid, 'v %f %f %f 255 0 0\n', v);
        else
            fprintf(fid, 'v %f %f %f\n', v);
        end
        
    end
    for f_id = 1:length(faces)
        fprintf(fid, 'f %d %d %d\n', faces(f_id, :));
    end
    fclose(fid);
end
