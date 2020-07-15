%% Investingating the properties of the cell during nuclear elongation moments 
%using elongation2 definition 

%read(elongation_FramePrevious.m)
load('elognation2.mat')

%% Data Extract and count 

%Subset Group 4 data
data4 = elongation2(elongation2.Group =='4',:);

G4_elong_Velocity = data4{data4.Elongation2 == '1', 4};
count_elong4 = length(G4_elong_Velocity)

G4_beforeElong_Velocity = data4{data4.Elongation2 == '2', 4};
count_beforeElong4 = length(G4_beforeElong_Velocity)

cells4 = length(unique(data4.Video_Case)) % Get number of group 4 cells analyzed

%Subset Group 5 data
data5 = elongation2(elongation2.Group =='5',:);

G5_elong_Velocity = data5{data5.Elongation2 == '1', 4};
count_elong5 = length(G5_elong_Velocity)

G5_beforeElong_Velocity = data5{data5.Elongation2 == '2', 4};
count_beforeElong5 = length(G5_beforeElong_Velocity)

cells5 = length(unique(data5.Video_Case)) %get number of group 2 cells analyzed

%% Comparing the velocity of elongation moments and non-elongated moments %%% 
%% T-test analysis of velocities Data 

%% Before and During in Group 4
% Calculate absolute Mean Values and their difference
G4_beforeElongMeanVel = mean(G4_beforeElong_Velocity)
G4_BeforElong_Median = median(G4_beforeElong_Velocity)

G4_elongMeanVel =  mean(G4_elong_Velocity)
G4_elong_Median = median(G4_elong_Velocity)

%Before and During in Group 4 ttest 
[h_velo_G1, pval_velo_G1, ci_velo_G1, stats_velo_G1] = ttest2(G4_elong_Velocity, G4_beforeElong_Velocity) 

%% Before and During in Group 5

% Calculate absolute Mean Values and their difference
G5_beforeElongMeanVel = mean(G5_beforeElong_Velocity)
G5_BeforElong_Median = median(G5_beforeElong_Velocity)

G5_elongMeanVel =  mean(G5_elong_Velocity)
G5_elong_Median = median(G5_elong_Velocity)

% ttest2 test for statistical difference 
[h_velo_G2, pval_velo_G2, ci_velo_G2, stats_velo_G2] = ttest2(G5_elong_Velocity, G5_beforeElong_Velocity) 

%% Before Group 4 vs Before Group 5 
[h_velo_elong, pval_velo_elong, ci_velo_elong, stats_velo_elong] = ttest2(G5_beforeElong_Velocity, G4_beforeElong_Velocity) 

%% During Group 4 vs Duribng Group 5  
[h_velo_before, pval_velo_before, ci_velo_before, stats_velo_before] = ttest2(G5_elong_Velocity, G4_elong_Velocity) 

%% Non-Parametric Version (Wilcoxn rank sum)

%Before and During in Group 1
[pval_velo_G1, hval_ci_velo_G1, stats_velo_G1] = ranksum(G4_elong_Velocity, G4_beforeElong_Velocity) 

% Before and During in Group 2
[pval_velo_G2,h_velo_G2, stats_velo_G2] = ranksum(G5_elong_Velocity, G5_beforeElong_Velocity) 

% Before Group 1 vs During Group 2 
[ pval_velo_before, h_velo_before, stats_velo_before] = ranksum(G5_beforeElong_Velocity, G4_beforeElong_Velocity) 

% Elong Group 1 vs Before Group 2 
[pval_velo_elong, h_velo_elong, stats_velo_elong] = ranksum(G5_elong_Velocity, G4_elong_Velocity) 

