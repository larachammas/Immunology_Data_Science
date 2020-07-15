%% Redoing direction analysis of groups 4 & 5
%Using Elongation defintiion 
%% Data Extract and count 
load('elongation2.mat');

%Group 4
data4 = elongation2(elongation2.Group =='4',:);

elong4 = data4(data4.Elongation == '1', :);
nonElong4 = data4(data4.Elongation == '0', :);

countElong4 = height(elong4)
countBeforeElong4 = height(nonElong4)

cells4 = length(unique(data4.Video_Case)) % Get number of cells analyzed

% Group 2
data5 = elongation2(elongation2.Group =='5',:);

elong5 = data5(data5.Elongation == '1', :);
nonElong5 = data5(data5.Elongation == '0', :);

countElong5 = height(elong5)
countBeforeElong5 = height(nonElong5)

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
countNonElong_C = height(nonElong4(nonElong4.Change_Direction=='1', :));
countElong_NC = height(elong4(elong4.Change_Direction=='0', :));
countnonElong_NC = height(nonElong4(nonElong4.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countnonElong_NC], [countElong_C; countNonElong_C], ...
    'rowNames', {'Group 4 Elong', 'Group 4 non-Elong'}, 'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% GROUP 5: How often does elongation match change in direction? 

%Count How many elong events with change 
countElong_C = height(elong5(elong5.Change_Direction=='1', :));
countNonElong_C = height(nonElong5(nonElong5.Change_Direction=='1', :));
countElong_NC = height(elong5(elong5.Change_Direction=='0', :));
countnonElong_NC = height(nonElong5(nonElong5.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countnonElong_NC], [countElong_C; countNonElong_C], ...
    'rowNames', {'Group 5 Elong', 'Group 5 non-Elong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% BOTH GROUPS: How often does elongation match change in direction? 
dataBothElong = dataBoth(dataBoth.Elongation == '1',:);
dataBothNonE = dataBoth(dataBoth.Elongation == '0',:);

%Count How many elong events with change 
countElong_C = height(dataBothElong(dataBothElong.Change_Direction=='1', :));
countNonElong_C = height(dataBothNonE(dataBothNonE.Change_Direction=='1', :));
countElong_NC = height(dataBothElong(dataBothElong.Change_Direction=='0', :));
countnonElong_NC = height(dataBothNonE(dataBothNonE.Change_Direction=='0', :)); 

% Is there a difference between the counts of elong change and non elong change
%generate table
x = table([countElong_NC; countnonElong_NC], [countElong_C; countNonElong_C], ...
    'rowNames', {'Groups 4&5 Elong', 'Groups 4&5 non-Elong'}, ...
    'VariableNames', {'NoChange', 'Change'})

%Fishers test for statistical difference 
[h,p,stats] = fishertest(x)

%% VELOCITY %%%% 
%% Group 4: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean4 = mean(data4{data4.Change_Direction=='0', 4})
nochangeVelMedian4 = median(data4{data4.Change_Direction=='0', 4})

changeVelMean4 = mean(data4{data4.Change_Direction=='1', 4})
changeVelMedian4 = median(data4{data4.Change_Direction=='1', 4})

differencechangeVelMean4 = changeVelMean4 - nochangeVelMean4  

% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(data4{data4.Change_Direction=='0', 4}, data4{data4.Change_Direction=='1', 4})
[pval_VelChange, h_VelChange, stats_VelChange] = ranksum(data4{data4.Change_Direction=='0', 4}, data4{data4.Change_Direction=='1', 4})

%% Group 5: What velocity of the cell do we see with change in direction? 

% Calculate absolute mean values and their difference 
nochangeVelMean5 = mean(data5{data5.Change_Direction=='0', 4})
nochangeVelMedian5 = median(data5{data5.Change_Direction=='0', 4})

changeVelMean5 = mean(data5{data5.Change_Direction=='1', 4})
changeVelMedian5 = median(data5{data5.Change_Direction=='1', 4})

differencechangeVelMean4 = changeVelMean5 - nochangeVelMean5 

% ttest2 test for statistical difference
[h_VelChange, pval_VelChange, ci_veloChange ,stats_VelChange] = ttest2(data5{data5.Change_Direction=='0', 4}, data5{data5.Change_Direction=='1', 4})
[pval_VelChange, h_VelChange, stats_VelChange] = ranksum(data5{data5.Change_Direction=='0', 4}, data5{data5.Change_Direction=='1', 4})

%% GROUPS 4&5 COMBINED: What velocity of the cell do we see with change in direction? 

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

%% Group 4 v 5: Velocity without change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffNochangeVel = nochangeVelMean5 - nochangeVelMean4 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data4{data4.Change_Direction=='0', 4}, data5{data5.Change_Direction=='0', 4})
[pval, h, stats] = ranksum(data4{data4.Change_Direction=='0', 4}, data5{data5.Change_Direction=='0', 4})

%% Group 4 v 5: Velocity with change in direction 

% Calculate absolute mean values and their difference 
%use previous values

diffChangeVel = changeVelMean5 - changeVelMean4 

% ttest2 test for statistical difference
[h, pval, ci ,stats] = ttest2(data4{data4.Change_Direction=='1', 4}, data5{data5.Change_Direction=='1', 4})
[pval, h, stats] = ranksum(data4{data4.Change_Direction=='1', 4}, data5{data5.Change_Direction=='1', 4})

