
% Script to Create a Graph to Visualize How the Area Changes:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Magic Numbers:
    
        Time_Point = 3;
        
    % Data:

        Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Simulated-Version/Results/14-10-27-Original-Results-without-Long-Axis.mat');
            Results = Results.Ellipse_Information;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Results.Run, 1)
        
        Area(First_Index, 1) = Results.Run(First_Index).Percent(Time_Point).Area;
        Axis_Ratio(First_Index, 1) = Results.Run(First_Index).Percent(Time_Point).Axis_Ratio;
        Angle_for_Long_Axis(First_Index, 1) = Results.Run(First_Index).Percent(Time_Point).Angle_for_Long_Axis;
     
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Round Data for Visualization:

    Area_Rounded = round(Area, 0);
    Axis_Ratio_Rounded = round(Axis_Ratio, 2);
    Angle_for_Long_Axis_Rounded = round(Angle_for_Long_Axis, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data:

    figure('Renderer', 'painters', 'Position', [10 10 900 600])
    
        hold on;

            subplot(2, 2, 1)
            
                bar(Area)
                
                title('Area of the Ellipse')
                
                text(1:length(Area_Rounded), Area, num2str(Area_Rounded), 'vert', 'bottom', 'horiz', 'center');
                
                %ylim([0, 1300]);
                
            subplot(2, 2, 2)
            
                bar(Axis_Ratio)
                
                title('Axis Ratio of the Ellipse')
                
                text(1:length(Axis_Ratio_Rounded), Axis_Ratio, num2str(Axis_Ratio_Rounded), 'vert', 'bottom', 'horiz', 'center');
                
                ylim([0, 0.8]);
                
            subplot(2, 2, 3)
            
                bar(Angle_for_Long_Axis)
                
                title('Long Axis Angle of the Ellipse')
                
                text(1, Angle_for_Long_Axis(1), num2str(Angle_for_Long_Axis_Rounded(1)), 'vert', 'bottom', 'horiz', 'center'); 
                text(2:9, Angle_for_Long_Axis(2:9), num2str(Angle_for_Long_Axis_Rounded(2:9)), 'vert', 'top', 'horiz', 'center'); 
                
                %ylim([-21, 35]);
       
        hold off;
        