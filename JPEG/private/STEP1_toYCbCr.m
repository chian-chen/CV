function [Y, Cb, Cr] = STEP1_toYCbCr(Im)
    % 4:2:0, RGB to YCbCr
    % Input: RGB img( m x n x 3 )
    % Output: Y, Cb, Cr(Cb and Cr + 127.5 offset)
    % m, n are even number
    
    R = Im(:, :, 1);
    G = Im(:, :, 2);
    B = Im(:, :, 3);
    
    % Trans RGB to YCbCr
    T = [0.299 0.587 0.114;
        -0.169 -0.331 0.500;
        0.500 -0.419 -0.081];
    
    Y =  T(1,1) * R + T(1,2) * G + T(1,3) * B;
    Cb = T(2,1) * R + T(2,2) * G + T(2,3) * B;
    Cr = T(3,1) * R + T(3,2) * G + T(3,3) * B;

    % down sampling for Cb and Cr
    Cb = transpose(downsample(transpose(downsample(Cb, 2)),2)) + 127.5;
    Cr = transpose(downsample(transpose(downsample(Cr, 2)),2)) + 127.5;

end
