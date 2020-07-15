%% Train a random forest using hog features from the Raw_B images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data_Created/Raw_B/trainHogFeatures_RB');
load('codeinProgress/model/data_Created/Raw_B/testHogFeatures_RB');
load('codeinProgress/model/data_Created/Raw_B/trainHogLabels_RB');
load('codeinProgress/model/data_Created/Raw_B/testHogLabels_RB');
load('codeinProgress/model/data_Created/Raw_B/tuning_Rf_Hog/rfHog_RB_Final');

trainHogLabels_RB = str2double(string(trainHogLabels_RB));
testHogLabels_RB = str2double(string(testHogLabels_RB));

%% Test the model using predict and the testing dataset 
[HogRB_predicted_labels,scores]= predict(rfHog_RB_Final, testHogFeatures_RB);

HOG_RB_predicted = str2double(string(HogRB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfHog_RB_matrix, RfHog_RB_Result, RfHog_RB_ReferenceResult] = confusion.getMatrix(testHogLabels_RB,HOG_RB_predicted)

%% Print confusion matrix 
figure;
cmRFBag = confusionchart(testHogLabels_RB,HOG_RB_predicted );
title('Random Forest with HOG Features (Raw B Images)')
cmRFBag.FontSize = 12
%% Figures 

%Extracting and display Histogram of Oriented Gradient Features for a single face
% person = 5;
% [hogFeature, visualization]= extractHOGFeatures(read(trainSet_RB(person),1));
% figure;
% subplot(1,2,1);imshow(read(trainSet(person),1));title('Input Face');
% subplot(1,2,2);plot(visualization);title('HoG Feature');

%% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all)
xlabel('Number of grown trees', 'fontsize', 14);
ylabel('Out-of-bag classification error', 'fontsize', 14);
title('Random Forest with HOG Features (Raw B Images)', 'fontsize', 15)