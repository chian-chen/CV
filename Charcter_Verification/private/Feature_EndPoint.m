function Features = Feature_EndPoint(D, n)
    

    Features = zeros(n, 30);
    
    % Read Ref_img
    Ref = double(imread('./data/Ref/1-3.png'));
    Ref = 0.299 .* Ref(:, :, 1) + 0.587 .* Ref(:, :, 2) + 0.114 .* Ref(:, :, 3);
    Ref(Ref > 220) = 255;   Ref(Ref <= 220) = 1;    Ref(Ref == 255) = 0;
    
    for f = 1:n
        B = D{f};
        B(B < 255) = 1; B(B == 255) = 0;

        % Preprocess
        [EndPoints, ~] = Points(B);
        % sifted by confidence
        EndPoints = PointConfidence(EndPoints, Ref);
        Diff = Difference(B, Ref, EndPoints);
        [~, index] = sort(Diff);
        index = index(1:5);
        
        % Choose 5 min diff EndPoints
        SelectedPoints = EndPoints(index(:),:);
        
        % NormLocation
        [m_new, n_new] = NormLocation(B, SelectedPoints(:,1), SelectedPoints(:,2));
        Features(f, 1:5) = m_new(:);
        Features(f, 6:10) = n_new(:);
        
        % Distance and Direction
        distance = zeros(1,10);
        direction = zeros(1, 10);
        index = 1;
        
        for i = 1 : 4
            x1 = SelectedPoints(i, 1);
            y1 = SelectedPoints(i, 2);
            
            for j = i + 1 : 5
                x2 = SelectedPoints(j, 1);
                y2 = SelectedPoints(j, 2);
                
                distance(index) = sqrt((x1-y1)^2 + (x2-y2)^2);
                direction(index) = acos((x1*x2 + y1*y2)/sqrt(x1*x1 + y1*y1)/sqrt(x2*x2 + y2*y2));
                index = index + 1;
            end
        end
        
        Features(f, 11:20) = direction(:);
        Features(f, 21:30) = distance(:);
    end
    
end

function D = Difference(B1, B2, EndPoints)
    m = EndPoints(:, 1);
    n = EndPoints(:, 2);
    [m_new1, n_new1] = NormLocation(B1, m, n);
    [m_new2, n_new2] = NormLocation(B2, m, n);
    [m_ratio1, n_ratio1] = CoordiRatio(B1, m, n);
    [m_ratio2, n_ratio2] = CoordiRatio(B2, m, n);
    direction1 = Directions(B1, 3, m, n);
    direction2 = Directions(B2, 3, m, n);
    
    w1 = 1; w2 = 1; w3 = 1;
    Diffnew = abs((m_new1 - m_new2 )+ (n_new1 - n_new2));
    Diffratio = abs((m_ratio1 - m_ratio2)+(n_ratio1-n_ratio2));
    Diffdirection = min(abs(direction1 - direction2), 2 * pi -abs(direction1 - direction2));
    D =  w1 * Diffnew + w2 * Diffratio + w3 * Diffdirection;
end
function [m_ratio, n_ratio] = CoordiRatio(B, m, n)

    % Total
    TotalPoints = sum(B, 'all');

    % m_ratio, n_ratio

    size = length(m);
    m_ratio = zeros(1, size);
    n_ratio = zeros(1, size);

    for i = 1:size
        subM = B(1:m(i), :);
        subN = B(:, 1:n(i));
        m_ratio(i) = sum(subM, 'all')/TotalPoints;
        n_ratio(i) = sum(subN, 'all')/TotalPoints;
    end

end
function direction = Directions(B, L, m, n)

    size = 2*L + 1;
    mask = zeros(size, size);

    for x = 1:size
        for y = 1:size
            mask(x, y) = (x - L) + 1i*(y - L);
        end
    end

    Xd = conv2(B, mask, 'same');
    A = angle(Xd);

    direction = zeros(1, length(m));
    for i = 1:length(m)
        direction(i) = A(m(i), n(i));
    end
end
function HighConfidencePoints = PointConfidence(EndPoints, Ref)

    [m_new, n_new] = NormLocation(Ref, EndPoints(:,1), EndPoints(:,2));


    m = m_new;
    n = n_new;
    size = length(m);
    
    % if x or y differs over 2 in normLocation,
    %           it is viewed as two different Endpoints
    threshold = 4;

    Group = cell(1, size);
    index = 1;

    while(sum(find(m)))
        f = find(m, 1);
        m1 = m(f);
        n1 = n(f);
        d = (m_new - m1).^2 + (n_new - n1).^2;
    
        dd = find(d < threshold);
        dd(dd<f) = [];
    
        m(dd) = 0;
        n(dd) = 0;
    
        Group{index} = dd;
        index = index + 1;
    end
    
    index = index - 1;
    newindex = zeros(1, index);

    for i = 1:index
        newindex(i) = Group{i}(1);
    end

    HighConfidencePoints = zeros(index, 2);
    HighConfidencePoints(:, 1) = EndPoints(newindex, 1);
    HighConfidencePoints(:, 2) = EndPoints(newindex, 2);

end
function [m_new, n_new] = NormLocation(B, m, n)
    % Find m1, m2

    M = find(sum(B, 2));
    m1 = M(1); m2 = M(end);

    % Find n1, n2

    N = find(sum(B));
    n1 = N(1); n2 = N(end);

    % m_o, n_o

    m_o = (m1 + m2)/2;  n_o = (n1 + n2)/2;
    d = min(m2-m1, n2-n1);

    % m_new, n_new

    size = length(m);
    m_new = zeros(1, size);
    n_new = zeros(1, size);

    for i = 1:size
        m_new(i) = (m(i)-m_o)/d*100;
        n_new(i) = (n(i)-n_o)/d*100;
    end
    
