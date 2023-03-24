function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
% This function get the homography 
Matr = zeros(9, 9);
n = size(src_pts_nx2, 1);

for i = 1 : n
    snx2_1 = src_pts_nx2(i, 1);
    snx2_2 = src_pts_nx2(i, 2);
    dnx2_1 = dest_pts_nx2(i, 1);
    dnx2_2 = dest_pts_nx2(i, 2);

    Matr(2*i-1, :) = [snx2_1, snx2_2, 1, 0, 0, 0, -dnx2_1 * snx2_1, -dnx2_1 * snx2_2, -dnx2_1];
    Matr(2*i, :) = [0, 0, 0, snx2_1, snx2_2, 1, -dnx2_2* snx2_1, -dnx2_2 * snx2_2, -dnx2_2];
end

[h, T] = eig(Matr' * Matr);
H_3x3 = reshape(h(:, 1), 3, 3)';