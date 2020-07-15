%% Train a random forest using hog features from the Raw_A images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

%load('codeinProgress/model/data/Raw_B/trainHogFeatures_RB');
%load('codeinProgress/model/data/Raw_B/testHogFeatures_RB');
%load('codeinProgress/model/data/Raw_B/trainHogLabels_RB');
%load('codeinProgress/model/data/Raw_B/testHogLabels_RB');


trainHogLabels_PB = str2double(string(trainHogLabels_PB));
testHogLabels_PB = str2double(string(testHogLabels_PB));

%% Tuning parameters 

%array with values of number of trees for the forrest 
numTree = [1, 20 , 40 , 60 , 80 , 100, 120, 140, 160, 180, 200] ; 

%array of values to try for minimum number of observations per tree leaf
minLeaf = [1:10]; 

%initalize arrays to hold values created in loops 
Parameters = [];
Errors = [] ;   
Accuracy = [] ; 
ErrorAllTable = [] ;
Final_hog_PB_Array = table ;

%% Grid Search 
for i = 1:length(numTree)
    
    i 
    
    for j = 1:length(minLeaf)
        
        Model_hog_PB = TreeBagger(numTree(i), trainHogFeatures_PB, trainHogLabels_PB, 'OOBPrediction', 'on', 'minLeafSize', minLeaf(j), 'Method', 'classification');

        %input the parameters tested into an array
        Parameters = [Parameters; numTree(i), minLeaf(j)] ;
        
        %generate the error (or the misclassification probability) for each
        %model for out-of-bag observations in the training data 
        %using ensemble to calculate an average for all the trees in that
        %model
        model_error = oobError(Model_hog_PB, 'Mode', 'Ensemble') ; 
        
        Error_all = oobError(Model_hog_PB); %generate the errors for each of the trees in the model for plotting
      
        %input the oobError values into an array
        Errors = [Errors; model_error];
        
        ErrorAllTable = [ErrorAllTable ; Error_all];
        
       %use the trained model to predict classes on the out of bag
       %observations stored in the model
       [HogPB_predicted_labels,scores]= oobPredict(Model_hog_PB);
       
       HogPB_predictedLabels = str2double(string(HogPB_predicted_labels));
       
       %generate the confusion matrix from the ooBPredict output 
       Hog_PB_CM= confusionmat(trainHogLabels_PB ,HogPB_predictedLabels);
        
       %calculate the accuracy of the model using the confusion matrix 
       Accuracy_model = 100*sum(diag(Hog_PB_CM))./sum(Hog_PB_CM(:));
       
       %store the model accuracy values in an array
       Accuracy = [Accuracy; Accuracy_model] ; 
       
       %join the parameters test and the model error and accuracy in a row
       %in an array 
       Final_hog_PB_Array = [Parameters Errors Accuracy] ; 
    %end
     end 
end 

%% Extract best model parameters 

%transform the array to a table
Final_hog_PB_Array = array2table(Final_hog_PB_Array) ; 
%assign column names to table
Final_hog_PB_Array.Properties.VariableNames = {'NumTrees', 'NumLeaves' ,  'oobErrorValue', 'AccuracyValue'} ; 

%find the minimum model error
min_error = min(Final_hog_PB_Array{:,3}) %find the minimum error for all the models 

%find the highest model accuracy 
highestAccuracy = max(Final_hog_PB_Array{:,4})

%find the model row with the highest accuracy and what its parameters are 
best_model_hog_PB_features = Final_hog_PB_Array(Final_hog_PB_Array.AccuracyValue == highestAccuracy, :)

%% Save tuned models 
save('codeinProgress/model/data_Created/PB/tuning_Hog/Final_hog_PB_Array', 'Final_hog_PB_Array')
save('codeinProgress/model/data_Created/PB/tuning_Hog/hog_best_features', 'best_model_hog_PB_features')
save('codeinProgress/model/data_Created/PB/tuning_Hog/Error_all', 'Error_all')

%% Train a new model using the parameters 
numtrees = best_model_hog_PB_features{1,1} ; 
numLeaves = best_model_hog_PB_features{1,2};

rfHog_PB_Final = TreeBagger(numtrees, trainHogFeatures_PB, trainHogLabels_PB, 'OOBPrediction', 'on', 'minLeafSize', numLeaves, 'Method', 'classification');

%% 
save('codeinProgress/model/data_Created/PB/tuning_Hog/rfHog_PB_Final', 'rfHog_PB_Final')

%% Test the model using predict and the testing dataset 
[HogPB_predicted_labels,scores]= predict(rfHog_PB_Final, testHogFeatures_PB);

HOG_PB_predicted = str2double(string(HogPB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfHog_PB_matrix, RfHog_PB_Result, RfHog_PB_ReferenceResult] = confusion.getMatrix(testHogLabels_PB,HOG_PB_predicted)

%Print confusion matrix 
figure;
cmRFHog = confusionchart(testHogLabels_PB,HOG_PB_predicted );
title('RF with HOG on Processed B Images Confusion Chart')

%%
save('codeinProgress/model/data_Created/PB/tuning_Hog/RfHog_PB_matrix', 'RfHog_PB_matrix')
save('codeinProgress/model/data_Created/PB/tuning_Hog/RfHog_PB_Result', 'RfHog_PB_Result')
save('codeinProgress/model/data_Created/PB/tuning_Hog/RfHog_PB_ReferenceResult', 'RfHog_PB_ReferenceResult')

%% Figures 

%Extracting and display Histogram of Oriented Gradient Features for a single face
person = 3;
[hogFeature, visualization]= extractHOGFeatures(read(trainSet_PB(person),1));
figure;
subplot(1,2,1);imshow(read(trainSet_PB(person),1));title('Input Face');
subplot(1,2,2);plot(visualization);title('HoG Feature');

%% 
% person = 5;
% [hogFeature, visualization]= extractHOGFeatures(img);
% figure;
% subplot(1,2,1);imshow(img);title('Input Face');
% subplot(1,2,2);plot(visualization);title('HoG Feature');


%% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
title('Random Forest with HOG Features (Processed B Images)')