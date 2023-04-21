% =======================================================
% This file use different filter to show the edge of the img.
% Use Lenna as example, and plot the normalized result to 
% see the difference by different filters.
% =======================================================


im = double(imread('./materials/Lenna.jpg'));
im = rgb2gray(im/255);
% Gray = 0.2989 * R + 0.5870 * G + 0.1140 * B


% =======================================================
% Difference(horizontal axis)
imD_H = conv2(im, [0 0 0; -1 1 0; 0 0 0], 'same');

figure, image(abs(imD_H)/max(max(abs(imD_H)))*510);
colormap(gray(256))
% =======================================================
% Difference(vertical axis)
imD_V = conv2(im, [0 -1 0; 0 1 0; 0 0 0], 'same');

figure, image(abs(imD_V)/max(max(abs(imD_V)))*510);
colormap(gray(256))
% =======================================================
% Sobel Operator(horizontal axis)
imS_H = conv2(im, [1 0 -1; 2 0 -2; 1 0 -1]/4, 'same');

figure, image(abs(imS_H)/max(max(abs(imS_H)))*510);
colormap(gray(256))
% =======================================================
% Sobel Operator(vertical axis)
imS_V = conv2(im, [1 2 1; 0 0 0; -1 -2 -1]/4, 'same');

figure, image(abs(imS_V)/max(max(abs(imS_V)))*510);
colormap(gray(256))
% =======================================================
% Sobel Operator(theta = 45)
imS_45 = conv2(im, [0 -1 -2; 1 0 -1; 2 1 0]/4, 'same');

figure, image(abs(imS_45)/max(max(abs(imS_45)))*510);
colormap(gray(256))
% =======================================================
% Sobel Operator(theta = 135)
imS_135 = conv2(im, [-2 -1 0; -1 0 1; 0 1 2]/4, 'same');

figure, image(abs(imS_135)/max(max(abs(imS_135)))*510);
colormap(gray(256))
% =======================================================
% Laplacian Operator
imL = conv2(im, [-1 -1 -1; -1 8 -1; -1 -1 -1]/8, 'same');

figure, image(abs(imL)/max(max(abs(imL)))*510);
colormap(gray(256))
% =======================================================