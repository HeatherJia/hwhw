function stitched_img = stitchImg(varargin)
% Stitch input images into one mosaic

% get the first image
cur = varargin{1};
height = size(cur, 1);
width = size(cur, 2);
cur_mask = ones(height, width);

% iterate through the images
for i = 2 : nargin
    % get the homography (with RANSAC)
    [height, width, channel] = size(cur);
    impl = 'MATLAB';
    [xs, xd] = genSIFTMatches(varargin{i}, cur, impl);
    ransac_n = 100;
    ransac_eps = 10;
    [inliers_id, H] = runRANSAC(xs, xd, ransac_n, ransac_eps);

    h = size(varargin{i}, 1);
    w = size(varargin{i}, 2);
    orig = [1, 1; w, 1; 1, h; w, h];
    dest = applyHomography(H, orig);
    
    % define the boundaries
    left = min(dest(:, 1));
    right = max(dest(:, 2));
    top = min(dest(:, 2));
    bottom = max(dest(:, 2));

    if left < 1
        cur = [zeros(height, round(1-left), channel), cur];
        cur_mask = [zeros(height, round(1-left)), cur_mask];
        dest(:, 1) = dest(:, 1) + round(1-left);
    end 

    if right > width
        cur = [cur, zeros(height, round(right - width), channel)];
        cur_mask = [cur_mask, zeros(height, round(right-width))];
    end 
    
    width = size(cur, 2); % update width
    if top < 1
        cur = [zeros(round(1-top), width, channel); cur];
        cur_mask = [zeros(round(1-top), width); cur_mask];
        dest(:, 2) = dest(:, 2) + round(1-top);
    end 

    if bottom > height
        cur = [cur; zeros(round(bottom-height), width, channel)];
        cur_mask = [cur_mask; zeros(round(bottom-height), width)];
    end 

    height = size(cur, 1); % update height
    dest_canvas_width_height = [width, height];
    HH = computeHomography(orig, dest);
    [mask, dest_img] = backwardWarpImg(varargin{i}, inv(HH), dest_canvas_width_height);
    cur = blendImagePair(uint8(dest_img*255), mask, uint8(cur*255), cur_mask, 'blend');
    cur = double(cur) / 255;
    cur_mask = double(mask > 0 | cur_mask > 0);
end

stitched_img = cur;