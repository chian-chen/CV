function Features = Feature_Projection(D, n)

    Features = zeros(n, 10);
    for i = 1:n

        B = D{i};
        B(B < 255) = 1; B(B == 255) = 0;

        [m, n] = size(B);

        m1 = floor(m/5 * 1); m2 = floor(m/5 * 2);
        m3 = floor(m/5 * 3); m4 = floor(m/5 * 4);
        
        n1 = floor(n/5 * 1); n2 = floor(n/5 * 2);
        n3 = floor(n/5 * 3); n4 = floor(n/5 * 4);
    
        Features(i, 1) = sum(sum(B(1:m1, :)));
        Features(i, 2) = sum(sum(B(m1:m2, :)));
        Features(i, 3) = sum(sum(B(m2:m3, :)));
        Features(i, 4) = sum(sum(B(m3:m4, :)));
        Features(i, 5) = sum(sum(B(m4:end, :)));
        Features(i, 6) = sum(sum(B(:, 1:n1)));
        Features(i, 7) = sum(sum(B(:, n1:n2)));
        Features(i, 8) = sum(sum(B(:, n2:n3)));
        Features(i, 9) = sum(sum(B(:, n3:n4)));
        Features(i, 10) = sum(sum(B(:, n4:end)));
    end
end