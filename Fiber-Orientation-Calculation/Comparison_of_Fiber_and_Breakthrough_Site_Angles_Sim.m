
% Script to Visualize the Breakthrough Site Angle Results and the Fiber Angle Results for Comparison:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Magic Numbers:
    
        Time_Point = 3;

% Load in Data:

    Breakthrough_Site_Angle = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Simulated-Version/Results/14-10-27-Ellipse-Results-Long-Axis-Implementation.mat');
            Breakthrough_Site_Angle = Breakthrough_Site_Angle.Compiled_Ellipse_Information;
            
    Fiber_Angle_Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/Results/R2-Division0.25-NumPoints5/14-10-27-Average-Angle-Results_Mean.mat');
        Fiber_Angle_Results = Fiber_Angle_Results.Mean_Angle;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Breakthrough_Site_Angle.Run, 2)
        
        Area(First_Index, 1) = Breakthrough_Site_Angle.Run(First_Index).Percent(Time_Point).Area;
        Axis_Ratio(First_Index, 1) = Breakthrough_Site_Angle.Run(First_Index).Percent(Time_Point).Axis_Ratio;
        Angle_for_Long_Axis(First_Index, 1) = Breakthrough_Site_Angle.Run(First_Index).Percent(Time_Point).Angle_for_Long_Axis;

    end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data:

    Number_of_Data_Points = 1:size(Breakthrough_Site_Angle.Run, 2);
    
    Data = [Angle_for_Long_Axis(1), Fiber_Angle_Results(1); Angle_for_Long_Axis(2), Fiber_Angle_Results(2); Angle_for_Long_Axis(3), Fiber_Angle_Results(3); Angle_for_Long_Axis(4), Fiber_Angle_Results(4); Angle_for_Long_Axis(5), Fiber_Angle_Results(5); Angle_for_Long_Axis(6), Fiber_Angle_Results(6); Angle_for_Long_Axis(7), Fiber_Angle_Results(7); Angle_for_Long_Axis(8), Fiber_Angle_Results(8); Angle_for_Long_Axis(9), Fiber_Angle_Results(9)];
    
    figure(1); 
    
        hold on;
        
            Bar_Graph = bar(Number_of_Data_Points, Data);
            
                Bar_Graph(1).FaceColor = 'red';
                Bar_Graph(2).FaceColor = 'black';
                
            Bar_Graph_Legend = legend('Breakthrough Site Angle', 'Fiber Angle');
                
                Bar_Graph_Legend.Location = 'southwest';
                
        hold off;
                
                
            
            

 
