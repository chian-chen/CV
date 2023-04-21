% =======================================================
% This file implements edge detector, Smoother and how 
% noise will impact on the result
% =======================================================
% Edge detector
x = [zeros(1, 20) ones(1, 31) zeros(1, 29) ones(1,31) zeros(1, 20)];
n = -30:100;
figure; stem(n, x); xlim([n(1),n(end)]);
title('Plot x[n] vs n'); ylabel('x [ n ]'); xlabel('n');
% =======================================================
% parameters for h[n] and noise
% =======================================================
L = 20;    an = 0.5;   sigma = 0.5;
% =======================================================
% h[n]
h_1 = exp(-sigma * (1:L)) / sum(exp(-sigma * (1:L)));
h_2 = fliplr(h_1) * -1;
h = [h_2 0 h_1];
% =======================================================
% noise
noise = an * (rand(1,131) - 0.5);
% =======================================================
% x1[n] = x[n] + noise
x1 = x + noise;
figure; stem(n, x1); xlim([n(1),n(end)]);
title('Plot x1[n] vs n');   ylabel('x1 [ n ]');     xlabel('n');
% =======================================================
% conv to find edge
figure; stem(n, conv(x, h, 'same'));  xlim([n(1),n(end)]);
title('Plot edge vs n');    ylabel('edge [ n ]');   xlabel('n');
% =======================================================
figure; stem(n, conv(x1, h, 'same')); xlim([n(1),n(end)]);
title('Plot edge1 vs n');   ylabel('edge1 [ n ]');  xlabel('n');
% =======================================================

% Smoother
x = (-50:100) * 0.1;
n = -50:100;

figure; stem(n, x); xlim([n(1),n(end)]);
title('Plot x[n] vs n');    ylabel('x [ n ]');  xlabel('n');
% =======================================================
% parameters for h[n] and noise
L = 20; an = 0.5;   sigma = 0.5;
% =======================================================
% noise
noise = an * (rand(1,151) - 0.5);
% =======================================================
% h[n]
h_1 = exp(-sigma*(1:L))/(2 * sum(exp(-sigma*(1:L))) + 1);
h_2 = fliplr(h_1);
h = [h_2 sum(exp(-sigma*(1:L))) h_1];
% =======================================================
% x1[n] = x[n] + noise
x1 = x + noise;
figure; stem(n, x1);    xlim([n(1),n(end)]);
title('Plot x1[n] vs n');   ylabel('x1 [ n ]'); xlabel('n');
% =======================================================
figure; stem(n, conv(x1, h, 'same'));   xlim([n(1),n(end)]);
title('Plot smoother vs n');    ylabel('smoother [ n ]');   xlabel('n');
% =======================================================
