
% Script to Calcualte Statistics on the Results:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        
    % Load in Results from Code:
    
        Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Asymetrical-Maxima-Calculation/Results/14_10_27_Asymmetrical_Angle_Results.mat');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go through All Time Points and Calculate the Mean and STD for the Angles for the Runs Respectively:

    for First_Index = 1:size(Results.Asymmetrical_Angle.Time_Point, 1)
        
        if size(Results.Asymmetrical_Angle.Time_Point(First_Index).Run, 1) == 0
            
            % Statistics.Time_Point(First_Index, 1) = NaN;
            
        else
            
            for Second_Index = 1:size(Results.Asymmetrical_Angle.Time_Point(First_Index).Run, 1)
                
                Temporary_Values = Results.Asymmetrical_Angle.Time_Point(First_Index).Run(Second_Index).Beat;
                
                if size(Temporary_Values, 1) == 0
                    
                    Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).Mean = NaN;
                    Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).STD = NaN;
                    Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).Number = NaN;
                    
                else
                    
                    NaN_Check = isnan(Temporary_Values);
                    
                    Sum_NaN_Check = sum(NaN_Check);
                    
                    if Sum_NaN_Check == size(Temporary_Values, 1)
                        
                        Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).Mean = NaN;
                        Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).STD = NaN;
                        Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).Number = NaN;
                        
                    else
                        
                        Desired_Indicies = find(NaN_Check == 0);
                        
                        Adjusted_Temporary_Values = Temporary_Values(Desired_Indicies);
                        
                        Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).Mean = mean(Adjusted_Temporary_Values);
                        Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).STD = std(Adjusted_Temporary_Values);
                        Statistics.Time_Point(First_Index, 1).Run(Second_Index, 1).Number = size(Adjusted_Temporary_Values, 1);
                        
                    end
                    
                end
                
            end
            
        end
        
    end
        
        
        
        
        
        
        