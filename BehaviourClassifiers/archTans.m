close all
clear all
clc 

load('Results/Final_Stat_Sets_2/vectorMagnitudeChanges_09_09.mat')

%% Determing direction based on the archtan(angle) of the vector Magnitudes 
% 
% vPx = vectorMagnitudes(:,3);
% vPy = vectorMagnitudes(:,4);
% archtans = [atand(vPx)  atand(vPy)];
% 
% vectors_direction = [vectorMagnitudes, archtans];
% vectors_direction = num2cell(vectors_direction);
% 
% for i = 1:length(vectors_direction) 
%     
%     if [vectors_direction{i,5}] == 1 && [vectors_direction{i,6}] == 0 %if only change in X is signficant 
%         if vectors_direction{i,7} > 0  %if archtand(PvX) is positive 
%             vectors_direction{i,9} = 'East';
%             
%         elseif vectors_direction{i,7} < 0 %if archtand(PvX) is negative 
%             vectors_direction{i,9} = 'West';
%         end
%         
%    elseif [vectors_direction{i,5}] == 0 && [vectors_direction{i,6}] == 1 %if only magnitude change in Y is signficiant
%       if vectors_direction{i,8} > 0 %if the magnitude is positive (reverse north and south for video flip)
%           vectors_direction{i,9} = 'South';
%       elseif  vectors_direction{i,8} < 0%if it is negative 
%           vectors_direction{i,9} = 'North';
%       end 
%       
%     elseif [vectors_direction{i,5}] == 1 && [vectors_direction{i,6}] == 1 %if both X and Y is signficiant
%         
%         if (vectors_direction{i,7} > 0 && vectors_direction{i,7} <= 22.5) && (vectors_direction{i,8} < 90 && vectors_direction{i,8} >= 67.5)
%             vectors_direction{i,9} = 'South';
% 
%         elseif (vectors_direction{i,7} > 22.5 && vectors_direction{i,7} <= 67.5)  && (vectors_direction{i,8} >= 22.5 && vectors_direction{i,8} < 67.5) 
%             vectors_direction{i,9} = 'South East';
% 
%         elseif (vectors_direction{i,7} > 67.5 && vectors_direction{i,7} <= 90) && (vectors_direction{i,8} >= 0 && vectors_direction{i,8} <= 22.5)  
%             vectors_direction{i,9} = 'East';
% 
%         elseif (vectors_direction{i,7} > 67.5 && vectors_direction{i,7} <= 90) && (vectors_direction{i,8} < 0 && vectors_direction{i,8} >= -22.5)  
%             vectors_direction{i,9} = 'East' ;   
%             
%          elseif (vectors_direction{i,7} > 22.5 && vectors_direction{i,7} <= 67.5) && (vectors_direction{i,8} < -22.5 &&  vectors_direction{i,8} >= -67.5)
%             vectors_direction{i,9} = 'North East';
% 
%         elseif (vectors_direction{i,7} < 22.5 && vectors_direction{i,7} >= 0) && (vectors_direction{i,8} > -90 &&  vectors_direction{i,8} <= -67.5)
%             vectors_direction{i,9} = 'North';     
%             
%         elseif (vectors_direction{i,7} < 0 & vectors_direction{i,7} >= -22.5) && (vectors_direction{i,8} > 0 &&  vectors_direction{i,8} <= 67.5)
%             vectors_direction{i,9} = 'North';    
%             
%         elseif (vectors_direction{i,7} > -67.5 && vectors_direction{i,7} <= -22.5) && (vectors_direction{i,8} > -65.7 &&  vectors_direction{i,8} <= -22.5)
%             vectors_direction{i,9} = 'North West';
% 
%         elseif (vectors_direction{i,7} > -67.5 &&  vectors_direction{i,7} <= 0) && (vectors_direction{i,8} > -22.5 && vectors_direction{i,8} <= -90)
%             vectors_direction{i,9} = 'West';
% 
%         elseif (vectors_direction{i,7} > -90 && vectors_direction{i,7} <= -67.5) && (vectors_direction{i,8} < 0 &&  vectors_direction{i,8} >= -67.5)
%             vectors_direction{i,9} = 'West';      
% 
%         end 
%         
%     else 
%         vectors_direction{i,9} = {''};
%     end       
% end 
%% Code for if the y-values are correct but as the videos are reversed, it does not match video 

