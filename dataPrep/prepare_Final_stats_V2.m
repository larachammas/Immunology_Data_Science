clc 
close all
clear all

%% 
load('Results/Final_Stat_Sets_2/experimentalStats_Full_09_09.mat');
load('Results/Final_Stat_Sets_2/Full_changingAxis_09_10.mat');
load('Results/Final_Stat_Sets_2/vectorDirections_09_10.mat');
load('Results/Final_Stat_Sets_2/videoStats_raw_09_10.mat');
load('Results/Final_Stat_Sets_2/notingChange_filtered_09_10.mat');

%% Making the full dataset 

%%Labels 
experimentalLabels2 = {'Group','Video_Case','Time','C_Vel','N_Vel','C_numEndP',...
    'N_numEndP_Skel', 'N_numBranches_Skel','N_Major_Axis_um','C_Major_Axis_um',...
    'N_Min_Axis_um', 'C_Min_Axis_um','N_Min_Major_Axis','C_Min_Major_Axis',...
    'C_avTortuosity','C_skelAlignment','N_PositionR','C_Area_um2','N_Area_um2',...
    'N_C_A_Ratio', 'Centroid_X', 'Centroid_Y'}; 

FinalStats_full_labels = {'Group','Video_Case','Time','C_Vel','N_Vel','C_numEndP',...
    'N_numEndP_Skel', 'N_numBranches_Skel','N_Major_Axis_um','C_Major_Axis_um',...
    'N_Min_Axis_um', 'C_Min_Axis_um','N_Min_Major_Axis','C_Min_Major_Axis',...
    'C_avTortuosity','C_skelAlignment','N_PositionR','C_Area_um2','N_Area_um2',...
    'N_C_A_Ratio', 'Centroid_X', 'Centroid_Y', 'Pct_Change','Elongation',...
    'PvX','PvY','PvX_Mean','PvY_Mean'};

FinalStats_filtered_labels = {'Group','Video_Case','Time','C_Vel','N_Vel','C_numEndP',...
    'N_numEndP_Skel', 'N_numBranches_Skel','N_Major_Axis_um','C_Major_Axis_um',...
    'N_Min_Axis_um', 'C_Min_Axis_um','N_Min_Major_Axis','C_Min_Major_Axis',...
    'C_avTortuosity','C_skelAlignment','N_PositionR','C_Area_um2','N_Area_um2',...
    'N_C_A_Ratio', 'Centroid_X', 'Centroid_Y', 'Pct_Change','Elongation',...
    'PvX','PvY','PvX_Mean','PvY_Mean', 'Direction', 'Shape'};

%%
experimentalStats2 = array2table(experimentalStats, 'VariableNames', experimentalLabels2);
axisChanges2 = array2table(axisChanges(:,[3 4]), 'VariableNames',{'Pct_Change','Elongation'});
vectors_direction_final = cell2table(vectors_direction(:, [3 4 5 6 7]), 'VariableNames', {'PvX','PvY','PvX_Mean','PvY_Mean', 'Direction'}); 

FinalStats_full_V2 = [experimentalStats2 axisChanges2 vectors_direction_final];


%% 
filename =strcat('FinalStats_full_', datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile,'FinalStats_full', 'FinalStats_full_labels')

%% Complete the final edits to make FinalStats_filtered 

%Link up noting change vector with dataset 
FinalStats_full_V2 = addvars(FinalStats_full,changesVector(:,3));
%add variabel name 
FinalStats_full_V2.Properties.VariableNames{30} = 'Change_Direction'; 
%% Remove the rows with no cell velocity so that they 
% match up to the cell shape frames extracted  
tableA = FinalStats_full_V2(find(~isnan(FinalStats_full_V2.C_Vel)), :);
%goes from 15,683 to 15,433 rows 

%% Link up the cell shape dataset with this new table 
Shapes = videoStatsraw(:,4);
tableA = addvars(tableA,Shapes);

%% Filter to remove rows with Nans
tableA2 = tableA(find(~isnan(tableA.N_Vel)), :); %nuclear velocity 
%go from 15,433 to 15,381
tableA3 = tableA2(find(~isnan(tableA2.N_PositionR)), :); %nuclear velocity 
%goes from 15,381 to 15,318

%%
FinalStats_filtered_V4 = tableA3;

%% Make things categorical 
FinalStats_filtered_V4.Direction = categorical(FinalStats_filtered_V4.Direction);
FinalStats_filtered_V4.Shapes = categorical(FinalStats_filtered_V4.Shapes); 
FinalStats_filtered_V4.Elongation = categorical(FinalStats_filtered_V4.Elongation); 
FinalStats_filtered_V4.Change_Direction = categorical(FinalStats_filtered_V4.Change_Direction); 
FinalStats_filtered_V4.Group = categorical(FinalStats_filtered_V4.Group); 


%%
filename =strcat('FinalStats_filtered_V4_', datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile,'FinalStats_filtered_V4', 'FinalStats_filtered_labels')