% ============================================================
% ============  JPEG  ========================================
% ============================================================

% Read the img (color)
Im = double(imread('./Baboon512.bmp'));
figure, image(Im/255), title('Source');
[m, n, d] = size(Im);

% ============================================================
% STEP0: padding input_im to make sure m equals n 
% and the value of m,n are divisible by 8
% the original size should be stored in somewhere 
% ============================================================

% ============================================================
% STEP1: Trans RGB to YCbCr and downsampling CbCr to 4:2:0
% Also, Cb, Cr should be added by offset 127.5
% Input: m x n x 3 img, Output: [Y, Cb, Cr]
% ============================================================

[Y, Cb, Cr] = STEP1_toYCbCr(Im);

% ============================================================
% STEP2: 8x8 DCT
% Input: [Y, Cb, Cr], Output: [Y_DCT, Cb_DCT, Cr_DCT]
% ============================================================

[Y_DCT, Cb_DCT, Cr_DCT] = STEP2_DCT(Y, Cb, Cr);

% ============================================================
% STEP3: Quantization
% Input: [Y_DCT, Cb_DCT, Cr_DCT], Output: [Y_Q, Cb_Q, Cr_Q]
% ============================================================

[Y_Q, Cb_Q, Cr_Q] = STEP3_Quant(Y_DCT, Cb_DCT, Cr_DCT);

% ============================================================
% STEP4: Encoding
% DC: Difference, AC: ZeroRun
% Input: [Y_Q, Cb_Q, Cr_Q], 
% Output: [Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC]
% ============================================================

[Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC] = STEP4_Encode(Y_Q, Cb_Q, Cr_Q);

% ============================================================
% STEP5: Huffman Encoding
% Input: [Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC], 
% Output: [YDC_Str, YAC_Str, CbDC_Str, CbAC_Str, CrDC_Str, CrAC_Str]
% ============================================================

[YDC_Str, YAC_Str, CbDC_Str, CbAC_Str, CrDC_Str, CrAC_Str] = ...
    STEP5_Huffman(Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC);

% ============================================================
% STEP5 Inverse: Huffman Decoding
% Input: [YDC_Str, YAC_Str, CbDC_Str, CbAC_Str, CrDC_Str, CrAC_Str], 
% Output: [Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC]
% ============================================================

[Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC] = ...
    invSTEP5(YDC_Str, YAC_Str, CbDC_Str, CbAC_Str, CrDC_Str, CrAC_Str);

% ============================================================
% STEP4 Inverse: Decoding
% DC: Difference, AC: ZeroRun
% Input: [Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC]
% Output: [Y_Q, Cb_Q, Cr_Q]
% ============================================================

[Y_Q, Cb_Q, Cr_Q] = invSTEP4(Y_DC, Y_AC, Cb_DC, Cb_AC, Cr_DC, Cr_AC);

% ============================================================
% STEP3 Inverse: inQuantization
% Input: [Y_Q, Cb_Q, Cr_Q], Output: [Y_DCT, Cb_DCT, Cr_DCT]
% ============================================================

[Y_DCT, Cb_DCT, Cr_DCT] = invSTEP3(Y_Q, Cb_Q, Cr_Q);

% ============================================================
% STEP2 Inverse: invDCT
% Input: [Y_DCT, Cb_DCT, Cr_DCT], Output: [Y, Cb, Cr]
% ============================================================

[Y, Cb, Cr] = invSTEP2(Y_DCT, Cb_DCT, Cr_DCT);

% ============================================================
% STEP1 Inverse: Trans YCbCr to RGB and cat 3 layers to img
% Input: [Y, Cb, Cr], Output: recovery img (m x n x 3)
% ============================================================

Re_Im = invSTEP1(Y, Cb, Cr);
figure, image(Re_Im/255), title('Recovery');



% ============================================================
% Compute the compression rate (bit per pixel) and PSNR
% ============================================================

Lists = [YDC_Str, YAC_Str, CbDC_Str, CbAC_Str, CrDC_Str, CrAC_Str];
length = 0;
for i = 1:6
    length = length + strlength(Lists(i));
end

bpp = length / size(Im, 1) / size(Im, 2);
PSNR = 10 * log10(255 * 255 * m * n * d / sum((Im - Re_Im).^2, 'all'));



