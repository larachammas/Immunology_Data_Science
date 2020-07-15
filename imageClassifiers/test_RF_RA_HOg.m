%% Train a random forest using hog features from the Raw_A images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data_Created/Raw_A/trainHogFeatures_RA');
load('codeinProgress/model/data_Created/Raw_A/testHogFeatures_RA');
load('codeinProgress/model/data_Created/Raw_A/trainHogLabels_RA');
load('codeinProgress/model/data_Created/Raw_A/testHogLabels_RA');
load('codeinProgress/model/data_Created/Raw_A/tuning_Rf_Hog/rfHog_RA_Final');
load('codeinProgress/model/data_Created/Raw_A/tuning_Rf_Hog/Error_all.mat');


trainHogLabels_RA = str2double(string(trainHogLabels_RA));
testHogLabels_RA = str2double(string(testHogLabels_RA));

%% Test the model using predict and the testing dataset 
[HogRA_predicted_labels,scores]= predict(rfHog_RA_Final, testHogFeatures_RA);

HOG_RA_predicted = str2double(string(HogRA_predicted_labels));

%Generate evluation metrics using confusion.m
[RfHog_RA_matrix, RfHog_RA_Result, RfHog_RA_ReferenceResult] = confusion.getMatrix(testHogLabels_RA,HOG_RA_predicted)

%% Print confusion matrix 
figure;
cmRFHog = confusionchart(testHogLabels_RA,HOG_RA_predicted );
title('Random Forest with HOG Features (Raw A Images)')
cmRFHog.FontSize = 12
%% Figures 

%Extracting and display Histogram of Oriented Gradient Features for a single face
class = 5;
[hogFeature, visualization]= extractHOGFeatures(read(trainSet_RA(class),4));
figure;
subplot(1,2,1);imshow(read(trainSet_RA(class),4));title('Input Image');
subplot(1,2,2);plot(visualization);title('HoG Feature Map');
sgtitle('Example of Raw A Class 5 Image HOG Feature Map')

%% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all)
xlabel('Number of grown trees', 'fontsize', 14);
ylabel('Out-of-bag classification error', 'fontsize', 14);
title('Random Forest with HOG Features (Raw A Images)', 'fontsize', 15)

