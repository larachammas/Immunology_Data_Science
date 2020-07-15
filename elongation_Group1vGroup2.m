%% Investingating the properties of the cell during nuclear elongation moments 
%using elongation2 definition 

%read(elongation_FramePrevious.m)
load('elognation2.mat')
data = elongation2;

%% Data Extract and count 

%Subset Group 1 data
data1 = elongation2(elongation2.Group =='1',:);
%subset group 1 elongation frames labeled 1
elong1 = data1(data1.Elongation2 == '1', :);
countElong1 = height(elong1)
%subset group 1 before elongation frames labeled 2
beforeElong1 = data1(data1.Elongation2 == '2', 4);
countBeforeElong1 = height(beforeElong1)
% Get number of group 1 cells analyzed
cells1 = length(unique(data1.Video_Case)) 

% Data Extract for just Group 2
data2 = elongation2(elongation2.Group =='2',:);
%extract group 2 elongation frames
elong2 = data2(data2.Elongation2 == '1', :);
countElong2 = height(elong2)
%extract group 2 before elognation frames
beforeElong2 = data2(data2.Elongation2 == '2', 4);
%get number of group 2 cells analyzed
cells2 = length(unique(data2.Video_Case))

%Data Extract and count for both Group 1 and Group 2
dataBoth = [data1;data2];
elongBoth = dataBoth(dataBoth.Elongation2 == '1', :);
countElongBoth = height(elongBoth)

beforeElongBoth = dataBoth(dataBoth.Elongation2 == '2', 4);
countBeforeBoth = height(beforeElongBoth)

cellBoth = length(unique(dataBoth.Video_Case)) % Get number of cells analyzed

%% Comparing the velocity of elongation moments and non-elongated moments %%% 
%% Graphs 

% Histogram of Group 1 Data
figure;
subplot(3,1,2)
histogram(data1{data1.Elongation2 == '1', 4});
%xlabel('Cell Velocity [\muM/second]', 'FontSize',14);  
ylabel('Frequency', 'FontSize', 14); 
title('Frames with Nuclear Elongation', 'FontSize',14)

subplot(3,1,1)
h1 = histogram(data1{data1.Elongation2 == '2', 4});
%xlabel('Cell Velocity [\muM/second]', 'FontSize',14);
ylabel('Frequency', 'FontSize', 14); 
title('Frame before Nuclear Elongation', 'FontSize',14)

subplot(3,1,3)
h1 = histogram(data1{data1.Elongation2 == '0', 4});
xlabel('Cell Velocity [\muM/second]', 'FontSize',14);
ylabel('Frequency', 'FontSize', 14); 
title('Other Frames', 'FontSize', 14)
sgtitle('Group 1 Cells', 'FontSize', 15)

% Boxplot Elongation group velocity Group 1 
Metric_x           = 32; %elongation2 frame group 
Metric_y           = 4; %velocity
figure;
boxplot(data1{:,Metric_y},data1{:,Metric_x},'whisker',1.5)
xlabel('Group: Other frames (0), Frame of Nucleus Elongation (1), Frame before Elongation (2), ', 'fontsize',14)
ylabel('Cell Velocity [ \muM/second]','fontsize',14)
title('Group 1 Cell Velocity of Different Nucleus Elongation Events', 'fontsize', 15)
grid on

% Histogram of Group 2 Data
figure;
subplot(3,1,2)
histogram(data2{data2.Elongation2 == '1', 4});
%xlabel('Cell Velocity [\muM/second]', 'FontSize',14);  
ylabel('Frequency', 'FontSize', 14); 
title('Frames with Nuclear Elongation', 'FontSize',14)

subplot(3,1,1)
h1 = histogram(data2{data2.Elongation2 == '2', 4});
%xlabel('Cell Velocity [\muM/second]', 'FontSize',14);
ylabel('Frequency', 'FontSize', 14); 
title('Frame before Nuclear Elongation', 'FontSize',14)