%vectors = num2cell(vectorMagnitudes_individual);

% for i = 1:length(vectors) 
%     
%     if [vectors{i,5}] == 1 & [vectors{i,6}] == 0 %if only change in X is signficant 
%         if vectors{i,3} > 0 %if the magnitude is positive
%             vectors{i,7} = {'East'}
%             
%         else %if the magnitude is negative 
%             vectors{i,7} = {'West' }
%         end
%         
%    elseif [vectors{i,5}] == 0 & [vectors{i,6}] == 1 %if only magnitude change in Y is signficiant
%       if vectors{i,4} > 0 %if the magnitude is positive
%           vectors{i,7} = {'North' }
%       else %if it is negative 
%           vectors{i,7} = {'South'}
%       end 
%       
%     elseif [vectors{i,5}] == 1 & [vectors{i,6}] == 1 %if both X and Y is signficiant
%         
%        if vectors{i,3} > 0 & vectors{i,4} > 0 %if the magnitude is positive
%           vectors{i,7} = {'North East'}
%           
%        elseif vectors{i,3} > 0 & vectors{i,4} < 0 
%           vectors{i,7} = {'South East'}
%           
%        elseif vectors{i,3} < 0  & vectors{i,4} < 0 
%             vectors{i,7} = {'South West'}
%             
%        elseif vectors{i,3} < 0  & vectors{i,4} > 0 
%             vectors{i,7} = {'North West'}     
%        end 
%        
%    else 
%     vectors{i,7} = {''};
%     end  
% end 

%% Code to match reversed y-axis in videos
%e.g. note that usually, -Y means south but here it means North 
vectors_direction = num2cell(vectorMagnitudes);

for i = 1:length(vectors_direction) 
    
    if [vectors_direction{i,5}] == 1 & [vectors_direction{i,6}] == 0 %if only change in X is signficant 
        if vectors_direction{i,3} > 0 %if the magnitude is positive
            vectors_direction{i,7} = {'East'};
            
        else %if the magnitude is negative 
            vectors_direction{i,7} = {'West' };
        end
        
   elseif [vectors_direction{i,5}] == 0 & [vectors_direction{i,6}] == 1 %if only magnitude change in Y is signficiant
      if vectors_direction{i,4} > 0 %if the magnitude is positive
          vectors_direction{i,7} = {'South' };
      else %if it is negative 
          vectors_direction{i,7} = {'North'};
      end 
      
    elseif [vectors_direction{i,5}] == 1 & [vectors_direction{i,6}] == 1 %if both X and Y is signficiant
        
       if vectors_direction{i,3} > 0 & vectors_direction{i,4} > 0 %if the X & Y magnitude is positive
          vectors_direction{i,7} = {'South East'};
          
       elseif vectors_direction{i,3} > 0 & vectors_direction{i,4} < 0 %x + and Y - 
          vectors_direction{i,7} = {'North East'};
          
       elseif vectors_direction{i,3} < 0  & vectors_direction{i,4} < 0 %X -  and Y - 
            vectors_direction{i,7} = {'North West'};
            
       elseif vectors_direction{i,3} < 0  & vectors_direction{i,4} > 0 %X - and Y + 
            vectors_direction{i,7} = {'South West'};     
       end 
       
   else 
    vectors_direction{i,7} = {''};
    end  
end 

vectors_direction_labels = {'case','Frame','PvX','PvY','PvX>Mean','PvY>Mean', 'Direction'};

%% 
filename =strcat('vectorDirections_',datestr(date,'mm_dd'));
fullfile = strcat('Results/Final_Stat_Sets_2/', filename);
save(fullfile, 'vectors_direction', 'vectors_direction_labels')