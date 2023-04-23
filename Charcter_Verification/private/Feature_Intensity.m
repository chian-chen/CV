function Features = Feature_Intensity(D, n)
    
    Features = zeros(n, 2);
    for i = 1:n
        B = D{i};
        w = sum(sum(B >= 0));
        Y_mean = sum(sum(B))/w;
        Y_std = sqrt( sum(sum((B - Y_mean).^2)) / w );
        Features(i, 1) = Y_mean;
        Features(i, 2) = Y_std;
    end
   
end