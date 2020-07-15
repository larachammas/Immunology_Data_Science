%% Redoing direction analysis of groups 1 & 2
%Using elongation2 defintiion 
%% Data Extract and count 
load('elongation2.mat')
%Group1 
data1 = elongation2(elongation2.Group =='1',:);

elong1 = data1(data1.Elongation2 == '1', :);
beforeElong1 = data1(data1.Elongation2 == '2', :);

countElong1 = height(elong1)
countBeforeElong1 = height(beforeElong1)

cells1 = length(unique(data1.Video_Case)) % Get number of cells analyzed

% Group 2
data2 = elongation2(elongation2.Group =='2',:);

elong2 = data2(data2.Elongation2 == '1', :);
beforeElong2 = data2(data2.Elongation2 == '2', :);

countElong2 = height(elong2)
countBeforeElong2 = height(beforeElong2)

cells2 = length(unique(data2.Video_Case)) % Get number of cells analyzed

% Counts for change in direction 
dataBoth = [data1;data2];
bothNoChange = height(dataBoth(dataBoth.Change_Direction == '0', :))
bothChange = height(dataBoth(dataBoth.Change_Direction == '1', :))

noChange1 = height(data1(data1.Change_Direction == '0', :))
Change1 = height(data1(data1.Change_Direction == '1', :))

noChange2 = height(data2(data2.Change_Direction == '0', :))
Change2 = height(data2(data2.Change_Direction == '1', :))

%% GROUP 1: How often does elongation match change in direction? GROUP 1

%Count How many elong events with change 
countElong_C = height(elong1(elong1.Change_Direction=='1', :));
countbeforeElong_C = height(beforeElong1(beforeElong1.Change_Direction=='1', :));
countElong_NC = height(elong1(elong1.Change_Direction=='0', :));
countbeforeElong_NC = height(beforeElong1(beforeElong1.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countbeforeElong_NC], [countElong_C; countbeforeElong_C], ...
    'rowNames', {'Group 1 Elong', 'Group 1 beforeElong'}, 'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% GROUP 2: How often does elongation match change in direction? GROUP 1

%Count How many elong events with change 
countElong_C = height(elong2(elong2.Change_Direction=='1', :));
countbeforeElong_C = height(beforeElong2(beforeElong2.Change_Direction=='1', :));
countElong_NC = height(elong2(elong2.Change_Direction=='0', :));
countbeforeElong_NC = height(beforeElong2(beforeElong2.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countbeforeElong_NC], [countElong_C; countbeforeElong_C], ...
    'rowNames', {'Group 2 Elong', 'Group 2 beforeElong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% BOTH GROUPS: How often does elongation match change in direction? GROUP 1
dataBoth = [data1;data2];
dataElong = dataBoth(dataBoth.Elongation2 == '1',:);
databE = dataBoth(dataBoth.Elongation2 == '2',:);

%Count How many elong events with change 
countElong_C = height(dataElong(dataElong.Change_Direction=='1', :));
countbeforeElong_C = height(databE(databE.Change_Direction=='1', :));
countElong_NC = height(dataElong(dataElong.Change_Direction=='0', :));
countbeforeElong_NC = height(databE(databE.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([co1untElong_NC; countbeforeElong_NC], [countElong_C; countbeforeElong_C], ...
    'rowNames', {'Groups 1&2 Elong', 'Groups 1&2 beforeElong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%%
%%%%%%% VELOCITY NOW %%%%%%%%%

%% Group 1: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean1 = mean(data1{data1.Change_Direction=='0', 4})
nochangeVelMedian1 = median(data1{data1.Change_Direction=='0', 4})

changeVelMean1 = mean(data1{data1.Change_Direction=='1', 4})
changeVelMedian1 = median(data1{data1.Change_Direction=='1', 4})

differencechangeVelMean1 = changeVelMean1 - nochangeVelMean1  
...........20
% ttest2 test for statistical difference
[h_VelChange1, pval_VelChange1, ci_veloChange1 ,stats_VelChange1] = ttest2(data1{data1.Change_Direction=='0', 4}, data1{data1.Change_Direction=='1', 4})

%Wilcoxon rank sum test 
[pval, hval, stats] = ranksum(data1{data1.Change_Direction=='0', 4}, data1{data1.Change_Direction=='1', 4})

%% Group 2: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean2 = mean(data2{data2.Change_Direction=='0', 4})
nochangeVelMedian2 = median(data2{data2.Change_Direction=='0', 4})

changeVelMean2 = mean(data2{data2.Change_Direction=='1', 4})
changeVelMedian2 = median(data2{data2.Change_Direction=='1', 4})

differencechangeVelMean2 = changeVelMean2 - nochangeVelMean2 

% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(data2{data2.Change_Direction=='0', 4}, data2{data2.Change_Direction=='1', 4})


%Wilcox
[pval, hval, stats] = ranksum(data2{data2.Change_Direction=='0', 4}, data2{data2.Change_Direction=='1', 4})
%% GROUPS 1&2 COMBINED: What velocity of the cell do we see with change in direction? 

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
%% Group 1 v 2: Velocity without change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = nochangeVelMean2 - nochangeVelMean1 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data1{data1.Change_Direction=='0', 4}, data2{data2.Change_Direction=='0', 4})

[pval, hval, stats] = ranksum(data1{data1.Change_Direction=='0', 4}, data2{data2.Change_Direction=='0', 4})
%% Group 1 v 2: Velocity with change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = changeVelMean2 - changeVelMean1 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data1{data1.Change_Direction=='1', 4}, data2{data2.Change_Direction=='1', 4})

% wilcoxon test for statistical difference
[pval, hval ,stats] = ranksum(data1{data1.Change_Direction=='1', 4}, data2{data2.Change_Direction=='1', 4})
