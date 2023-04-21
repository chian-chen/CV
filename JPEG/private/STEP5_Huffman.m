function [YDC_Str, YAC_Str, CbDC_Str, CbAC_Str, CrDC_Str, CrAC_Str] = ...
    STEP5_Huffman(Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC)

    YDC_Str = '';
    for i = 1:length(Y_DC)
        YDC_Str = strcat(YDC_Str, YDC(Y_DC(i)));
    end

    YAC_Str = '';
    for i = 1:length(Y_AC)
        YAC_Str = strcat(YAC_Str, YAC(Y_AC(i, 1), Y_AC(i, 2)));
    end

    CbDC_Str = '';
    for i = 1:length(Cb_DC)
        CbDC_Str = strcat(CbDC_Str, CDC(Cb_DC(i)));
    end

    CbAC_Str = '';
    for i = 1:length(Cb_AC)
        CbAC_Str = strcat(CbAC_Str, CAC(Cb_AC(i, 1), Cb_AC(i, 2)));
    end

    CrDC_Str = '';
    for i = 1:length(Cr_DC)
        CrDC_Str = strcat(CrDC_Str, CDC(Cr_DC(i)));
    end
    
    CrAC_Str = '';
    for i = 1:length(Cr_AC)
        CrAC_Str = strcat(CrAC_Str, CAC(Cr_AC(i, 1), Cr_AC(i, 2)));
    end
end


function bitstream = YDC(k)
    bitstream = '';

    TDY={
        '00'
        '010'
        '011'
        '100'
        '101'
        '110'
        '1110'
        '11110'
        '111110'
        '1111110'
        '11111110'
        '111111110'};
    
    if k == 0
        bitstream = '00';
        return;
    end

    lower_bound = 2.^(0:1:10);
    upper_bound = 2.^(1:1:11) - 1;
    

    Group_Num = 1;
    while abs(k) > upper_bound(Group_Num)
        Group_Num = Group_Num + 1;
    end
    
    bitstream = strcat(bitstream, TDY{Group_Num + 1});
    if k > 0
        bitstream = strcat(bitstream, '1');
    else
        bitstream = strcat(bitstream, '0');
    end
    
    if abs(k) - lower_bound(Group_Num) == 0
        for i = 1: Group_Num - 1
            bitstream = strcat(bitstream, '0');    
        end
        return;
    end

    bits = int2bit(abs(k) - lower_bound(Group_Num), Group_Num - 1);
    bits_string = string(bits);
    bits_string = strjoin(bits_string, '');
    bitstream = strcat(bitstream, bits_string);    
