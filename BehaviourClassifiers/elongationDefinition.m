%Marking moments of nuclei elongation 
%defined by a percentage increase in the nuclei major axis length [um]
%between frames 
clc 
clear all 
close all

load('Data/Results/Final_Stat_Sets_2/cumulativeStats_full_09_09');

%% For individual case

% caseNumber = 23;
% caseData = ElongationcumulativeStats(ElongationcumulativeStats(:,2)==caseNumber, :);
% 
% % plot major axis changes over time
% figure; 
% plot(caseData(:,3), caseData(:,8))
% xlabel('Frame number') 
% ylabel('Nuclei Major Axis Length [um]')
% title(sprintf(ElongationMetricsDir(caseNumber).name))

% changeAxis = 100* (diff(caseData(:,8)) ./ caseData(1:end-1,8))
% pctThreshold1 = 10
% pctThreshold2 = 15
% pctThreshold3 = 20 
% pctThreshold4 = 25
% 
% for row = 1:length(changeAxis)
%     
%     if changeAxis(row,1) > pctThreshold1 & changeAxis(row,1) < pctThreshold2
%         changeAxis(row,2) = 1 
%         
%     elseif changeAxis(row,1) > pctThreshold2 & changeAxis(row,1) < pctThreshold3
%         changeAxis(row,2) = 2
%         
%     elseif changeAxis(row,1) > pctThreshold3 & changeAxis(row,1) < pctThreshold4
%         changeAxis(row,2) = 3 
% 
%     elseif  changeAxis(row,1) > pctThreshold4
%         changeAxis(row,2) = 4 ;
%         
%     else 
%         changeAxis(row,2) = 0 ;
%     end 
% 
% end 


%% For multiple cases 

% axisChanges = [];
% pctThreshold1 = 12
% pctThreshold2 = 15
% pctThreshold3 = 20 
% pctThreshold4 = 25
% 
% for i = 1: length(unique(ElongationcumulativeStats(:,2)))
%     
%     caseData = ElongationcumulativeStats(ElongationcumulativeStats(:,2)==i, :);
%    
%     frames = caseData(:,3);
%     [frameCount,n] = size(caseData);
%     
%     changeAxis = 100* (diff(caseData(:,8)) ./ caseData(1:end-1,8));
%     
%        for row = 1:length(changeAxis)
% 
%         if changeAxis(row,1) > pctThreshold1 & changeAxis(row,1) < pctThreshold2
%             changeAxis(row,2) = 1 
% 
%         elseif changeAxis(row,1) > pctThreshold2 & changeAxis(row,1) < pctThreshold3
%             changeAxis(row,2) = 2
% 
%         elseif changeAxis(row,1) > pctThreshold3 & changeAxis(row,1) < pctThreshold4
%             changeAxis(row,2) = 3 
% 
%         elseif  changeAxis(row,1) > pctThreshold4
%             changeAxis(row,2) = 4 ;
% 
%         else 
%             changeAxis(row,2) = 0 ;
%         end 
% 
%     end 
% 
%  axisChanges = [axisChanges ; repmat(i,(frameCount-1),1) frames(2:end) changeAxis]         
% end 

%% Final calculation 

axisChanges = [];
pctThreshold = 12; 

for i = 1: length(unique(cumulativeStats_full(:,2)))
    
    caseData = cumulativeStats_full(cumulativeStats_full(:,2)==i, :);
   
    frames = caseData(:,3);
    [frameCount,n] = size(caseData);
    
    changeAxis = 100 * (diff(caseData(:,9)) ./ caseData(1:end-1,9));
    
       for row = 1:length(changeAxis)

        if changeAxis(row,1) > pctThreshold 
            changeAxis(row,2) = 1; 
        else 
            changeAxis(row,2) = 0 ;
        end 

       end 

 axisChanges = [axisChanges ; repmat(i,(frameCount-1),1) frames(2:end) changeAxis];         
end 
    
axisLabels = {'case', 'frame', '%change maj axis', 'elongation?'};


%%
filename =strcat('Full_changingAxis_',datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);

save(fullfile, 'axisChanges', 'axisLabels')
