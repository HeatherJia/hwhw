function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
% This function transforms source image points
n = size(src_pts_nx2, 1);
dest_pts_nx2 = zeros(n, 2);

for i = 1 : n
    p = H_3x3*[src_pts_nx2(i, :), 1]';
    dest_pts_nx2(i, :) = [round(p(1) / p(3)), round(p(2) / p(3))];
end