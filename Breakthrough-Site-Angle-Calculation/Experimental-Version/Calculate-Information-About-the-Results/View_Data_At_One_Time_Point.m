
% Script to Create a Graph to Visualize How the Area Changes:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Magic Numbers:
    
        Time_Points = 4;
        
    % Data:

        Results = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Experimental-Version/Results/Corrected_14_10_27_Percent_Act_Ellipse_V3_Long_Axis_Stats_All.mat');
            Results = Results.Statistics;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Results.Percent(Time_Points).Run, 1)
        
        % Grab Means:
        
            Area_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Area_Mean;
            Axis_Ratio_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Axis_Ratio_Mean;
            Angle_for_Long_Axis_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Angle_for_Long_Axis_Mean;
%             Angle_for_Short_Axis_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Angle_for_Short_Axis_Mean;
        
        % Grab STDs:
        
            Area_STDs(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Area_STD;
            Axis_Ratio_STDs(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Axis_Ratio_STD;
            Angle_for_Long_Axis_STDs(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Angle_for_Long_Axis_STD;
%             Angle_for_Short_Axis_STDs(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Angle_for_Short_Axis_STD;
             
    end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data:

    Data_Points = 1:size(Results.Percent(Time_Points).Run, 1);

    figure(1);
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(Data_Points, Area_Mean)

                    Error_Info = errorbar(Data_Points, Area_Mean, Area_STDs, Area_STDs);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('Area of the Ellipse')
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(Data_Points, Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(Data_Points, Axis_Ratio_Mean, Axis_Ratio_STDs, Axis_Ratio_STDs);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('Axis Ratio of the Ellipse')
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(Data_Points, Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(Data_Points, Angle_for_Long_Axis_Mean, Angle_for_Long_Axis_STDs, Angle_for_Long_Axis_STDs);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('Long Axis Angle of the Ellipse')
                    
                hold off;

% %             subplot(2, 2, 4)
% %             
% %                 hold on;
% %             
% %                     bar(Angle_for_Short_Axis_Mean)
% %                     
% %                     Error_Info = errorbar(Data_Points, Angle_for_Short_Axis_Mean, Angle_for_Short_Axis_STDs, Angle_for_Short_Axis_STDs);
% % 
% %                         Error_Info.Color = [0 0 0];
% %                         Error_Info.LineStyle = 'none';
% % 
% %                     title('Short Axis Angle of the Ellipse')
% %                     
% %                 hold off;
                
        hold off;
