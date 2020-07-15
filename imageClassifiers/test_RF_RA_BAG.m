%% Train a random forest using bag of surf features from the Raw_A images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data_Created/Raw_A/trainBag_RA');
load('codeinProgress/model/data_Created/Raw_A/testBag_RA');

load('codeinProgress/model/data_Created/Raw_A/trainStore_RA');
load('codeinProgress/model/data_Created/Raw_A/testStore_RA');

trainBagLabels_RA = str2double(string(trainStore_RA.Labels));
testBagLabels_RA = str2double(string(testStore_RA.Labels));

load('codeinProgress/model/data_Created/Raw_A/tuning_Rf_Bag/rfBag_RA_Model.mat');
load('codeinProgress/model/data_Created/Raw_A/tuning_Rf_Bag/Error_all_bag.mat');
%% Test the model using predict and the testing dataset 
[BagRA_predicted_labels,scores]= predict(rfBag_RA_Final, testBag_RA);

Bag_RA_predicted = str2double(string(BagRA_predicted_labels));

%Generate evluation metrics using confusion.m
[RfBag_RA_matrix, RfBag_RA_Result, RfBag_RA_ReferenceResult] = confusion.getMatrix(testBagLabels_RA,Bag_RA_predicted)

%% Print confusion matrix 
figure;
cmRFBag = confusionchart(testBagLabels_RA,Bag_RA_predicted );
cmRFBag.Title = 'Random Forest with Bag of SURF Features (Raw A Images)'
cmRFBag.FontSize = 12
%% Figures 
% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all_bag)
xlabel('Number of grown trees', 'fontsize', 14);
ylabel('Out-of-bag classification error', 'fontsize', 14);
title('Random Forest with BAG of SURF Features (Raw A Images)', 'fontsize', 15)

%% Bag Features
img1 = readimage(trainStore_RA,1);
img2 = readimage(trainStore_RA,40);
img3 = readimage(trainStore_RA,94);
img4 = readimage(trainStore_RA,115);
img5 = readimage(trainStore_RA,169);

featureVector = encode(bag_RA, img5);

% Plot the histogram of visual word occurrences
figure
bar(featureVector)
title('Visual word occurrences of an example Raw A image Class 5', 'fontsize', 15)
xlabel('Visual word index', 'fontsize', 14)
ylabel('Frequency of occurrence', 'fontsize', 14)

%% Surf features visualization (from matlab) 
% img1 = rgb2gray(img1);
% img2 = rgb2gray(img2);
% img3 = rgb2gray(img3);
% img4 = rgb2gray(img4);
% img5 = rgb2gray(img5);

points1 = detectSURFFeatures(img1);
points2 = detectSURFFeatures(img2);
points3 = detectSURFFeatures(img3);
points4 = detectSURFFeatures(img4);
points5 = detectSURFFeatures(img5);

%Display locations of interest in image.
figure;
imshow(img1); hold on;
plot(points1.selectStrongest(5));
title('Class 1 Raw A Image')

figure;
imshow(img2); hold on;
plot(points2.selectStrongest(5));
title('Class 2 Raw A Image')

figure;
imshow(img3); hold on;
plot(points3.selectStrongest(5));
title('Class 3 Raw A Image')

figure;
imshow(img4); hold on;
plot(points4.selectStrongest(5));
title('Class 4 Raw A Image')

figure;
imshow(img5); hold on;
plot(points5.selectStrongest(5));
title('Class 5 Raw A Image')
