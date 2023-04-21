function [Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC] = STEP4_Encode(Y_Q, Cb_Q, Cr_Q)
    Y_DC = DC_vector(Y_Q);
    Y_AC = AC_vector(Y_Q);
    Cb_DC = DC_vector(Cb_Q);
    Cb_AC = AC_vector(Cb_Q);
    Cr_DC = DC_vector(Cr_Q);
    Cr_AC = AC_vector(Cr_Q);
end

function vector = DC_vector(F)

    [m, n] = size(F);
    DC_len = m * n / 64;
    vector = zeros(1, DC_len);
    
    index = 1;
    for i = 1:m/8
        for j = 1:n/8
            vector(index) = F((i - 1)*8 + 1, (j - 1)* 8 + 1);
            index = index + 1;
        end
    end
    
    vector = conv(vector, [0 1 -1], 'same');
end
function result = AC_vector(F)

    [m, n] = size(F);
    result = zeros(1, 2);

    ztb=[9,2,3:7:17,25:-7:4,5:7:33,41:-7:6,7:7:49,57:-7:8,16:7:58,...
        59:-7:24,32:7:60,61:-7:40,48:7:62,63,56,64];

    for i = 1:m/8
        for j = 1:n/8
            region = F((i-1)*8 + 1: i*8, (j-1)*8 + 1:j*8);
            vector = region(ztb);
            result = [result; zero_Run(vector)];
        end
    end
    result = result(2:end, :);
end
function result = zero_Run(vector)
    result = zeros(63, 2);
    index = 1;
    count = 0;
    
    for i = 1:63
        if vector(i) == 0
           count = count + 1;
        else
            result(index, :) = [count, vector(i)];
            index = index + 1;
            count = 0;
        end
    end
    
    result(index+1:end, :) = [];
end