end
function bitstream = YAC(a, b)
    if a == 0 && b == 0
        bitstream = '1010';
        return;
    end
    if a > 15
        bitstream = strcat('11111111001', YAC(a - 16, b));
        return;
    end

    TAY={ 
    % '1010';
    '00';
    '01';
    '100';
    '1011';
    '11010';
    '1111000';
    '11111000';
    '1111110110';
    '1111111110000010';
    '1111111110000011';
    '1100';
    '11011';
    '1111001';
    '111110110';
    '11111110110';
    '1111111110000100';
    '1111111110000101';
    '1111111110000110';
    '1111111110000111';
    '1111111110001000';
    '11100';
    '11111001';
    '1111110111';
    '111111110100';
    '1111111110001001';
    '1111111110001010';
    '1111111110001011';
    '1111111110001100';
    '1111111110001101';
    '1111111110001110';
    '111010';
    '111110111';
    '111111110101';
    '1111111110001111';
    '1111111110010000';
    '1111111110010001';
    '1111111110010010';
    '1111111110010011';
    '1111111110010100';
    '1111111110010101';
    '111011';
    '1111111000';
    '1111111110010110';
    '1111111110010111';
    '1111111110011000';
    '1111111110011001';
    '1111111110011010';
    '1111111110011011';
    '1111111110011100';
    '1111111110011101';
    '1111010';
    '11111110111';
    '1111111110011110';
    '1111111110011111';
    '1111111110100000';
    '1111111110100001';
    '1111111110100010';
    '1111111110100011';
    '1111111110100100';
    '1111111110100101';
    '1111011';
    '111111110110';
    '1111111110100110';
    '1111111110100111';
    '1111111110101000';
    '1111111110101001';
    '1111111110101010';
    '1111111110101011';
    '1111111110101100';
    '1111111110101101';
    '11111010';
    '111111110111';
    '1111111110101110';
    '1111111110101111';
    '1111111110110000';
    '1111111110110001';
    '1111111110110010';
    '1111111110110011';
    '1111111110110100';
    '1111111110110101';
    '111111000';
    '111111111000000';
    '1111111110110110';
    '1111111110110111';
    '1111111110111000';
    '1111111110111001';
    '1111111110111010';
    '1111111110111011';
    '1111111110111100';
    '1111111110111101';
    '111111001';
    '1111111110111110';
    '1111111110111111';
    '1111111111000000';
    '1111111111000001';
    '1111111111000010';
    '1111111111000011';
    '1111111111000100';
    '1111111111000101';
    '1111111111000110';
    '111111010';
    '1111111111000111';
    '1111111111001000';
    '1111111111001001';
    '1111111111001010';
    '1111111111001011';
    '1111111111001100';
    '1111111111001101';
    '1111111111001110';
    '1111111111001111';
    '1111111001';
    '1111111111010000';
    '1111111111010001';
    '1111111111010010';
    '1111111111010011';
    '1111111111010100';
    '1111111111010101';
    '1111111111010110';
    '1111111111010111';
    '1111111111011000';
    '1111111010';
    '1111111111011001';
    '1111111111011010';
    '1111111111011011';
    '1111111111011100';
    '1111111111011101';
    '1111111111011110';
    '1111111111011111';
    '1111111111100000';
    '1111111111100001';
    '11111111000';
    '1111111111100010';
    '1111111111100011';
    '1111111111100100';
    '1111111111100101';
    '1111111111100110';
    '1111111111100111';
    '1111111111101000';
    '1111111111101001';
    '1111111111101010';
    '1111111111101011';
    '1111111111101100';
    '1111111111101101';
    '1111111111101110';
    '1111111111101111';
    '1111111111110000';
    '1111111111110001';
    '1111111111110010';
    '1111111111110011';
    '1111111111110100';
    % '11111111001';
    '1111111111110101';
    '1111111111110110';
    '1111111111110111';
    '1111111111111000';
    '1111111111111001';
    '1111111111111010';
    '1111111111111011';
    '1111111111111100';
    '1111111111111101';
    '1111111111111110'};

    bitstream = '';
    lower_bound = 2.^(0:1:10);
    upper_bound = 2.^(1:1:11) - 1;
    
    Group_Num = 1;
    while abs(b) > upper_bound(Group_Num)
        Group_Num = Group_Num + 1;
    end
    bitstream = strcat(bitstream, TAY{a*10 + Group_Num});
    
    if b > 0
        bitstream = strcat(bitstream, '1');
    else
        bitstream = strcat(bitstream, '0');
    end
        
    if abs(b) - lower_bound(Group_Num) == 0
        for i = 1: Group_Num - 1
            bitstream = strcat(bitstream, '0');    
        end
    else
        bits = int2bit(abs(b) - lower_bound(Group_Num), Group_Num - 1);
        bits_string = string(bits);
        bits_string = strjoin(bits_string, '');
        bitstream = strcat(bitstream, bits_string);   
    end

end
function bitstream = CDC(k)
    bitstream = '';
    TDC={
        '00'
        '01'
        '10'
        '110'
        '1110'
        '11110'
        '111110'
        '1111110'
        '11111110'
        '111111110'
        '1111111110'
        '11111111110'};

    lower_bound = 2.^(0:1:10);
    upper_bound = 2.^(1:1:11) - 1;

    if k == 0
        bitstream = '00';
        return;
    end

    Group_Num = 1;
    while abs(k) > upper_bound(Group_Num)
        Group_Num = Group_Num + 1;
    end
    
    bitstream = strcat(bitstream, TDC{Group_Num + 1});
    
    if k > 0
        bitstream = strcat(bitstream, '1');
    else
        bitstream = strcat(bitstream, '0');
    end
    
    if abs(k) - lower_bound(Group_Num) == 0
        for i = 1: Group_Num - 1
            bitstream = strcat(bitstream, '0');    
        end
        return;
    end

    bits = int2bit(abs(k) - lower_bound(Group_Num), Group_Num - 1);
    bits_string = string(bits);
    bits_string = strjoin(bits_string, '');
    bitstream = strcat(bitstream, bits_string);    
