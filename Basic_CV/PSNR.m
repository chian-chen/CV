function result = PSNR(x, y)
    % implementation of PSNR (Peak Signal to Noise Ratio)
    % assume x, y are 2-D img and have the same size
    % which pixel is stored by a byte (8 bits, range from 0-255)

    shape = size(x);
    down = sum((x - y).^2, 'all') / shape(1) / shape(2) / 3;
    result = 10* log10(255 * 255 / down);
end