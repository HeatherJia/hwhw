function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
% This function warps an image based on a homography
width = dest_canvas_width_height(1);
height = dest_canvas_width_height(2);
x_bnd = size(src_img, 2);
y_bnd = size(src_img, 1);

% create mask and result tmp
mask = zeros(height, width);
result_img = zeros(height, width, 3);

for i = 1 : width
    for j = 1 : height
        p = resultToSrc_H * [j; i; 1];
        x = round(p(1) / p(3)); y = round(p(2) / p(3));
        if (x >= 1 && x <= x_bnd && y >= 1 && y <= y_bnd)
            result_img(i, j, :) = src_img(y, x, :); mask(i, j) = 1;
        end
    end
end