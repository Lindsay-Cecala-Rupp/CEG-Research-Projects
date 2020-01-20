
% Script to Visualize the Breakthrough Site Angle Results and the Fiber Angle Results for Comparison:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Magic Numbers:
    
        Time_Point = 4;

% Load in Data:

    Breakthrough_Site_Angle = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Simulated-Version/Results/14-10-27-Original-Results-without-Long-Axis.mat');
            Breakthrough_Site_Angle = Breakthrough_Site_Angle.Ellipse_Information;
            
    Fiber_Angle_Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version/Results/14-10-27-Original-Results-without-Long-Axis/14-10-27-Average-Angle-Results_Mean.mat');
        Fiber_Angle_Results = Fiber_Angle_Results.Mean_Angle;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Breakthrough_Site_Angle.Run, 1)
        
        Area(First_Index, 1) = Breakthrough_Site_Angle.Run(First_Index).Percent(Time_Point).Area;
        Axis_Ratio(First_Index, 1) = Breakthrough_Site_Angle.Run(First_Index).Percent(Time_Point).Axis_Ratio;
        Angle_for_Long_Axis(First_Index, 1) = Breakthrough_Site_Angle.Run(First_Index).Percent(Time_Point).Angle_for_Long_Axis;

    end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data:

    Number_of_Data_Points = size(Breakthrough_Site_Angle.Run, 1);
    
    X_Values = 1:Number_of_Data_Points;
    
    Data = [Angle_for_Long_Axis(:), Fiber_Angle_Results(:)]';
    
    Rounded_Angle_for_Long_Axis = round(Angle_for_Long_Axis, 1);
    
    Rounded_Fiber_Angle_Results = round(Fiber_Angle_Results, 1);
    
    figure('Renderer', 'painters', 'Position', [10 10 900 600]) 
    
        hold on;
        
            Bar_Graph = bar(X_Values, Data, 1, 'grouped');
            
                Bar_Graph(1).FaceColor = 'red';
                Bar_Graph(2).FaceColor = 'black';
                
            %text(((1:6) - 0.175), Rounded_Angle_for_Long_Axis(1:6), num2str(Rounded_Angle_for_Long_Axis(1:6)), 'vert', 'bottom', 'horiz', 'center');
            %text(((7:9) - 0.175), Rounded_Angle_for_Long_Axis(7:9), num2str(Rounded_Angle_for_Long_Axis(7:9)), 'vert', 'top', 'horiz', 'center');

            %text(((1:5) + 0.15), Rounded_Fiber_Angle_Results(1:5), num2str(Rounded_Fiber_Angle_Results(1:5)), 'vert', 'bottom', 'horiz', 'center');
            %text(((6:9) + 0.15), Rounded_Fiber_Angle_Results(6:9), num2str(Rounded_Fiber_Angle_Results(6:9)), 'vert', 'top', 'horiz', 'center');
             
            Bar_Graph_Legend = legend('Breakthrough Site Angle', 'Average Fiber Angle');
                
                Bar_Graph_Legend.Location = 'southwest';
                
        hold off;
                