function result = NRMSE(x, y)
    % implementation of NRMSE (Normalized Root Mean Square Error)
    % assume x, y are 2-D img and have the same size

    up = sum((x - y).^2, 'all');
    down = sum(x.^2, 'all');

    result = sqrt(up / down);
end