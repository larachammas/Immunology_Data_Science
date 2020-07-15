%% Train a random forest using bag of surf features from the Raw_A images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data/Raw_B/trainBag_RB');
load('codeinProgress/model/data/Raw_B/testBag_RB');
load('codeinProgress/model/data/Raw_B/bag_RB');
load('codeinProgress/model/data/Raw_B/trainStore_RB');
load('codeinProgress/model/data/Raw_B/testStore_RB');

trainBagLabels_RB = str2double(string(trainStore_RB.Labels));
testBagLabels_RB = str2double(string(testStore_RB.Labels));

%% Tuning parameters 

%array with values of number of trees for the forrest 
numTree = [1, 20 , 40 , 60 , 80 , 100, 120, 140, 160, 180, 200] ; 

%array of values to try for minimum number of observations per tree leaf
minLeaf = [1:10]; 

%initalize arrays to hold values created in loops 
Parameters = [];
ErrorsBag_RB = [] ;   
AccuracyBag = [] ; 
ErrorAllTable = [] ;
Final_bag_RB_Array = table ;

%% Grid Search 
for i = 1:length(numTree)
    
    i
    
    for j = 1:length(minLeaf)
        
        Model_bag_RB = TreeBagger(numTree(i), trainBag_RB, trainBagLabels_RB, 'OOBPrediction', 'on', 'minLeafSize', minLeaf(j), 'Method', 'classification');

        %input the parameters tested into an array
        Parameters = [Parameters; numTree(i), minLeaf(j)] ;
        
        %generate the error (or the misclassification probability) for each
        %model for out-of-bag observations in the training data 
        %using ensemble to calculate an average for all the trees in that
        %model
        
        model_error = oobError(Model_bag_RB, 'Mode', 'Ensemble') ; 
        
        Error_all_bag_RB = oobError(Model_bag_RB); %generate the errors for each of the trees in the model for plotting
      
        %input the oobError values into an array
        ErrorsBag_RB = [ErrorsBag_RB; model_error];
        
        ErrorAllTable = [ErrorAllTable ; Error_all_bag_RB];
        
       %use the trained model to predict classes on the out of bag
       %observations stored in the model
       [BagRB_predicted_labels,scores]= oobPredict(Model_bag_RB);
       
       BagRB_predictedLabels = str2double(string(BagRB_predicted_labels));
       
       %generate the confusion matrix from the ooBPredict output 
       Bag_RB_CM= confusionmat(trainBagLabels_RB ,BagRB_predictedLabels);
        
       %calculate the accuracy of the model using the confusion matrix 
       Accuracy_model = 100*sum(diag(Bag_RB_CM))./sum(Bag_RB_CM(:));
       
       %store the model accuracy values in an array
       AccuracyBag = [AccuracyBag; Accuracy_model] ; 
       
       %join the parameters test and the model error and accuracy in a row
       %in an array 
       Final_bag_RB_Array = [Parameters ErrorsBag_RB AccuracyBag] ; 
    %end
     end 
end 

%% Extract best model parameters 

%transform the array to a table
Final_bag_RB_Array = array2table(Final_bag_RB_Array) ; 
%assign column names to table
Final_bag_RB_Array.Properties.VariableNames = {'NumTrees', 'NumLeaves' ,  'oobErrorValue', 'AccuracyValue'} ; 

% find the minimum model error
min_error = min(Final_bag_RB_Array{:,3}) %find the minimum error for all the models 

%find the highest model accuracy 
highestAccuracy = max(Final_bag_RB_Array{:,4})

%find the model row with the highest accuracy and what its parameters are 
best_model_bag_RB_parameters = Final_bag_RB_Array(Final_bag_RB_Array.AccuracyValue == highestAccuracy, :)

%% Save tuned models 
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/Final_bag_RB_Array', 'Final_bag_RB_Array')
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/bag_best_parameters', 'best_model_bag_RB_parameters')
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/Error_all_bag_RB', 'Error_all_bag_RB')

%% Train a new model using the parameters 
numtrees = best_model_bag_RB_parameters{1,1} ; 
numLeaves = best_model_bag_RB_parameters{1,2};

rfBag_RB_Final = TreeBagger(numtrees, trainBag_RB, trainBagLabels_RB, 'OOBPrediction', 'on', 'minLeafSize', numLeaves, 'Method', 'classification');

%% 
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/rfBag_RB_Model', 'rfBag_RB_Final')

%% Test the model using predict and the testing dataset 
[BagRB_predicted_labels,scores]= predict(rfBag_RB_Final, testBag_RB);

Bag_RB_predicted = str2double(string(BagRB_predicted_labels));

%Generate evluation metrics using confusion.m
[RfBag_RB_matrix, RfBag_RB_Result, RfBag_RB_ReferenceResult] = confusion.getMatrix(testBagLabels_RB,Bag_RB_predicted)

%Print confusion matrix 
figure;
cmRFHog = confusionchart(testBagLabels_RB,Bag_RB_predicted );
title('RF with Bag on Raw B Images Confusion Chart')

%%
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/RfBag_RB_matrix', 'RfBag_RB_matrix')
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/RfBag_RB_Result', 'RfBag_RB_Result')
save('codeinProgress/model/data/Raw_B/tuning_Rf_bag/RfBag_RB_ReferenceResult', 'RfBag_RB_ReferenceResult')
%% Figures 
% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all_bag_RB)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
title('Random Forest with BAG of SURF Features (Raw B Images)')