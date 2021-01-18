function len = line_length(vertices)
    len = 0;
    if size(vertices, 1) > 1
        for ii = 1:size(vertices, 1) - 1
            v0 = vertices(ii, :);
            v1 = vertices(ii+1, :);
            len = len + sqrt((v0(1) - v1(1))^2 + (v0(2) - v1(2))^2 + (v0(3) - v1(3))^2 );
        end
    end
    len = len * 100; % cm
end