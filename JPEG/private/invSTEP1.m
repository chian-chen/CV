function x = invSTEP1(Y, Cb, Cr)

    T = [0.299 0.587 0.114;
        -0.169 -0.331 0.500;
        0.500 -0.419 -0.081];
    T = inv(T);
    
    window = [1/8 3/8 3/8 1/8];
    [m, n] = size(Cb);
    
    Cb_new = zeros(m, 2*n);
    Cr_new = zeros(m, 2*n);
    
    Cb_even = conv2(Cb, window, 'same');
    Cb_even(:, 1) = Cb_even(:, 1) * 8 / 7;
    Cb_even(:, end) = Cb_even(:, end) * 2;
    Cb_even(:, end - 1) = Cb_even(:, end-1) * 8 / 7;
    
    Cr_even = conv2(Cr, window, 'same');
    Cr_even(:, 1) = Cr_even(:, 1) * 8 / 7;
    Cr_even(:, end) = Cr_even(:, end) * 2;
    Cr_even(:, end - 1) = Cr_even(:, end-1) * 8 / 7;
    
    for i = 1:n
        Cb_new(:, i*2-1) = Cb(:, i);
        Cb_new(:, i*2) = Cb_even(:, i);
        Cr_new(:, i*2-1) = Cr(:, i);
        Cr_new(:, i*2) = Cr_even(:, i);
    end
    
    Cb_even = conv2(Cb_new, transpose(window), 'same');
    Cb_even(1, :) = Cb_even(1, :) * 8 / 7;
    Cb_even(end, :) = Cb_even(end, :) * 2;
    Cb_even(end - 1, :) = Cb_even(end-1, :) * 8 / 7;
    
    Cr_even = conv2(Cr_new, transpose(window), 'same');
    Cr_even(1, :) = Cr_even(1, :) * 8 / 7;
    Cr_even(end, :) = Cr_even(end, :) * 2;
    Cr_even(end - 1, :) = Cr_even(end-1, :) * 8 / 7;
    
    Cb = zeros(2*m, 2*n);
    Cr = zeros(2*m, 2*n);
    for i = 1:n
        Cb(i * 2 - 1, :) = Cb_new(i, :);
        Cb(i * 2, :) = Cb_even(i, :);
        Cr(i * 2 - 1, :) = Cr_new(i, :);
        Cr(i * 2, :) = Cr_even(i, :);
    end
    
    % offset
    Cb = Cb - 127.5;
    Cr = Cr - 127.5;
    
    R = T(1,1)*Y + T(1,2)*Cb + T(1,3)*Cr;
    G = T(2,1)*Y + T(2,2)*Cb + T(2,3)*Cr;
    B = T(3,1)*Y + T(3,2)*Cb + T(3,3)*Cr;
    x = cat(3,R,G,B);
end