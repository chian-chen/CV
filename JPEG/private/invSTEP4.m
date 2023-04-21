function [Y_Q, Cb_Q, Cr_Q] = invSTEP4(Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC)

    m = sqrt(length(Y_DC) * 64);

    Y_Q = Decode(Y_DC, Y_AC, m);
    Cb_Q = Decode(Cb_DC, Cb_AC, m / 2);
    Cr_Q = Decode(Cr_DC, Cr_AC, m / 2);
end



function Decode = Decode(DC, AC, m)
    Decode = zeros(m, m);
    
    DC_vector = zeros(1, length(DC));
    DC_vector(1) = DC(1);
    
    for i = 2: length(DC)
        DC_vector(i) = DC_vector(i-1) + DC(i);
    end

    DC_index = 1;
    start = 1;
    tail = 1;

    for i = 1:m/8
        for j = 1: m/8
            region = zeros(8, 8);
            region(1, 1) = DC_vector(DC_index);
            DC_index = DC_index + 1;

            while AC(tail, 1) ~= 0 || AC(tail, 2) ~= 0
                tail = tail + 1;
            end

            AC_Array = inv_zero_Run(AC(start: tail, :));
            tail = tail + 1;
            start = tail;

            Decode((i - 1)*8 + 1:i * 8, (j - 1)* 8 + 1: j * 8) = region + AC_Array;
        end
    end
end
function AC_Array = inv_zero_Run(ZeroRun)
    table = [9,2,3:7:17,25:-7:4,5:7:33,41:-7:6,7:7:49,57:-7:8,16:7:58,...
            59:-7:24,32:7:60,61:-7:40,48:7:62,63,56,64];
    
    vector = zeros(1, 63);
    index = 1;
    
    m = size(ZeroRun);
    for i = 1:m(1)
        zero_number = ZeroRun(i, 1);
        value = ZeroRun(i, 2);
        index = index + zero_number;
        vector(index) = value;
        index = index + 1;
    end
    
    AC_Array = zeros(8, 8);
    AC_Array(table) = vector;
    
end