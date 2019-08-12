
% Script to Visualize the Breakthrough Site Angle Results and the Fiber Angle Results for Comparison:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Magic Numbers:
    
        Time_Point = 3;
        
    % Data:

        Breakthrough_Site_Angle_Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Experimental-Version/Results/14-10-27-Per-Act-Ellipse3-Long-Axis-New-Global-Stats.mat');
            Breakthrough_Site_Angle_Results = Breakthrough_Site_Angle_Results.Statistics;
            
        Fiber_Angle_Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Experimental-Version/DTI-2-Results/Mean_Fiber_Angle.mat');
            Fiber_Angle_Results = -1*Fiber_Angle_Results.Compiled_Mean_Fiber_Angle;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Breakthrough_Site_Angle_Results.Percent(Time_Point).Run, 1)
        
        % Grab Means:
        
            Area_Mean(First_Index, 1) = Breakthrough_Site_Angle_Results.Percent(Time_Point).Run(First_Index).Area_Mean;
            Axis_Ratio_Mean(First_Index, 1) = Breakthrough_Site_Angle_Results.Percent(Time_Point).Run(First_Index).Axis_Ratio_Mean;
            Angle_for_Long_Axis_Mean(First_Index, 1) = Breakthrough_Site_Angle_Results.Percent(Time_Point).Run(First_Index).Angle_for_Long_Axis_Mean;

        % Grab STDs:
        
            Area_STDs(First_Index, 1) = Breakthrough_Site_Angle_Results.Percent(Time_Point).Run(First_Index).Area_STD;
            Axis_Ratio_STDs(First_Index, 1) = Breakthrough_Site_Angle_Results.Percent(Time_Point).Run(First_Index).Axis_Ratio_STD;
            Angle_for_Long_Axis_STDs(First_Index, 1) = Breakthrough_Site_Angle_Results.Percent(Time_Point).Run(First_Index).Angle_for_Long_Axis_STD;

    end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data:

    Number_of_Data_Points = 1:size(Breakthrough_Site_Angle_Results.Percent(Time_Point).Run, 1);
    
    Data = [Angle_for_Long_Axis_Mean(1), Fiber_Angle_Results(1); Angle_for_Long_Axis_Mean(2), Fiber_Angle_Results(2); Angle_for_Long_Axis_Mean(3), Fiber_Angle_Results(3); Angle_for_Long_Axis_Mean(4), Fiber_Angle_Results(4); Angle_for_Long_Axis_Mean(5), Fiber_Angle_Results(5); Angle_for_Long_Axis_Mean(6), Fiber_Angle_Results(6); Angle_for_Long_Axis_Mean(7), Fiber_Angle_Results(7); Angle_for_Long_Axis_Mean(8), Fiber_Angle_Results(8); Angle_for_Long_Axis_Mean(9), Fiber_Angle_Results(9)];
    
    figure(1); 
    
        hold on;
        
            Bar_Graph = bar(Number_of_Data_Points, Data);
            
                Bar_Graph(1).FaceColor = 'red';
                Bar_Graph(2).FaceColor = 'black';
                
            Bar_Graph_Legend = legend('Breakthrough Site Angle', 'Fiber Angle');
                
                Bar_Graph_Legend.Location = 'southwest';
                
        hold off;