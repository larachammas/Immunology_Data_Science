close all 
clear all
clc 

load('Data/Results/Final_Stat_Sets_2/cumulativeStats_full_09_09');
%% plot the path of the cell as the x and y cooridnates of the cell centroid 
%for all cells 
%plus calculate the vector magnitudes and store 

vectorMagnitudes = []; 
xPoints = []; 
yPoints = [];

for i = 1: length(unique(cumulativeStats_full(:,2)))
    
    caseData = cumulativeStats_full(cumulativeStats_full(:,2)==i, :);
    
    [frameCount,n] = size(caseData);
    
    xPoints = caseData(:,21);
    yPoints = caseData(:,22);
    frames = caseData(:,3); 
    
%      figure;
%      plot(yPoints, xPoints) 
%      title(sprintf('%s Path', ElongationMetricsDir(i).name))

%      figure;
%      plot3(frames, xPoints, yPoints) 
%      title(sprintf('%s Path', ElongationMetricsDir(i).name))

    
% calculate the vector magnitutdes for all the directions for all the paths
%and store using plot_dir3.m function
    %figure;
    %title(sprintf('%s Vectors', ElongationMetricsDir(i).name))
    %[h1, h2, vPt, vPx, vPy] = plot_dir3( [1:frameCount]', xPoints, yPoints);
    [vPt, vPx, vPy] = plot_dir3_mod( [1:frameCount]', xPoints, yPoints);
    %store the caseNumber, the frameNumber, vPx values and vPy values in a
    %matrix 
    vectorMagnitudes = [vectorMagnitudes; repmat(i,(frameCount-1),1) frames(2:end) vPx vPy];
    
end 

[m,n] = size(vectorMagnitudes);

%label frames where the respective magnitude of the X and Y vector is
%larger than the mean X&Y vector for that video 

for row = 1:m 

    caseNumber = vectorMagnitudes(row,1);
    meanX = abs(mean(vectorMagnitudes(vectorMagnitudes(:,1)==caseNumber, 3))) ;
    meanY = abs(mean(vectorMagnitudes(vectorMagnitudes(:,1)==caseNumber, 4))) ;
    
    if abs(vectorMagnitudes(row,3)) > meanX
        vectorMagnitudes(row,5) = 1 ;
    else 
        vectorMagnitudes(row,5) = 0 ;
    end 

    if abs(vectorMagnitudes(row,4)) > meanY
        vectorMagnitudes(row,6) = 1 ;
    else 
        vectorMagnitudes(row,6) = 0 ;
    end                   
               
end

%% Mark as interested frame if both PvX and PvY are significant 
% for i = 1:length(vectorMagnitudes)
%     
%     if vectorMagnitudes(i,5) == 1.0000 & vectorMagnitudes(i,6) == 1.000
%         vectorMagnitudes(i,7) = 1;
%     else 
%         vectorMagnitudes(i,7) = 0;
%     end 
% end 

vectorLabels = {'case', 'Frame', 'PvX', 'PvY', 'PvX>Mean', 'PvY>Mean'};
%% 
filename =strcat('vectorMagnitudeChanges_',datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile, 'vectorMagnitudes', 'vectorLabels')
