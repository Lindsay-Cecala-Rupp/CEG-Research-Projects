
% Script to Calculate Stats on the Resulting Ellipse Data:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Load in the Data:

    Results = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Experimental-Version/Results/14_10_27_Percent_Act_Ellipse_V3_Long_Axis_Information_All.mat');
        Results = Results.Ellipse_Information;
        
        for First_Index = 1:size(Results.Angle_for_Long_Axis.Percent, 1)
            
            for Second_Index = 1:size(Results.Angle_for_Long_Axis.Percent(First_Index).Run, 1)

                % For Area:
                
                    Temporary_Area = Results.Area.Percent(First_Index).Run(Second_Index).Beat;
                    
                    Temporary_Area_Mean = mean(Temporary_Area);
                    Temporary_Area_STD = std(Temporary_Area);
                    
                    Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Area_Mean = Temporary_Area_Mean;
                    Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Area_STD = Temporary_Area_STD;
                    
                % For Axis Ratio:
                
                    Temporary_Axis_Ratio = Results.Axis_Ratio.Percent(First_Index).Run(Second_Index).Beat;
                    
                    Temporary_Axis_Ratio_Mean = mean(Temporary_Axis_Ratio);
                    Temporary_Axis_Ratio_STD = std(Temporary_Axis_Ratio);
                    
                    Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Axis_Ratio_Mean = Temporary_Axis_Ratio_Mean;
                    Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Axis_Ratio_STD = Temporary_Axis_Ratio_STD;

                % For Long Axis Angle:
                
                    Temporary_Angle_for_Long_Axis = Results.Angle_for_Long_Axis.Percent(First_Index).Run(Second_Index).Beat;
                    
                    Temporary_Angle_for_Long_Axis_Mean = mean(Temporary_Angle_for_Long_Axis);
                    Temporary_Angle_for_Long_Axis_STD = std(Temporary_Angle_for_Long_Axis);
                    
                    Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Angle_for_Long_Axis_Mean = Temporary_Angle_for_Long_Axis_Mean;
                    Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Angle_for_Long_Axis_STD = Temporary_Angle_for_Long_Axis_STD;

% %                 % For Short Axis Angle:
% %                 
% %                     Temporary_Angle_for_Short_Axis = Results.Angle_for_Short_Axis.Percent(First_Index).Run(Second_Index).Beat;
% %                     
% %                     Temporary_Angle_for_Short_Axis_Mean = mean(Temporary_Angle_for_Short_Axis);
% %                     Temporary_Angle_for_Short_Axis_STD = std(Temporary_Angle_for_Short_Axis);
% %                     
% %                     Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Angle_for_Short_Axis_Mean = Temporary_Angle_for_Short_Axis_Mean;
% %                     Statistics.Percent(First_Index, 1).Run(Second_Index, 1).Angle_for_Short_Axis_STD = Temporary_Angle_for_Short_Axis_STD;
                    
            end
            
        end
    
    