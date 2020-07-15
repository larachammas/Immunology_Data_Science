%% Creating shape image datasets 

%% specify face photo path
imgFolders = '/Users/larachammas/OneDrive - City, University of London/IndividualProject/Data/ExtraLabeled/Labeled_Raw_a';

%% Creating Training and Testing Sets

%create an image data store
frames = imageDatastore(imgFolders,'FileExtensions', '.jpg','IncludeSubfolders', true, 'LabelSource', 'foldernames');

%count the number of samples in each label and find the minimum count value
countsA = countEachLabel(frames);
minLabel = min(table2array(counts(:,2)));

%split each label to have the same number of images: the minimum amount
%that is found for all the labels 
frames = splitEachLabel(frames, minLabel, 'randomized');
[trainStore_RA, testStore_RA] = splitEachLabel(frames, 0.8, 'randomized');

%% make bag of features using image store data
bag_RB = bagOfFeatures(trainStore_RA); 

%make training feature vector
trainBag_RB = encode(bag_RB, trainStore_RA);

%make test feature vector
testBag_RB = encode(bag_RB, testStore_RA);

%% Create an image set 

%Create an image set 
faceSet = imageSet(imgFolders,'recursive');
minCount = min([faceSet.Count]); %find minimum 

%split datasets
imgSets = partition(faceSet, minCount, 'randomize'); 
[trainSet_RB,testSet_RB] = partition(imgSets,[0.8 0.2]);

%% Make HOG feature dataset using imageset 

%For all training images extract features and the corresponding labels
trainHogFeatures_RB =  [];
trainHogLabels_RB= {};
featureCount = 1;

for i=1:size(trainSet_RB,2)
    for j = 1:trainSet_RB(i).Count
        
        image = read(trainSet_RB(i),j); 
        
        %in matrix trainingFeatures, fill in the columns of the row = featureCount 
        %with the extracted HOG features of the image 
        trainHogFeatures_RB(featureCount,:) = extractHOGFeatures(image);
        
        %For the equivalent row number, fill it in with the image label 
        trainHogLabels_RB{featureCount} = trainSet_RB(i).Description;
        
        featureCount = featureCount + 1;
    end
end

%For all testing images extract features and the corresponding labels
testHogFeatures_RB =  [];
testHogLabels_RB = {};
testfeatureCount = 1;

for i=1:size(testSet_RB,2)
    for j = 1:testSet_RB(i).Count
     
        image = read(testSet_RB(i),j);
        
        testHogFeatures_RB(testfeatureCount,:) = extractHOGFeatures(image);
        
        testHogLabels_RB{testfeatureCount} = testSet_RB(i).Description;
        
        testfeatureCount = testfeatureCount + 1;
    end
end

%% Save features 

% save('codeinProgress/model/data/Raw_B/trainStore_RB', 'trainStore_RB')
% save('codeinProgress/model/data/Raw_B/testStore_RB', 'testStore_RB')
% 
% save('codeinProgress/model/data/Raw_B/trainSet_RB', 'trainSet_RB')
% save('codeinProgress/model/data/Raw_B/testSet_RB', 'testSet_RB')
% 
% save('codeinProgress/model/data/Raw_B/bag_RB', 'bag_RB')
% save('codeinProgress/model/data/Raw_B/trainBag_RB', 'trainBag_RB')
% save('codeinProgress/model/data/Raw_B/testBag_RB', 'testBag_RB')
% 
% save('codeinProgress/model/data/Raw_B/trainHogFeatures_RB', 'trainHogFeatures_RB')
% save('codeinProgress/model/data/Raw_B/trainHogLabels_RB', 'trainHogLabels_RB')
% 
% save('codeinProgress/model/data/Raw_B/testHogFeatures_RB', 'testHogFeatures_RB')
% save('codeinProgress/model/data/Raw_B/testHogLabels_RB', 'testHogLabels_RB')