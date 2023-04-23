function [DataBase, TestCase] = STEP0_ReadData(c)

    d = dir(strcat('./data/', c, '/database/*.bmp'));
    path = strcat('./data/', c, '/database/');
    t = dir(strcat('./data/', c, '/testcase/*.bmp'));
    path_t = strcat('./data/', c, '/testcase/');
    
    k = numel(d);
    
    DataBase = cell(1, k);
    TestCase = cell(1, k);
    
    for i = 1 : k
      im = double(imread(strcat(path, d(i).name)));
      R = im(:, :, 1);  G = im(:, :, 2);    B = im(:, :, 3);
      Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
      Y(Y > 220) = 255;
      DataBase{i} = double(Y);
      im = double(imread(strcat(path_t, t(i).name)));
      R = im(:, :, 1);  G = im(:, :, 2);    B = im(:, :, 3);
      Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
      Y(Y > 220) = 255;
      TestCase{i} = double(Y);
    end

end