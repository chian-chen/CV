function [Y, Cb, Cr] = invSTEP2(Y_DCT, Cb_DCT, Cr_DCT)
    Y = invDCT(Y_DCT);
    Cb = invDCT(Cb_DCT);
    Cr = invDCT(Cr_DCT);
end

function f = invDCT(F)

    [m, n] = size(F);
    f = zeros(m, n);

    U = cos(pi*(0:7)'*(0.5:7.5)/8)/2;
    U(1, :)= U(1,:) / 2^.5;
    V = U.';
    
    for i = 1:m/8
        for j = 1:n/8
            f((i - 1) * 8 + 1: i*8, (j - 1) * 8 + 1:j*8) = V * F((i - 1) * 8 + 1: i*8, (j - 1) * 8 + 1:j*8) * U;
        end
    end

end