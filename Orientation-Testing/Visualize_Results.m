
% Script to Visualize the Various Orientation Techniques:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Method One - Simulated with Long Axis Implementation:

    Method_One_Breakthrough_Site_Results = load('/Users/lindsayrupp/Desktop/Orientation-Testing/14-10-27-Sim-with-Long-Axis/14-10-27-Breakthrough-Site-Angles.mat');
        Method_One_Breakthrough_Site_Results = Method_One_Breakthrough_Site_Results.Complied_Breakthrough_Site_Information;
        
        for First_Index = 1:size(Method_One_Breakthrough_Site_Results, 1)
            
            Method_One_Breakthrough_Site_Angles(First_Index, 1) = Method_One_Breakthrough_Site_Results(First_Index, 1).Results.Angle_for_Long_Axis;
            
        end
             
    Method_One_Fiber_Results = load('/Users/lindsayrupp/Desktop/Orientation-Testing/14-10-27-Sim-with-Long-Axis/14-10-27-Mean-Fiber-Angle.mat');
        Method_One_Fiber_Results = Method_One_Fiber_Results.Compiled_Mean_Fiber_Angle;
   
    Method_One_X_Values = 1:size(Method_One_Breakthrough_Site_Results, 1);
    Method_One_Y_Values = [Method_One_Breakthrough_Site_Angles(:), Method_One_Fiber_Results(:)];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Method Two - Simulated without Long Axis Implementation:

    Method_Two_Breakthrough_Site_Results = load('/Users/lindsayrupp/Desktop/Orientation-Testing/14-10-27-Sim-without-Long-Axis/14-10-27-Breakthrough-Site-Angles.mat');
        Method_Two_Breakthrough_Site_Results = Method_Two_Breakthrough_Site_Results.Complied_Breakthrough_Site_Information;
        
        for First_Index = 1:size(Method_Two_Breakthrough_Site_Results, 1)
            
            Method_Two_Breakthrough_Site_Angles(First_Index, 1) = Method_Two_Breakthrough_Site_Results(First_Index, 1).Results.Angle_for_Long_Axis;
            
        end
             
    Method_Two_Fiber_Results = load('/Users/lindsayrupp/Desktop/Orientation-Testing/14-10-27-Sim-without-Long-Axis/14-10-27-Mean-Fiber-Angle.mat');
        Method_Two_Fiber_Results = Method_Two_Fiber_Results.Compiled_Mean_Fiber_Angle;
        
    Method_Two_X_Values = 1:size(Method_Two_Breakthrough_Site_Results, 1);
    Method_Two_Y_Values = [Method_Two_Breakthrough_Site_Angles(:), Method_Two_Fiber_Results(:)];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot to Visualize the Results:

    figure(1);
    
        subplot(1, 2, 1);
        
            hold on;
            
                Method_One_Bar_Graph = bar(Method_One_X_Values, Method_One_Y_Values, 1, 'grouped');
                
                    Method_One_Bar_Graph(1).FaceColor = 'red';
                    Method_One_Bar_Graph(2).FaceColor = 'black';
                    
                legend('Breakthrough Site Angle', 'Mean Fiber Angle');
                
                title('Simulated with Long Axis Implementation');
                
            hold off;
            
        subplot(1, 2, 2);
        
            hold on;
            
                Method_Two_Bar_Graph = bar(Method_Two_X_Values, Method_Two_Y_Values, 1, 'grouped');
                
                    Method_Two_Bar_Graph(1).FaceColor = 'red';
                    Method_Two_Bar_Graph(2).FaceColor = 'black';
                    
                legend('Breakthrough Site Angle', 'Mean Fiber Angle');
                
                title('Simulated without Long Axis Implementation');
                
            hold off;
                
    