%close all 
%clear all
load('Data/Results/Elongation_Stats/CentroidcumulativeStats_2019_08_22.mat')
%% plot the path of the cell as the x and y cooridnates of the cell centroid 
%for all cells 

vectorMagnitudes_individual = []; 
xPoints = []; 
yPoints = [];

caseNumber = 327;
caseData = FinalStats_filtered_V4(FinalStats_filtered_V4.Video_Case==caseNumber, :);
    
[frameCount,n] = size(caseData);
    
xPoints = caseData{:,21};
yPoints = caseData{:,22};
frames = caseData{:,3}; 
%%    
figure;
plot(xPoints, yPoints) 
set(gca, 'Ydir', 'reverse')
title('X/Y plot of cell centroid with path tortuosity value of 22', 'fontsize', 15)
xlabel('X Centroid Position', 'fontsize', 14)
ylabel('Y Centroid Position', 'fontsize', 14)

%%
figure;
plot3(frames, xPoints, yPoints) 
set(gca, 'Ydir', 'reverse')
title('X/Y plot of cell centroid with path tortuosity value of 22', 'fontsize', 15)
xlabel('Frame Number', 'fontsize', 14)
ylabel('X Centroid Position', 'fontsize', 14)
zlabel('Y CentroidPosition', 'fontsize', 14)
%%    
% calculate the vector magnitutdes for all the directions for all the paths
%and store 
%using plot_dir3.m function

figure;
title(sprintf('%s Vectors', MetricsDir_full(caseNumber).name))
[h1, h2, vPt, vPx, vPy] = plot_dir3( [1:frameCount]', xPoints, yPoints);
%[vPt, vPx, vPy] = plot_dir3_mod( [1:frameCount]', xPoints, yPoints);
%store the caseNumber, the frameNumber, vPx values and vPy values in a
%matrix 
vectorMagnitudes_individual = [vectorMagnitudes_individual; repmat(caseNumber,(frameCount-1),1) frames(2:end) vPx vPy];


[m,n] = size(vectorMagnitudes_individual);

meanX_individual = abs(mean(vectorMagnitudes_individual(vectorMagnitudes_individual(:,1)==caseNumber, 3))) ;
meanY_individual = abs(mean(vectorMagnitudes_individual(vectorMagnitudes_individual(:,1)==caseNumber, 4))) ;

for row = 1:length(vectorMagnitudes_individual)
    
    if abs(vectorMagnitudes_individual(row,3)) > meanX_individual
        vectorMagnitudes_individual(row,5) = 1 ;

    else 
        vectorMagnitudes_individual(row,5) = 0 ;
    end 

    if abs(vectorMagnitudes_individual(row,4)) > meanY_individual
        vectorMagnitudes_individual(row,6) = 1 ;
    else 
        vectorMagnitudes_individual(row,6) = 0 ;
    end 
end 
