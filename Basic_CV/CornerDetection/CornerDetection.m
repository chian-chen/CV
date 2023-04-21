% =======================================================
% This file implements Harris Corner Detector
% =======================================================
I = double(imread('../materials/Lenna.jpg'));
I = rgb2gray(I/255);

figure, imshow(I);

% =======================================================
% X, Y
X = conv2(I, [-1, 0, 1], 'same');
Y = conv2(I, [-1, 0, 1]' , 'same');
[m, n] = size(I);
% =======================================================
% w use built-in function 
% ref : https://es.mathworks.com/help/images/ref/fspecial.html
w = fspecial('gaussian', [7 7], 4);
w = w .* 2 .* pi .* 16;
% =======================================================
% A, B
A = conv2(X.^2, w, 'same');
B = conv2(Y.^2, w, 'same');
C = conv2(X.*Y, w, 'same');
% =======================================================
% R
k = 0.04;
R = A .* B - C.^2 - k * (A + B).^2;
threshold = max(max(R))/100;
% =======================================================
% corner
corner = zeros(m, n);
% ignore the edge of image
for i = 2 : m - 1
    for j = 2 : n - 1
        Region = R(i - 1:i + 1, j - 1:j + 1);
        local_max = max(max(Region));
        if R(i, j) > threshold && R(i, j) == local_max
            corner(i, j) = 1;
        end
    end
end
% =======================================================
% Dilation 3 times to make it clear

corner = Dilation(Dilation(Dilation(corner)));
figure, imshow(corner);
% =======================================================
% result

figure, imshow(I + corner);
% =======================================================

function B = Dilation(M)
    M_new = M;
    [row,col] = size(M);
    for i = 2:row - 1
        for j =2:col - 1
            M_new(i, j) = max([M(i, j), M(i + 1, j), M(i - 1, j), M(i, j + 1), M(i, j - 1)]);
        end
    end
    B = M_new;
end

