%% Creating shape image datasets 

%% specify face photo path
imgFolders = '/Users/larachammas/OneDrive - City, University of London/IndividualProject/Data/ExtraLabeled/Labeled_PB2';

%% Creating Training and Testing DataStores 

%create an image data store
frames = imageDatastore(imgFolders,'FileExtensions', '.jpg','IncludeSubfolders', true, 'LabelSource', 'foldernames');

%count the number of samples in each label and find the minimum count value
counts = countEachLabel(frames);
minLabel = min(table2array(counts(:,2)));

%split each label to have the same number of images: the minimum amount
%that is found for all the labels 
frames = splitEachLabel(frames, minLabel, 'randomized');
[trainStore_PB, testStore_PB] = splitEachLabel(frames, 0.8, 'randomized');

%% make bag of features using image store data
bag_PB = bagOfFeatures(trainStore_PB); 

%make training feature vector
trainBag_PB = encode(bag_PB, trainStore_PB);

%make test feature vector
testBag_PB = encode(bag_PB, testStore_PB);

%% Create an image set 

%Create an image set 
faceSet = imageSet(imgFolders,'recursive');
minCount = min([faceSet.Count]); %find minimum 

%split datasets
imgSets = partition(faceSet, minCount, 'randomize'); 
[trainSet_PB,testSet_PB] = partition(imgSets,[0.8 0.2]);

%% Make HOG feature dataset using imageset 

%For all training images extract features and the corresponding labels
trainHogFeatures_PB =  [];
trainHogLabels_PB= {};
featureCount = 1;

for i=1:size(trainSet_PB,2)
    for j = 1:trainSet_PB(i).Count
        
        image = read(trainSet_PB(i),j); 
        
        %in matrix trainingFeatures, fill in the columns of the row = featureCount 
        %with the extracted HOG features of the image 
        trainHogFeatures_PB(featureCount,:) = extractHOGFeatures(image);
        
        %For the equivalent row number, fill it in with the image label 
        trainHogLabels_PB{featureCount} = trainSet_PB(i).Description;
        
        featureCount = featureCount + 1;
    end
end

%For all testing images extract features and the corresponding labels
testHogFeatures_PB =  [];
testHogLabels_PB = {};
testfeatureCount = 1;

for i=1:size(testSet_PB,2)
    for j = 1:testSet_PB(i).Count
     
        image = read(testSet_PB(i),j);
        
        testHogFeatures_PB(testfeatureCount,:) = extractHOGFeatures(image);
        
        testHogLabels_PB{testfeatureCount} = testSet_PB(i).Description;
        
        testfeatureCount = testfeatureCount + 1;
    end
end

%% Save features 

save('codeinProgress/model/data_Created/PB/trainStore_PB', 'trainStore_PB')
save('codeinProgress/model/data_Created/PB/testStore_PB', 'testStore_PB')

save('codeinProgress/model/data_Created/PB/trainSet_PB', 'trainSet_PB')
save('codeinProgress/model/data_Created/PB/testSet_PB', 'testSet_PB')

save('codeinProgress/model/data_Created/PB/bag_PB', 'bag_PB')
save('codeinProgress/model/data_Created/PB/trainBag_PB', 'trainBag_PB')
save('codeinProgress/model/data_Created/PB/testBag_PB', 'testBag_PB')

save('codeinProgress/model/data_Created/PB/trainHogFeatures_PB', 'trainHogFeatures_PB')
save('codeinProgress/model/data_Created/PB/trainHogLabels_PB', 'trainHogLabels_PB')

save('codeinProgress/model/data_Created/PB/testHogFeatures_PB', 'testHogFeatures_PB')
save('codeinProgress/model/data_Created/PB/testHogLabels_PB', 'testHogLabels_PB')