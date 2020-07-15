%% Train a random forest using hog features from the Raw_A images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data/Raw_B/trainHogFeatures_RB');
load('codeinProgress/model/data/Raw_B/testHogFeatures_RB');
load('codeinProgress/model/data/Raw_B/trainHogLabels_RB');
load('codeinProgress/model/data/Raw_B/testHogLabels_RB');

trainHogLabels_RB = str2double(string(trainHogLabels_RB));
testHogLabels_RB = str2double(string(testHogLabels_RB));

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
Final_hog_RB_Array = table ;

%% Grid Search 
for i = 1:length(numTree)
    
    i 
    
    for j = 1:length(minLeaf)
        
        Model_hog_RB = TreeBagger(numTree(i), trainHogFeatures_RB, trainHogLabels_RB, 'OOBPrediction', 'on', 'minLeafSize', minLeaf(j), 'Method', 'classification');

        %input the parameters tested into an array
        Parameters = [Parameters; numTree(i), minLeaf(j)] ;
        
        %generate the error (or the misclassification probability) for each
        %model for out-of-bag observations in the training data 
        %using ensemble to calculate an average for all the trees in that
        %model
        model_error = oobError(Model_hog_RB, 'Mode', 'Ensemble') ; 
        
        Error_all = oobError(Model_hog_RB); %generate the errors for each of the trees in the model for plotting
      
        %input the oobError values into an array
        Errors = [Errors; model_error];
        
        ErrorAllTable = [ErrorAllTable ; Error_all];
        
       %use the trained model to predict classes on the out of bag
       %observations stored in the model
       [HogRB_predicted_labels,scores]= oobPredict(Model_hog_RB);
       
       HogRB_predictedLabels = str2double(string(HogRB_predicted_labels));
       
       %generate the confusion matrix from the ooBPredict output 
       Hog_RB_CM= confusionmat(trainHogLabels_RB ,HogRB_predictedLabels);
        
       %calculate the accuracy of the model using the confusion matrix 
       Accuracy_model = 100*sum(diag(Hog_RB_CM))./sum(Hog_RB_CM(:));
       
       %store the model accuracy values in an array
       Accuracy = [Accuracy; Accuracy_model] ; 
       
       %join the parameters test and the model error and accuracy in a row
       %in an array 
       Final_hog_RB_Array = [Parameters Errors Accuracy] ; 
    %end
     end 
end 

%% Extract best model parameters 

%transform the array to a table
Final_hog_RB_Array = array2table(Final_hog_RB_Array) ; 
%assign column names to table
Final_hog_RB_Array.Properties.VariableNames = {'NumTrees', 'NumLeaves' ,  'oobErrorValue', 'AccuracyValue'} ; 

%find the minimum model error
min_error = min(Final_hog_RB_Array{:,3}) %find the minimum error for all the models 

%find the highest model accuracy 
highestAccuracy = max(Final_hog_RB_Array{:,4})

%find the model row with the highest accuracy and what its parameters are 
best_model_hog_RB_features = Final_hog_RB_Array(Final_hog_RB_Array.AccuracyValue == highestAccuracy, :)

%% Save tuned models 
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/Final_hog_RB_Array', 'Final_hog_RB_Array')
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/hog_best_features', 'best_model_hog_RB_features')
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/Error_all', 'Error_all')

%% Train a new model using the parameters 
numtrees = best_model_hog_RB_features{:,1} ; 
numLeaves = best_model_hog_RB_features{:,2};

rfHog_RB_Final = TreeBagger(numtrees, trainHogFeatures_RB, trainHogLabels_RB, 'OOBPrediction', 'on', 'minLeafSize', numLeaves, 'Method', 'classification');

%% 
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/rfHog_RB_Final', 'rfHog_RB_Final')

%% Test the model using predict and the testing dataset 
[HogRB_predicted_labels,scores]= predict(rfHog_RB_Final, testHogFeatures_RB);

HOG_RB_predicted = str2double(string(HogRB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfHog_RB_matrix, RfHog_RB_Result, RfHog_RB_ReferenceResult] = confusion.getMatrix(testHogLabels_RB,HOG_RB_predicted)

%Print confusion matrix 
figure;
cmRFHog = confusionchart(testHogLabels_RB,HOG_RB_predicted );
title('RF with HOG on Raw B Images Confusion Chart')

%%
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/RfHog_RB_matrix', 'RfHog_RB_matrix')
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/RfHog_RB_Result', 'RfHog_RB_Result')
save('codeinProgress/model/data/Raw_B/tuning_Rf_hog/RfHog_RB_ReferenceResult', 'RfHog_RB_ReferenceResult')

%% Figures 

%Extracting and display Histogram of Oriented Gradient Features for a single face
person = 5;
[hogFeature, visualization]= extractHOGFeatures(read(trainSet_RB(person),1));
figure;
subplot(1,2,1);imshow(read(trainSet_RB(person),1));title('Input Face');
subplot(1,2,2);plot(visualization);title('HoG Feature');

%% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
title('Random Forest with HOG Features (Raw B Images)')