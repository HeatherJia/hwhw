function stitched_img = stitchImg(varargin)
% This function stitches the input images into one mosaic
ransac_n = 50; ransac_eps = 5;
img = varargin{1};
ori_h = size(img, 1); ori_w = size(img, 2);
mask1 = ones(ori_h, ori_w);

for i = 2 : nargin
    [ori_h, ori_w, c] = size(img);
    [xs, xd] = genSIFTMatches(varargin{i}, img, "MATLAB");
    [tmp, H] = runRANSAC(xs, xd, ransac_n, ransac_eps);
    h = size(varargin{i}, 1); w = size(varargin{i}, 2);
    orig = [1, 1; w, 1; 1, h; w, h];
    dest = applyHomography(H, orig);

    left = min(dest(:, 1)); right = max(dest(:, 1));
    top = min(dest(:, 2)); bottom = max(dest(:, 2));

    if left < 1
        tmp_zeros1 = zeros(ori_h, round(1 - left), c);
        img = [tmp_zeros1, img];
        tmp_zeros2 = zeros(ori_h, round(1 - left));
        mask1 = [tmp_zeros2, mask1];
        dest(:, 1) = dest(:, 1) + round(1 - left);
    end
    if right > ori_w
        tmp_zeros1 = zeros(ori_h, round(right - ori_w), c);
        img = [img, tmp_zeros1];
        tmp_zeros2 = zeros(ori_h, round(right - ori_w));
        mask1 = [mask1, tmp_zeros2];
    end

    width2 = size(img, 2);
    if top < 1
        tmp_zeros1 = zeros(round(1 - top), width2, c);
        img = [tmp_zeros1; img];
        mask1 = [zeros(round(1 - top), width2); mask1];
        dest(:, 2) = dest(:, 2) + round(1 - top);
    end
    if bottom > ori_h
        tmp_zeros1 = zeros(round(bottom - ori_h), width2, c);
        img = [img; tmp_zeros1];
        mask1 = [mask1; zeros(round(bottom - ori_h), width2)];
    end

    [mask, nimg] = backwardWarpImg(varargin{i}, inv(computeHomography(orig, dest)), [width2, size(img, 1)]);
    img = blendImagePair(uint8(nimg * 255), mask, uint8(img * 255), mask1, 'blend');
    img = double(img) / 255; mask1 = double(mask > 0 | mask1 > 0);
end
stitched_img = img;
