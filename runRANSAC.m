function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
% This function computes homography using RANSAC
maxFitNum = 0;

for iter = 1 : ransac_n
    n = size(Xs, 1);
    p_all = randperm(n);
    p = p_all(1 : 4);
    H_curr = computeHomography(Xs(p, :), Xd(p, :));
    Xdiff = (applyHomography(H_curr, Xs) - Xd) .^ 2;
    Xdist = sqrt(Xdiff(:, 1) + Xdiff(:, 2));
    fitNum = sum(Xdist < eps);
    if (fitNum > maxFitNum)
        maxFitNum = fitNum;
        H = H_curr;
        inliers_id = find(Xdist < eps);
    end
end