end
function bitstream = CAC(a, b)
    if a == 0 && b == 0
        bitstream = '00';
        return;
    end
    if a > 15
        bitstream = strcat('1111111010', CAC(a - 16, b));
        return;
    end

    TAC={ 
    % '00';
    '01';
    '100';
    '1010';
    '11000';
    '11001';
    '111000';
    '1111000';
    '111110100';
    '1111110110';
    '111111110100';
    '1011';
    '111001';
    '11110110';
    '111110101';
    '11111110110';
    '111111110101';
    '1111111110001000';
    '1111111110001001';
    '1111111110001010';
    '1111111110001011';
    '11010';
    '11110111';
    '1111110111';
    '111111110110';
    '111111111000010';
    '1111111110001100';
    '1111111110001101';
    '1111111110001110';
    '1111111110001111';
    '1111111110010000';
    '11011';
    '11111000';
    '1111111000';
    '111111110111';
    '1111111110010001';
    '1111111110010010';
    '1111111110010011';
    '1111111110010100';
    '1111111110010101';
    '1111111110010110';
    '111010';
    '111110110';
    '1111111110010111';
    '1111111110011000';
    '1111111110011001';
    '1111111110011010';
    '1111111110011011';
    '1111111110011100';
    '1111111110011101';
    '1111111110011110';
    '111011';
    '1111111001';
    '1111111110011111';
    '1111111110100000';
    '1111111110100001';
    '1111111110100010';
    '1111111110100011';
    '1111111110100100';
    '1111111110100101';
    '1111111110100110';
    '1111001';
    '11111110111';
    '1111111110100111';
    '1111111110101000';
    '1111111110101001';
    '1111111110101010';
    '1111111110101011';
    '1111111110101100';
    '1111111110101101';
    '1111111110101110';
    '1111010';
    '11111111000';
    '1111111110101111';
    '1111111110110000';
    '1111111110110001';
    '1111111110110010';
    '1111111110110011';
    '1111111110110100';
    '1111111110110101';
    '1111111110110110';
    '11111001';
    '1111111110110111';
    '1111111110111000';
    '1111111110111001';
    '1111111110111010';
    '1111111110111011';
    '1111111110111100';
    '1111111110111101';
    '1111111110111110';
    '1111111110111111';
    '111110111';
    '1111111111000000';
    '1111111111000001';
    '1111111111000010';
    '1111111111000011';
    '1111111111000100';
    '1111111111000101';
    '1111111111000110';
    '1111111111000111';
    '1111111111001000';
    '111111000';
    '1111111111001001';
    '1111111111001010';
    '1111111111001011';
    '1111111111001100';
    '1111111111001101';
    '1111111111001110';
    '1111111111001111';
    '1111111111010000';
    '1111111111010001';
    '111111001';
    '1111111111010010';
    '1111111111010011';
    '1111111111010100';
    '1111111111010101';
    '1111111111010110';
    '1111111111010111';
    '1111111111011000';
    '1111111111011001';
    '1111111111011010';
    '111111010';
    '1111111111011011';
    '1111111111011100';
    '1111111111011101';
    '1111111111011110';
    '1111111111011111';
    '1111111111100000';
    '1111111111100001';
    '1111111111100010';
    '1111111111100011';
    '11111111001';
    '1111111111100100';
    '1111111111100101';
    '1111111111100110';
    '1111111111100111';
    '1111111111101000';
    '1111111111101001';
    '1111111111101010';
    '1111111111101011';
    '1111111111101100';
    '11111111100000';
    '1111111111101101';
    '1111111111101110';
    '1111111111101111';
    '1111111111110000';
    '1111111111110001';
    '1111111111110010';
    '1111111111110011';
    '1111111111110100';
    '1111111111110101';
    % '1111111010';
    '111111111000011';
    '1111111111110110';
    '1111111111110111';
    '1111111111111000';
    '1111111111111001';
    '1111111111111010';
    '1111111111111011';
    '1111111111111100';
    '1111111111111101';
    '1111111111111110'};

    bitstream = '';
    lower_bound = 2.^(0:1:10);
    upper_bound = 2.^(1:1:11) - 1;
    
    Group_Num = 1;
    while abs(b) > upper_bound(Group_Num)
        Group_Num = Group_Num + 1;
    end
    bitstream = strcat(bitstream, TAC{a*10 + Group_Num});
    
    if b > 0
        bitstream = strcat(bitstream, '1');
    else
        bitstream = strcat(bitstream, '0');
    end
        
    if abs(b) - lower_bound(Group_Num) == 0
        for i = 1: Group_Num - 1
            bitstream = strcat(bitstream, '0');    
        end
    else
        bits = int2bit(abs(b) - lower_bound(Group_Num), Group_Num - 1);
        bits_string = string(bits);
        bits_string = strjoin(bits_string, '');
        bitstream = strcat(bitstream, bits_string);   
    end

end