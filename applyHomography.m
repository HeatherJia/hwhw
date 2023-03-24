function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
% This function transforms the source image
dimsize = size(src_pts_nx2, 1);
dest_pts_nx2 = zeros(dimsize, 2);
for i = 1 : dimsize
    a = src_pts_nx2(i, :);
    s = [a, 1];
    d = H_3x3 * s';
    x = d(1) / d(3); y = d(2) / d(3);
    dest_pts_nx2(i, :) = [round(x), round(y)];
end