subplot(3,1,3)
h1 = histogram(data2{data2.Elongation2 == '0', 4});
xlabel('Cell Velocity [\muM/second]', 'FontSize',14);
ylabel('Frequency', 'FontSize', 14); 
title('Other Frames', 'FontSize', 14)

sgtitle('Group 2 Cells', 'FontSize', 15)

% Boxplot Elongation group velocity Group 2 
Metric_x           = 32; %elongation2 frame group 
Metric_y           = 4; %velocity
figure;
boxplot(data1{:,Metric_y},data1{:,Metric_x},'whisker',1.5)
xlabel('Group: Other frames (0), Frame of Nucleus Elongation (1), Frame before Elongation (2) ', 'fontsize',14)
ylabel('Cell Velocity [ \muM/second]','fontsize',14)
title('Group 2 Cell Velocity of Different Nucleus Elongation Events', 'fontsize', 15)
grid on


%% T-test analysis of velocities Data 

%%Data 
G1_elong_Velocity = data1{data1.Elongation2 == '1', 4};
G1_beforeElong_Velocity = data1{data1.Elongation2 == '2', 4};

G2_elong_Velocity = data2{data2.Elongation2 == '1', 4};
G2_beforeElong_Velocity = data2{data2.Elongation2 == '2', 4};


%% Before and During in Group 1
% Calculate absolute Mean Values and their difference
G1_beforeElongMeanVel = mean(G1_beforeElong_Velocity)
G1_elongMeanVel =  mean(G1_elong_Velocity)
G1_elong_Median = median(G1_elong_Velocity)
G1_BeforEelong_Median = median(G1_beforeElong_Velocity)
G1_differeceMeanVel = G1_elongMeanVel - G1_beforeElongMeanVel   

% ttest2 test for statistical difference 
%Before and During in Group 1
[h_velo_G1, pval_velo_G1, ci_velo_G1, stats_velo_G1] = ttest2(G1_elong_Velocity, G1_beforeElong_Velocity) 

% Before and During in Group 2
% Calculate absolute Mean Values and their difference
G2_elongMeanVel =  mean(G2_elong_Velocity)
G2_beforeElongMeanVel = mean(G2_beforeElong_Velocity)
G2_elong_Median = median(G2_elong_Velocity)
G2_BeforEelong_Median = median(G2_beforeElong_Velocity)
G2_differeceMeanVel = G2_beforeElongMeanVel  - G2_elongMeanVel
% ttest2 test for statistical difference 
[h_velo_G2, pval_velo_G2, ci_velo_G2, stats_velo_G2] = ttest2(G2_elong_Velocity, G2_beforeElong_Velocity) 

% Before Group 1 vs During Group 2 
G12_beforeElongDifference =  G2_beforeElongMeanVel - G1_beforeElongMeanVel
[h_velo_elong, pval_velo_elong, ci_velo_elong, stats_velo_elong] = ttest2(G2_beforeElong_Velocity, G1_beforeElong_Velocity) 

% During Group 1 vs Before Group 2 
G12_elongDifference = G2_elongMeanVel - G1_elongMeanVel 
[h_velo_before, pval_velo_before, ci_velo_before, stats_velo_before] = ttest2(G2_elong_Velocity, G1_elong_Velocity) 

%% Non-Parametric Version (Wilcoxn rank sum)

%Before and During in Group 1
[pval_velo_G1, hval_ci_velo_G1, stats_velo_G1] = ranksum(G1_elong_Velocity, G1_beforeElong_Velocity) 

% Before and During in Group 2
[pval_velo_G2,h_velo_G2, stats_velo_G2] = ranksum(G2_elong_Velocity, G2_beforeElong_Velocity) 

% Before Group 1 vs During Group 2 
[ pval_velo_before, h_velo_before, stats_velo_before] = ranksum(G2_beforeElong_Velocity, G1_beforeElong_Velocity) 

% Elong Group 1 vs Before Group 2 
[pval_velo_elong, h_velo_elong, stats_velo_elong] = ranksum(G2_elong_Velocity, G1_elong_Velocity) 

