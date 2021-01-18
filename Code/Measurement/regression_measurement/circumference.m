% return circumference in cm
function circ = circumference(circle_vertices)
    circ = 0;
    if size(circle_vertices, 1) > 1
        for ii = 1:size(circle_vertices, 1) - 1
            v0 = circle_vertices(ii, :);
            v1 = circle_vertices(ii+1, :);
            circ = circ + sqrt((v0(1) - v1(1))^2 + (v0(2) - v1(2))^2 + (v0(3) - v1(3))^2 );
        end
        v_first = circle_vertices(1, :);
        v_last = circle_vertices(end, :);
        circ = circ + sqrt((v_first(1) - v_last(1))^2 + (v_first(2) - v_last(2))^2 + (v_first(3) - v_last(3))^2 );
    end
    circ = circ * 100;
end