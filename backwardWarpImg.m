function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
% This function warps an image based on a homography
w = dest_canvas_width_height(1);
h = dest_canvas_width_height(2);

% create mask and result tmp
mask = zeros(h, w);
result_img = zeros(h, w, 3);

for i = 1 : h
    for j = 1 : w
        d = resultToSrc_H * [j; i; 1];
        x = round(d(1) / d(3)); y = round(d(2) / d(3));
        if (x >= 1 && x <= size(src_img, 2) && y >= 1 && y <= size(src_img, 1))
            result_img(i, j, :) = src_img(y, x, :);
            mask(i, j) = 1;
        end
    end
end
