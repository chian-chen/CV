function [Y_DCT, Cb_DCT, Cr_DCT] = STEP2_DCT(Y, Cb, Cr)
    % 8 x 8 DCT, assume X is a 2D matrix with size m x n,
    % m and n are both divisible by 8
    
    Y_DCT = DCT(Y);
    Cb_DCT = DCT(Cb);
    Cr_DCT = DCT(Cr);
end

function F = DCT(X)
    [m, n] = size(X);
    F = zeros(m, n);

    U = cos(pi*(0:7)'*(0.5:7.5)/8)/2;
    U(1, :)= U(1,:) / 2^.5;
    V = U.';
    
    for i = 1:m/8
        for j = 1:n/8
            F((i - 1) * 8 + 1: i*8, (j - 1) * 8 + 1:j*8) = U * X((i - 1) * 8 + 1: i*8, (j - 1) * 8 + 1:j*8) * V;
        end
    end
end