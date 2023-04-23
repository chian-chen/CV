% ==================================================
% STEP0: Read DataBase, TestCase
% ==================================================

[DataBase, TestCase] = STEP0_ReadData('1');
d = length(DataBase);
t = length(TestCase);

% ==================================================
% STEP1: Features Extraction
% ==================================================

Intensity_Feature = [Feature_Intensity(DataBase, d); Feature_Intensity(TestCase, t)];

Projection_Feature = [Feature_Projection(DataBase, d); Feature_Projection(TestCase, t)];

Erosion_Feature = [Feature_Erosion(DataBase, d); Feature_Erosion(TestCase, t)];

Moment_Feature = [Feature_Moment(DataBase, d); Feature_Moment(TestCase, t)];

Width_Feature = [Feature_Width(DataBase, d); Feature_Width(TestCase, t)];

EndPoint_Feature = [Feature_EndPoint(DataBase, d); Feature_EndPoint(TestCase, t)];

TurnPoint_Feature = [Feature_TurnPoint(DataBase, d); Feature_TurnPoint(TestCase, t)];

Side_Feature = [Feature_Side(DataBase, d); Feature_Side(TestCase, t)];

% ==================================================
% STEP2: Feature Selection(sifted features)
% ==================================================

Features = [Intensity_Feature Projection_Feature Erosion_Feature ...
    Moment_Feature Width_Feature EndPoint_Feature TurnPoint_Feature ...
    Side_Feature];

Features = Feature_Sifted(Features);

% ==================================================
% STEP3: Build model by SVM library
% ==================================================
addpath('./SVM');
% ==================================================
% train_set, test_set and train_labels, test_labels
% 1: 本人  0: 非本人
% ==================================================

one = ones(1, 5);
zero = zeros(1, 5);

train_features = [Features(1:5, :); Features(51:55, :); Features(6:15, :);
    Features(56:65, :); Features(16:25, :); Features(66:75, :)]; 

train_labels = [one zero one one zero zero one one zero zero].';

test_features = [Features(26:30, :); Features(76:80, :); Features(31:40, :);
    Features(81:90, :); Features(41:50, :); Features(91:100, :)]; 

test_labels = [one zero one one zero zero one one zero zero].';


model = svmtrain(train_labels, train_features);
[predicted, accuracy, d_values] = svmpredict(test_labels, test_features, model);

% ==================================================