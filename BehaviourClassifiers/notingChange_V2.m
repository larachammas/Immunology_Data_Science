%% Noting direction change 

%If the string from the previous step does not match the string in the next
%row, put a 1 
%if they match, put a 0 
%using FinalStats_filtered, column 29 

load('Results/Final_Stat_Sets_2/FinalStats_full_09_10.mat');
changesVector = [];

for i = 1:height(unique(FinalStats_full(:,2)))
    
    caseData = FinalStats_full(i == FinalStats_full.Video_Case, :);
    
    frames = caseData.Time;
    
    frameCount = height(caseData);
    
    k = [2: frameCount]; 
    
    videoCase = repmat(i,(frameCount),1);
    changes = []; 
    
    for j = 1:(frameCount-1)
        
        str1 = caseData.Direction(j);
        str2 = caseData.Direction(k(j));

        if strcmp(str1, str2) == 0
            changes(j) = 1 ;
        else 
            changes(j) = 0;
        end 
       
    end 
    changes2 = [0, changes]';
    changesVector = [changesVector; videoCase frames changes2];
end  

%%
changesVector_labels = {'Video', 'Frame', 'Direction_Change'};
%%
filename =strcat('notingChange_filtered_', datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile,'changesVector', 'changesVector_labels')

%% Add to FinalStats_filtered 

FinalStats_filtered_V2 = addvars(FinalStats_filtered,changesVector(:,3));

%% Add label name
FinalStats_filtered_V2.Properties.VariableNames{31} = 'Change_Direction'
%% Change order of rows
FinalStats_filtered_V3 = FinalStats_filtered_V2(:,[1:29 31 30]);

%% Make things categorical 
FinalStats_filtered_V3.Direction = categorical(FinalStats_filtered_V3.Direction);
FinalStats_filtered_V3.Shapes = categorical(FinalStats_filtered_V3.Shapes); 
FinalStats_filtered_V3.Elongation = categorical(FinalStats_filtered_V3.Elongation); 
FinalStats_filtered_V3.Change_Direction = categorical(FinalStats_filtered_V3.Change_Direction); 
FinalStats_filtered_V3.Group = categorical(FinalStats_filtered_V3.Group); 

%%
filename =strcat('FinalStats_filtered_V3_', datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile,'FinalStats_filtered_V3')