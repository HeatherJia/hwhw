function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
% This function connects the corresponding points by lines
dest_pts_nx2(:, 1) = dest_pts_nx2(:, 1) + size(orig_img, 2);
fh = figure();
imshow([orig_img, warped_img]);
hold on;
n = size(src_pts_nx2, 1);

for i = 1 : n
    snx2_1 = src_pts_nx2(i, 1);
    dnx2_1 = dest_pts_nx2(i, 1);
    line1 = [snx2_1; dnx2_1];
    line2 = [src_pts_nx2(i, 2); dest_pts_nx2(i, 2)];
    line(line1, line2, 'LineWidth', 3, 'Color', 'r');
end
result_img = saveAnnotatedImg(fh);

function annotated_img = saveAnnotatedImg(fh)
figure(fh); 

% Set figure configs
set(fh, 'WindowStyle', 'normal');

% process the displayed figure 
image = getimage(fh);
truesize(fh, [size(image, 1), size(image, 2)]); 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
annotated_img = frame.cdata;