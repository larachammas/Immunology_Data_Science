%% Redoing direction analysis of groups 1 & 2
%Using elongation2 defintiion 
%% Data Extract and count 
load('elongation2.mat')
%Group 4 
data4 = elongation2(elongation2.Group =='4',:);

elong4 = data4(data4.Elongation2 == '1', :);
beforeElong1 = data4(data4.Elongation2 == '2', :);

countElong4 = height(elong4)
countBeforeElong4 = height(beforeElong1)

cells4 = length(unique(data4.Video_Case)) % Get number of cells analyzed

% Group 2
data5 = elongation2(elongation2.Group =='5',:);

elong5 = data5(data5.Elongation2 == '1', :);
beforeElong5 = data5(data5.Elongation2 == '2', :);

countElong5 = height(elong5)
countBeforeElong5 = height(beforeElong5)

cells5 = length(unique(data5.Video_Case)) % Get number of cells analyzed

% Counts for change in direction 
dataBoth = [data4;data5];
bothNoChange = height(dataBoth(dataBoth.Change_Direction == '0', :))
bothChange = height(dataBoth(dataBoth.Change_Direction == '1', :))

noChange4 = height(data4(data4.Change_Direction == '0', :))
Change4 = height(data4(data4.Change_Direction == '1', :))

noChange5 = height(data5(data5.Change_Direction == '0', :))
Change5 = height(data5(data5.Change_Direction == '1', :))

%% GROUP 4: How often does elongation match change in direction? GROUP 4

%Count How many elong events with change 
countElong_C = height(elong4(elong4.Change_Direction=='1', :));
countbeforeElong_C = height(beforeElong1(beforeElong1.Change_Direction=='1', :));
countElong_NC = height(elong4(elong4.Change_Direction=='0', :));
countbeforeElong_NC = height(beforeElong1(beforeElong1.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countbeforeElong_NC], [countElong_C; countbeforeElong_C], ...
    'rowNames', {'Group 4 Elong', 'Group 4 beforeElong'}, 'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% GROUP 5: How often does elongation match change in direction? GROUP 5

%Count How many elong events with change 
countElong_C = height(elong5(elong5.Change_Direction=='1', :));
countbeforeElong_C = height(beforeElong5(beforeElong5.Change_Direction=='1', :));
countElong_NC = height(elong5(elong5.Change_Direction=='0', :));
countbeforeElong_NC = height(beforeElong5(beforeElong5.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countbeforeElong_NC], [countElong_C; countbeforeElong_C], ...
    'rowNames', {'Group 5 Elong', 'Group 5 beforeElong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% BOTH GROUPS: How often does elongation match change in direction? GROUP 1
dataElong = dataBoth(dataBoth.Elongation2 == '1',:);
databE = dataBoth(dataBoth.Elongation2 == '2',:);

%Count How many elong events with change 
countElong_C = height(dataElong(dataElong.Change_Direction=='1', :));
countbeforeElong_C = height(databE(databE.Change_Direction=='1', :));
countElong_NC = height(dataElong(dataElong.Change_Direction=='0', :));
countbeforeElong_NC = height(databE(databE.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countbeforeElong_NC], [countElong_C; countbeforeElong_C], ...
    'rowNames', {'Groups 4&5 Elong', 'Groups 4&5 beforeElong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%%
%%%%%%% VELOCITY NOW %%%%%%%%%

%% Group 4: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean4 = mean(data4{data4.Change_Direction=='0', 4})
nochangeVelMedian4 = median(data4{data4.Change_Direction=='0', 4})

changeVelMean4 = mean(data4{data4.Change_Direction=='1', 4})
changeVelMedian4 = median(data4{data4.Change_Direction=='1', 4})

differencechangeVelMean4 = changeVelMean4 - nochangeVelMean4  

% ttest2 test for statistical difference
[h_VelChange1, pval_VelChange1, ci_veloChange1 ,stats_VelChange1] = ttest2(data4{data4.Change_Direction=='0', 4}, data4{data4.Change_Direction=='1', 4})

%Wilcoxon rank sum test 
[pval, hval, stats] = ranksum(data4{data4.Change_Direction=='0', 4}, data4{data4.Change_Direction=='1', 4})

%% Group 5: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean5 = mean(data5{data5.Change_Direction=='0', 4})
nochangeVelMedian5 = median(data5{data5.Change_Direction=='0', 4})

changeVelMean5 = mean(data5{data5.Change_Direction=='1', 4})
changeVelMedian5 = median(data5{data5.Change_Direction=='1', 4})

differencechangeVelMean5 = changeVelMean5 - nochangeVelMean5 

% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(data5{data5.Change_Direction=='0', 4}, data5{data5.Change_Direction=='1', 4})


%Wilcox
[pval, hval, stats] = ranksum(data5{data5.Change_Direction=='0', 4}, data5{data5.Change_Direction=='1', 4})
%% GROUPS 4&5 COMBINED: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean = mean(dataBoth{dataBoth.Change_Direction=='0', 4})
nochangeVelMedian = median(dataBoth{dataBoth.Change_Direction=='0', 4})

changeVelMean = mean(dataBoth{dataBoth.Change_Direction=='1', 4})
changeVelMedian = median(dataBoth{dataBoth.Change_Direction=='1', 4})

differencechangeVelMean = changeVelMean - nochangeVelMean 

% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(dataBoth{dataBoth.Change_Direction=='0', 4}, dataBoth{dataBoth.Change_Direction=='1', 4})
%Wilcox
[pval, hval, stats] = ranksum(dataBoth{dataBoth.Change_Direction=='0', 4}, dataBoth{dataBoth.Change_Direction=='1', 4})
%% Group 4 v 5: Velocity without change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = nochangeVelMean5 - nochangeVelMean4 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data4{data4.Change_Direction=='0', 4}, data5{data5.Change_Direction=='0', 4})

[pval, hval, stats] = ranksum(data4{data4.Change_Direction=='0', 4}, data5{data5.Change_Direction=='0', 4})
%% Group 4 v 5: Velocity with change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = changeVelMean5 - changeVelMean4 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data4{data4.Change_Direction=='1', 4}, data5{data5.Change_Direction=='1', 4})

% wilcoxon test for statistical difference
[pval, hval ,stats] = ranksum(data4{data4.Change_Direction=='1', 4}, data5{data5.Change_Direction=='1', 4})
