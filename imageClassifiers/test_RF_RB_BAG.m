%% Train a random forest using bag of surf features from the Raw_B images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data_Created/Raw_B/trainBag_RB');
load('codeinProgress/model/data_Created/Raw_B/testBag_RB');

load('codeinProgress/model/data_Created/Raw_B/trainStore_RB');
load('codeinProgress/model/data_Created/Raw_B/testStore_RB');

trainBagLabels_RB = str2double(string(trainStore_RB.Labels));
testBagLabels_RB = str2double(string(testStore_RB.Labels));

load('codeinProgress/model/data_Created/Raw_B/tuning_Rf_Bag/rfBag_RB_Model.mat');
load('codeinProgress/model/data_Created/Raw_B/tuning_Rf_Bag/Error_all_bag_RB.mat');
%% Test the model using predict and the testing dataset 
[BagRB_predicted_labels,scores]= predict(rfBag_RB_Final, testBag_RB);

Bag_RB_predicted = str2double(string(BagRB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfBag_RB_matrix, RfBag_RB_Result, RfBag_RB_ReferenceResult] = confusion.getMatrix(testBagLabels_RB,Bag_RB_predicted)

%% Print confusion matrix 
figure;
cmRFBag = confusionchart(testBagLabels_RB,Bag_RB_predicted );
title('Random Forest with Bag of SURF Features (Raw B Images)')
cmRFBag.FontSize = 12
%% Figures 
% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all_bag_RB)
xlabel('Number of grown trees', 'fontsize', 14);
ylabel('Out-of-bag classification error', 'fontsize', 14);
title('Random Forest with BAG of SURF Features (Raw B Images)', 'fontsize', 15)

%% Bag Features Visualization
img1 = readimage(trainStore_RB,1);
img2 = readimage(trainStore_RB,58);
img3 = readimage(trainStore_RB,98);

featureVector = encode(bag_RB, img3);

% Plot the histogram of visual word occurrences
figure
bar(featureVector)
title('Visual word occurrences of an example Raw B image Class 3', 'fontsize', 15)
xlabel('Visual word index', 'fontsize', 14)
ylabel('Frequency of occurrence', 'fontsize', 14)

%% Surf features visualization (from matlab) 
%img1 = rgb2gray(img1);
%img2 = rgb2gray(img2);
img3 = rgb2gray(img3);

points1 = detectSURFFeatures(img1);
points2 = detectSURFFeatures(img2);
points3 = detectSURFFeatures(img3);
%Display locations of interest in image.
imshow(img3); hold on;
plot(points3.selectStrongest(5));
title('Class 3 Raw B Image')