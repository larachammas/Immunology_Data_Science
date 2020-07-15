%% Train a random forest using bag of surf features from the Processed B2 images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data_Created/PB/bag_PB.mat');

load('codeinProgress/model/data_Created/PB/trainBag_PB');
load('codeinProgress/model/data_Created/PB/testBag_PB');

load('codeinProgress/model/data_Created/PB/trainStore_PB');
load('codeinProgress/model/data_Created/PB/testStore_PB');

trainBagLabels_PB = str2double(string(trainStore_PB.Labels));
testBagLabels_PB = str2double(string(testStore_PB.Labels));

load('codeinProgress/model/data_Created/PB/tuning_Bag/rfBag_PB_Model.mat');
load('codeinProgress/model/data_Created/PB/tuning_Bag/Error_all_bag_PB.mat');
%% Test the model using predict and the testing dataset 
[BagPB_predicted_labels,scores]= predict(rfBag_PB_Final, testBag_PB);

Bag_PB_predicted = str2double(string(BagPB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfBag_PB_matrix, RfBag_PB_Result, RfBag_RA_ReferenceResult] = confusion.getMatrix(testBagLabels_PB,Bag_PB_predicted)

%% Print confusion matrix 
figure;
cmRFBag = confusionchart(testBagLabels_PB,Bag_PB_predicted );
cmRFBag.Title = 'Random Forest with Bag of SURF Features (Processed B Images)'
cmRFBag.FontSize = 12
%% Figures 
% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all_bag_PB)
xlabel('Number of grown trees', 'fontsize', 14);
ylabel('Out-of-bag classification error', 'fontsize', 14);
title('Random Forest with BAG of SURF Features (Processed B Images)', 'fontsize', 15)

%% Bag Features
img1 = readimage(trainStore_PB,1);
img2 = readimage(trainStore_PB,52);
img3 = readimage(trainStore_PB,94);

featureVector1 = encode(bag_PB, img1);
featureVector2 = encode(bag_PB, img2);
featureVector3 = encode(bag_PB, img3);

% Plot the histogram of visual word occurrences
figure
bar(featureVector1)
title('Visual word occurrences of an example Processed B image Class 1', 'fontsize', 15)
xlabel('Visual word index', 'fontsize', 14)
ylabel('Frequency of occurrence', 'fontsize', 14)

figure
bar(featureVector2)
title('Visual word occurrences of an example Processed B image Class 2', 'fontsize', 15)
xlabel('Visual word index', 'fontsize', 14)
ylabel('Frequency of occurrence', 'fontsize', 14)

figure
bar(featureVector3)
title('Visual word occurrences of an example Processed B image Class 3', 'fontsize', 15)
xlabel('Visual word index', 'fontsize', 14)
ylabel('Frequency of occurrence', 'fontsize', 14)

%% Surf features visualization (from matlab) 
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);
img3 = rgb2gray(img3);

points1 = detectSURFFeatures(img1);
points2 = detectSURFFeatures(img2);
points3 = detectSURFFeatures(img3);

%Display locations of interest in image.
figure;
imshow(img1); hold on;
plot(points1.selectStrongest(5));
title('Class 1 Processed B Image')

figure;
imshow(img2); hold on;
plot(points2.selectStrongest(5));
title('Class 2 Processed B Image')

figure;
imshow(img3); hold on;
plot(points3.selectStrongest(5));
title('Class 3 Procssed B Image')
