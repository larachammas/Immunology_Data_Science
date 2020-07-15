%% Train a random forest using hog features from the Raw_B images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data_Created/PB/trainHogFeatures_PB');
load('codeinProgress/model/data_Created/PB/testHogFeatures_PB');
load('codeinProgress/model/data_Created/PB/trainHogLabels_PB');
load('codeinProgress/model/data_Created/PB/testHogLabels_PB');
load('codeinProgress/model/data_Created/PB/tuning_Hog/rfHog_PB_Final');
load('codeinProgress/model/data_Created/PB/trainSet_PB.mat');
load('codeinProgress/model/data_Created/PB/testSet_PB.mat');
load('codeinProgress/model/data_Created/PB/tuning_Hog/Error_all.mat');

trainHogLabels_PB = str2double(string(trainHogLabels_PB));
testHogLabels_PB = str2double(string(testHogLabels_PB));

%% Test the model using predict and the testing dataset 
[HogPB_predicted_labels,scores]= predict(rfHog_PB_Final, testHogFeatures_PB);

HOG_PB_predicted = str2double(string(HogPB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfHog_PB_matrix, RfHog_PB_Result, RfHog_PB_ReferenceResult] = confusion.getMatrix(testHogLabels_PB,HOG_PB_predicted)

%% Print confusion matrix 
figure;
cmRFBag = confusionchart(testHogLabels_PB,HOG_PB_predicted );
title('Random Forest with HOG Features (Processed B Images)')
cmRFBag.FontSize = 12
%% Figures 

%Extracting and display Histogram of Oriented Gradient Features for a single face
class = 3;
[hogFeature, visualization]= extractHOGFeatures(read(trainSet_PB(class),4));
figure;
subplot(1,2,1);imshow(read(trainSet_PB(class),4));title('Input Image');
subplot(1,2,2);plot(visualization);title('HoG Feature Map');
sgtitle('Example of Processed B Class 3 Image HOG Feature Map')


%% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all)
xlabel('Number of grown trees', 'fontsize', 14);
ylabel('Out-of-bag classification error', 'fontsize', 14);
title('Random Forest with HOG Features (Processed B Images)', 'fontsize', 15)