end
function [EndPoints, TurnPoints] = Points(B)
    NotEdge = conv2(B, [0 1 0; 1 1 1; 0 1 0], 'same');
    NotEdge(NotEdge < 5) = 0;   NotEdge = NotEdge / 5;

    Edge = B - NotEdge;

    cases = GenerateCases();
    OrderList = cell(1, 10);
    sumArea = 0;

    points = sum(Edge, 'all');
    regionNum = 1;

    while points > 0
        [row, col] = find(Edge);
        [Edge, Order, Area] = Trace(Edge, row(1), col(1), cases);

        % if the region is too small, it will not provide useful information
        if Area > 30
            OrderList{regionNum} = Order;
            regionNum = regionNum + 1;
            sumArea = sumArea + Area;
        end
    
        points = sum(Edge, 'all');  % update
    end

    OrderList = OrderList(~cellfun('isempty',OrderList));   % remove empty cell

    % classify points

    TurnPoints = zeros(sumArea, 2);
    EndPoints = zeros(sumArea, 2);
    TurnPointIndex = 1; EndPointIndex = 1;
    d = 15;

    for i = 1:length(OrderList)
        n = length(OrderList{i});
        for j = 1:n
            if j > d && j <= n - d
                a1 = OrderList{i}(j,:);
                a2 = OrderList{i}(j-d,:);
                a3 = OrderList{i}(j+d,:);
                kind = ClassifyPoints(a1, a2, a3);
            elseif j <= d
                a1 = OrderList{i}(j,:);
                a2 = OrderList{i}(n - d + j,:);
                a3 = OrderList{i}(j+d,:);
                kind = ClassifyPoints(a1, a2, a3);
            else
                a1 = OrderList{i}(j,:);
                a2 = OrderList{i}(j-d,:);
                a3 = OrderList{i}(j - n + d,:);
                kind = ClassifyPoints(a1, a2, a3);
            end
            if kind == 1
                EndPoints(EndPointIndex, :) = OrderList{i}(j, :);
                EndPointIndex = EndPointIndex + 1;
            elseif kind == 2
                TurnPoints(TurnPointIndex, :) = OrderList{i}(j, :);
                TurnPointIndex = TurnPointIndex + 1;
            else
            end
        end
    end

    TurnPoints( ~any(TurnPoints,2), : ) = [];  %delete all zero rows
    EndPoints( ~any(EndPoints,2), : ) = [];  %delete all zero rows
    
end
function [newB, Order, Area] = Trace(B, row, col, cases)

    newB = B;
    startRow = row; startCol = col;
    
    points = sum(newB, 'all');
    Order = zeros(points, 2);   num = 1;
    Area = 0;
    currentCase = cases{4};
    
    while points > 0
        
        Order(num, 1) = row;
        Order(num, 2) = col;
        num = num + 1;
        newB(row, col) = 0;
        Area = Area + 1;
        
        window = newB(row - 1: row + 1, col - 1: col + 1);
        points = sum(window, 'all');
        
        % Trace Back
        if(points == 0)
            back = num - 1;
            while points == 0 && back > 1
                back = back - 1;
                row = Order(back, 1);
                col = Order(back, 2);
                window = newB(row - 1: row + 1, col - 1: col + 1);
                points = sum(window, 'all');
                if ((row == startRow && col == startCol))
                    break;
                end
            end
            currentCase = cases{4};
        end

        
        for i = 1 : 8
            if window(currentCase(i)) == 1
                [row, col, c] = Update(row, col, currentCase(i));
                currentCase = cases{c};
                break;
            end
        end
        
        if (row == startRow && col == startCol)
            break;
        end
    end
    
    Order( ~any(Order,2), : ) = [];  %delete all zero rows
end
function [newrow, newcol, c] = Update(row, col, currentcase)
    if currentcase == 1
        newrow = row - 1; newcol = col - 1; c = 1;
    elseif currentcase == 2
        newrow = row; newcol = col - 1; c = 8;
    elseif currentcase == 3
        newrow = row + 1; newcol = col - 1; c = 7;
    elseif currentcase == 4
        newrow = row - 1; newcol = col; c = 2;
    elseif currentcase == 6
        newrow = row + 1; newcol = col; c = 6;
    elseif currentcase == 7
        newrow = row - 1; newcol = col + 1; c = 3;
    elseif currentcase == 8
        newrow = row; newcol = col + 1; c = 4;
    else
        newrow = row + 1; newcol = col + 1; c = 5;
    end
end
function cases = GenerateCases()
    cases = cell(1, 7);
    cases{1} = [6 3 2 1 4 7 8 9];
    for i = 2 : 8
        a = cases{i - 1};
        cases{i} = [a(2:end) a(1)];
    end
end
function kind = ClassifyPoints(a1, a2, a3)
    v1 = a2 - a1;
    v2 = a3 - a1;
    theta = acos(sum(v1 .* v2)/sqrt(sum(v1.^2)*sum(v2.^2)));
    if theta <= pi/6
        kind = 1;
    elseif pi/6 < theta && theta < 5*pi/6
        kind = 2;
    else
        kind = 3;
    end
end