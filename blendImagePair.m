function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
% blend two images into one
if strcmp(mode, 'overlay')
    masks = masks ./ 255;
    maskd = maskd ./ 255;
    out_img = wrapped_imgs .* repmat(masks, 1, 1, 3) .* (repmat(1 - maskd, 1, 1, 3)) + wrapped_imgd .* repmat(maskd, 1, 1, 3);
elseif strcmp(mode, 'blend')
    masks = double(masks > 0);
    maskd = double(maskd > 0);
    dist_s = bwdist(masks .* (1 - maskd)) .* masks;
    dist_d = bwdist(maskd .* (1 - masks)) .* maskd;
    relas = dist_s ./ (dist_s + dist_d); relas(isnan(relas)) = 0;
    relad = dist_d ./ (dist_s + dist_d); relad(isnan(relad)) = 0;
    out_img = uint8(double(wrapped_imgs) .* repmat((1 - relas) .* masks, 1, 1, 3) + double(wrapped_imgd) .* repmat((1 - relad) .* maskd, 1, 1, 3));
else
    error('Please pick from overlay or blend.');
end