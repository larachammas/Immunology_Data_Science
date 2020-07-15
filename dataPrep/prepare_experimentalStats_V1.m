%% Create dataset for training classification model 

%% Clear all variables and close all figures
clear all
close all
clc

%% Read the files that have been stored in the current folder
if strcmp(filesep,'/')
    % Running in Mac
    load('/Users/larachammas/OneDrive - City, University of London/IndividualProject/Data/DataARC_Datasets_2019_05_03.mat')
    cd ('/Users/larachammas/OneDrive - City, University of London/IndividualProject/Data/')
    baseDir                             = 'metrics/';
end
% Calculate the number of files, as of February 2019 there were 315 valid
% files
experimentalMetricsDir                          = dir(strcat(baseDir,'*.mat'));
numMetrics                          = size(experimentalMetricsDir,1);

%% Calculate a vector for injured non-injured and groups
% This will be used to create groups for 
GroupCell(numMetrics,1)=0;
%This loop is necessary as the order of the files and the DataARC may not
%be the same
for k=1: numMetrics
    % Load the current file to be displayed
    caseName                = experimentalMetricsDir(k).name;
    currTrack               = strcat(baseDir,caseName);
    caseNumber              = 1;
    for counterCase         = 1:size(DataARC_Datasets,1)
        if strcmp(DataARC_Datasets{counterCase,2}(12:end-1),caseName(1:end-19))
            caseNumber      = counterCase;
        end
    end
    GroupCell(k,1) = DataARC_Datasets{caseNumber,21};
end

%% read all files and accummulate the stats
experimentalStats        =[[] []];
X = NaN([1 2]);

for currentCase=1: numMetrics
    clear cent* min* max* rr cc relP* jet*
    % Load the current file to be displayed
    load(strcat(baseDir,experimentalMetricsDir(currentCase).name));
    qqq{currentCase}= experimentalMetricsDir(currentCase).name;
    numCurrFrames               = size(nuclei_metrics,2);
   
    % calculate the stats of the current video In the Following Order:
    % 1 GROUP, 1-non injured, etc
    % 2 CASE, i.e. the order of the files
    % 3 Time point
    
    clear cumulativeStatsCurr
    
    cell_centroids = [];
        
        for i = 1:length(cell_metrics)
            if  isnan(cell_metrics(i).Centroid)
                values = X;
            else 
                values = [cell_metrics(i).Centroid];
            end 
            cell_centroids = [cell_centroids; values];
        end 
        
        cumulativeStatsCurr(:,1:2)     =   ones(numCurrFrames,1)*[GroupCell(currentCase) currentCase];
        cumulativeStatsCurr(:,3)       =   [1:numCurrFrames]'  ;
        cumulativeStatsCurr(:,4)       =   [cell_metrics.Dist_um_s]';
        cumulativeStatsCurr(:,5)       =   [nuclei_metrics.Dist_um_s]';
        cumulativeStatsCurr(:,6)       =   [cell_metrics.numEndP]';
        cumulativeStatsCurr(:,7)       =   [nuclei_metrics.numEndP_Skel]';
        cumulativeStatsCurr(:,8)       =   [nuclei_metrics.numBranches_Skel]';
        cumulativeStatsCurr(:,9)       =   [nuclei_metrics.MajAxis_um]';
        cumulativeStatsCurr(:,10)      =   [cell_metrics.MajAxis_um]';
        
        
        cumulativeStatsCurr(:,11)      =   [nuclei_metrics.MinAxis_um]';
        cumulativeStatsCurr(:,12)      =   [cell_metrics.MinAxis_um]';
        
        cumulativeStatsCurr(:,13)      =   [nuclei_metrics.Min_MajAxis]';
        cumulativeStatsCurr(:,14)      =   [cell_metrics.Min_MajAxis]';
        
        cumulativeStatsCurr(:,15)      =   [cell_metrics.avTortuosity]';
        
        cumulativeStatsCurr(:,16)      =   [cell_metrics.skelAlignment]';
        
        cumulativeStatsCurr(:,17)      =   [nuclei_metrics.PositionR]';
        
        cumulativeStatsCurr(:,18)      =   [cell_metrics.Area_um_2]';
        cumulativeStatsCurr(:,19)      =   [nuclei_metrics.Area_um_2]';
        
        cumulativeStatsCurr(:,20)      =   cumulativeStatsCurr(:,19)./cumulativeStatsCurr(:,18);
        
        cumulativeStatsCurr(:,21)      =   [cell_centroids(:,1)];
        cumulativeStatsCurr(:,22)      =   [cell_centroids(:,2)];

    experimentalStats            = [ experimentalStats; cumulativeStatsCurr];
end


%%
experimentalLabels={'group','case','time','C Dist[um/s]','N Dist[um/s]', 'C numEndP', 'N numEndP_Skel', 'N numBranches_Skel', ...
    'N Major Axis [um]', 'C Major Axis [um]', 'N Min Axis [um]', 'C Min Axis [um]','N Min_Major Axis', ...
    'C Min_Major Axis', 'C avTortuosity', 'C skelAlignment', 'N PositionR',  ...
    'C Area [um2]','N Area [um2]','Area N/Area C', 'Centroids_X', 'Centroids_Y'}; 

%% Remove the first time step 

experimentalStats(experimentalStats(:,3)==1,:)=[];

%%
filename =strcat('experimentalStats_Full_', datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile,'experimentalStats', 'experimentalLabels', 'experimentalMetricsDir')

