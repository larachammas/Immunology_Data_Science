%% Train a random forest using bag of surf features from the Raw_A images 

% References 
%https://www.mathworks.com/help/stats/treebagger-class.html
%https://www.mathworks.com/matlabcentral/fileexchange/60900-multi-class-confusion-matrix?focused=7974025&tab=example&w.mathworks.com

%% Load data 

load('codeinProgress/model/data/Raw_A/trainBag_RA');
load('codeinProgress/model/data/Raw_A/testBag_RA');
load('codeinProgress/model/data/Raw_A/bag_RA');
load('codeinProgress/model/data/Raw_A/trainStore_RA');
load('codeinProgress/model/data/Raw_A/testStore_RA');

trainBagLabels_RA = str2double(string(trainStore_RA.Labels));
testBagLabels_RA = str2double(string(testStore_RA.Labels));

%% Tuning parameters 

%array with values of number of trees for the forrest 
numTree = [1, 20 , 40 , 60 , 80 , 100, 120, 140, 160, 180, 200] ; 

%array of values to try for minimum number of observations per tree leaf
minLeaf = [1:10]; 

%initalize arrays to hold values created in loops 
Parameters = [];
ErrorsBag = [] ;   
AccuracyBag = [] ; 
ErrorAllTable = [] ;
Final_bag_RA_Array = table ;

%% Grid Search 
for i = 1:length(numTree)
    
    i
    
    for j = 1:length(minLeaf)
        
        Model_bag_RA = TreeBagger(numTree(i), trainBag_RA, trainBagLabels_RA, 'OOBPrediction', 'on', 'minLeafSize', minLeaf(j), 'Method', 'classification');

        %input the parameters tested into an array
        Parameters = [Parameters; numTree(i), minLeaf(j)] ;
        
        %generate the error (or the misclassification probability) for each
        %model for out-of-bag observations in the training data 
        %using ensemble to calculate an average for all the trees in that
        %model
        
        model_error = oobError(Model_bag_RA, 'Mode', 'Ensemble') ; 
        
        Error_all_bag = oobError(Model_bag_RA); %generate the errors for each of the trees in the model for plotting
      
        %input the oobError values into an array
        ErrorsBag = [ErrorsBag; model_error];
        
        ErrorAllTable = [ErrorAllTable ; Error_all_bag];
        
       %use the trained model to predict classes on the out of bag
       %observations stored in the model
       [BagRA_predicted_labels,scores]= oobPredict(Model_bag_RA);
       
       BagRA_predictedLabels = str2double(string(BagRA_predicted_labels));
       
       %generate the confusion matrix from the ooBPredict output 
       Bag_RA_CM= confusionmat(trainBagLabels_RA ,BagRA_predictedLabels);
        
       %calculate the accuracy of the model using the confusion matrix 
       Accuracy_model = 100*sum(diag(Bag_RA_CM))./sum(Bag_RA_CM(:));
       
       %store the model accuracy values in an array
       AccuracyBag = [AccuracyBag; Accuracy_model] ; 
       
       %join the parameters test and the model error and accuracy in a row
       %in an array 
       Final_bag_RA_Array = [Parameters ErrorsBag AccuracyBag] ; 
    %end
     end 
end 

%% Extract best model parameters 

%transform the array to a table
Final_bag_RA_Array = array2table(Final_bag_RA_Array) ; 
%assign column names to table
Final_bag_RA_Array.Properties.VariableNames = {'NumTrees', 'NumLeaves' ,  'oobErrorValue', 'AccuracyValue'} ; 

% find the minimum model error
min_error = min(Final_bag_RA_Array{:,3}) %find the minimum error for all the models 

%find the highest model accuracy 
highestAccuracy = max(Final_bag_RA_Array{:,4})

%find the model row with the highest accuracy and what its parameters are 
best_model_bag_RA_parameters = Final_bag_RA_Array(Final_bag_RA_Array.AccuracyValue == highestAccuracy, :)

%% Save tuned models 
save('codeinProgress/model/data/Raw_A/Final_bag_RA_Array', 'Final_bag_RA_Array')
save('codeinProgress/model/data/Raw_A/bag_best_parameters', 'best_model_bag_RA_parameters')
save('codeinProgress/model/data/Raw_A/tuning_Rf_Hog/Error_all_bag', 'Error_all_bag')

%% Train a new model using the parameters 
numtrees = best_model_bag_RA_parameters{1,1} ; 
numLeaves = best_model_bag_RA_parameters{1,2};

rfBag_RA_Final = TreeBagger(numtrees, trainBag_RA, trainBagLabels_RA, 'OOBPrediction', 'on', 'minLeafSize', numLeaves, 'Method', 'classification');

%% 
save('codeinProgress/model/data/Raw_A/rfBag_RA_Model', 'rfBag_RA_Final')

%% Test the model using predict and the testing dataset 
[BagRA_predicted_labels,scores]= predict(rfBag_RA_Final, testBag_RA);

Bag_RA_predicted = str2double(string(BagRA_predicted_labels));

%Generate evluation metrics using confusion.m
[RfBag_RA_matrix, RfBag_RA_Result, RfBag_RA_ReferenceResult] = confusion.getMatrix(testBagLabels_RA,Bag_RA_predicted)

%Print confusion matrix 
figure;
cmRFHog = confusionchart(testBagLabels_RA,Bag_RA_predicted );
title('RF with Bag on Raw A Images Confusion Chart')

%% Figures 
% plot the out of bag classification error for the number of trees grown
%during tuning 
figure;
plot(Error_all_bag)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
title('Random Forest with BAG of SURF Features (Raw A Images)')