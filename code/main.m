clear; clc;
O = imread('lenna_gray.png'); Type = 'original';
O = double(O) / 255;
noise_sigma = 0.08;
if (strcmp(Type, 'noise') == 1)
    I = O;
elseif (strcmp(Type, 'original') == 1)
    %I = imgaussfilt(O,0.25);
    %I = imnoise(O, 'gaussian', 5);
    I = O + randn(size(O)) * noise_sigma;
else
    error('No such choice for Type');
end

iter = [5,6,7];
jmp = 30/255;
dist = 2;
w = 'constant';
sigma = 10;

II = Mean_Curvature_Equation(I, iter(1), jmp, dist, w, sigma);
III = Mean_Curvature_Equation(I, iter(2), jmp, dist, w, sigma);
IV = Mean_Curvature_Equation(I, iter(3), jmp, dist, w, sigma);

figure(1)
subplot(231); imshow(I); title(strcat('noise image, psnr: ', num2str(psnr(I, O)), ', sigma: ', num2str(noise_sigma)));
subplot(232); imshow(O); title(strcat('original image'));
subplot(234); imshow(II); title(strcat('After ', num2str(iter(1)), ' iteration, psnr: ', num2str(psnr(II, O))));
subplot(235); imshow(III); title(strcat('After ', num2str(iter(2)), ' iteration, psnr: ', num2str(psnr(III, O))));
subplot(236); imshow(IV); title(strcat('After ', num2str(iter(3)), ' iteration, psnr: ',num2str(psnr(IV, O))));

fprintf('The range of original image : [%d, %d]\n', min(I(:)), max(I(:)));
fprintf('The range of image after %d iteration : [%d, %d]\n', iter(1), min(II(:)), max(II(:)));
fprintf('The range of image after %d iteration : [%d, %d]\n', iter(2), min(III(:)), max(III(:)));
fprintf('The range of image after %d iteration : [%d, %d]\n', iter(3), min(IV(:)), max(IV(:)));