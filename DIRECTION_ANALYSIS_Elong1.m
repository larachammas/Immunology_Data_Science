%% Redoing direction analysis of groups 1 & 2
%Using Elongation defintiion 
%% Data Extract and count 
load('elongation2.mat');

%Group1 
data1 = elongation2(elongation2.Group =='1',:);

elong1 = data1(data1.Elongation == '1', :);
nonElong1 = data1(data1.Elongation == '0', :);

countElong1 = height(elong1)
countBeforeElong1 = height(nonElong1)

cells1 = length(unique(data1.Video_Case)) % Get number of cells analyzed

% Group 2
data2 = elongation2(elongation2.Group =='2',:);

elong2 = data2(data2.Elongation == '1', :);
nonElong2 = data2(data2.Elongation == '0', :);

countElong2 = height(elong2)
countBeforeElong2 = height(nonElong2)

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
countNonElong_C = height(nonElong1(nonElong1.Change_Direction=='1', :));
countElong_NC = height(elong1(elong1.Change_Direction=='0', :));
countnonElong_NC = height(nonElong1(nonElong1.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countnonElong_NC], [countElong_C; countNonElong_C], ...
    'rowNames', {'Group 1 Elong', 'Group 1 non-Elong'}, 'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% GROUP 2: How often does elongation match change in direction? 

%Count How many elong events with change 
countElong_C = height(elong2(elong2.Change_Direction=='1', :));
countNonElong_C = height(nonElong2(nonElong2.Change_Direction=='1', :));
countElong_NC = height(elong2(elong2.Change_Direction=='0', :));
countnonElong_NC = height(nonElong2(nonElong2.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countnonElong_NC], [countElong_C; countNonElong_C], ...
    'rowNames', {'Group 2 Elong', 'Group 2 non-Elong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% BOTH GROUPS: How often does elongation match change in direction? 
dataElong = data(data.Elongation == '1',:);
datanonE = data(data.Elongation == '0',:);

%Count How many elong events with change 
countElong_C = height(dataElong(dataElong.Change_Direction=='1', :));
countNonElong_C = height(datanonE(datanonE.Change_Direction=='1', :));
countElong_NC = height(dataElong(dataElong.Change_Direction=='0', :));
countnonElong_NC = height(datanonE(datanonE.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countnonElong_NC], [countElong_C; countNonElong_C], ...
    'rowNames', {'Groups 1&2 Elong', 'Groups 1&2 non-Elong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% VELOCITY %% 

%% Group 1: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean1 = mean(data1{data1.Change_Direction=='0', 4})
nochangeVelMedian1 = median(data1{data1.Change_Direction=='0', 4})

changeVelMean1 = mean(data1{data1.Change_Direction=='1', 4})
changeVelMedian1 = median(data1{data1.Change_Direction=='1', 4})

differencechangeVelMean1 = changeVelMean1 - nochangeVelMean1  

% test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(data1{data1.Change_Direction=='0', 4}, data1{data1.Change_Direction=='1', 4})

[pval_VelChange, h_VelChange, stats_VelChange] = ranksum(data1{data1.Change_Direction=='0', 4}, data1{data1.Change_Direction=='1', 4})


%% Group 2: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean2 = mean(data2{data2.Change_Direction=='0', 4})
nochangeVelMedian2 = median(data2{data2.Change_Direction=='0', 4})

changeVelMean2 = mean(data2{data2.Change_Direction=='1', 4})
changeVelMedian2 = median(data2{data2.Change_Direction=='1', 4})

differencechangeVelMean2 = changeVelMean2 - nochangeVelMean2 

% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(data2{data2.Change_Direction=='0', 4}, data2{data2.Change_Direction=='1', 4})
[pval_VelChange, h_VelChange, stats_VelChange] = ranksum(data2{data2.Change_Direction=='0', 4}, data2{data2.Change_Direction=='1', 4})

%% GROUPS 1&2 COMBINED: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean = mean(dataBoth{dataBoth.Change_Direction=='0', 4})
nochangeVelMedian = median(dataBoth{dataBoth.Change_Direction=='0', 4})

changeVelMean = mean(dataBoth{dataBoth.Change_Direction=='1', 4})
changeVelMedian = median(dataBoth{dataBoth.Change_Direction=='1', 4})

differencechangeVelMean = changeVelMean - nochangeVelMean 


% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(dataBoth{dataBoth.Change_Direction=='0', 4}, ...
    dataBoth{dataBoth.Change_Direction=='1', 4})

[ pval_VelChange, h_VelChange, stats_VelChange] = ranksum(dataBoth{dataBoth.Change_Direction=='0', 4}, ...
    dataBoth{dataBoth.Change_Direction=='1', 4})

%% Group 1 v 2: Velocity without change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = nochangeVelMean2 - nochangeVelMean1 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data1{data1.Change_Direction=='0', 4}, data2{data2.Change_Direction=='0', 4})
[pval, h, stats] = ranksum(data1{data1.Change_Direction=='0', 4}, data2{data2.Change_Direction=='0', 4})

%% Group 1 v 2: Velocity with change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = changeVelMean2 - changeVelMean1 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data1{data1.Change_Direction=='1', 4}, data2{data2.Change_Direction=='1', 4})
[pval, h, stats] = ranksum(data1{data1.Change_Direction=='1', 4}, data2{data2.Change_Direction=='1', 4})



