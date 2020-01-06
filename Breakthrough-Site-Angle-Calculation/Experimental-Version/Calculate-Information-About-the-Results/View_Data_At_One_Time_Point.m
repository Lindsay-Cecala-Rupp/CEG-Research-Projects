
% Script to Create a Graph to Visualize How the Area Changes:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Magic Numbers:
    
        Time_Points = 6;
        
    % Data:

        Results = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Experimental-Version/Results/14-10-27-Original-Statistics.mat');
            Results = Results.Statistics;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Results.Percent(Time_Points).Run, 1)
        
        % Grab Means:
        
            Area_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Area_Mean;
            Axis_Ratio_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Axis_Ratio_Mean;
            Angle_for_Long_Axis_Mean(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Angle_for_Long_Axis_Mean;

        % Grab STDs:
        
            Area_STD(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Area_STD;
            Axis_Ratio_STD(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Axis_Ratio_STD;
            Angle_for_Long_Axis_STD(First_Index, 1) = Results.Percent(Time_Points).Run(First_Index).Angle_for_Long_Axis_STD;

    end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Round Data for Visualization:

    % Mean:

        Area_Mean_Rounded = round(Area_Mean, 0);
        Axis_Ratio_Mean_Rounded = round(Axis_Ratio_Mean, 2);
        Angle_for_Long_Axis_Mean_Rounded = round(Angle_for_Long_Axis_Mean, 2);
        
    % STD:
    
        Area_STD_Rounded = round(Area_STD, 0);
        Axis_Ratio_STD_Rounded = round(Axis_Ratio_STD, 2);
        Angle_for_Long_Axis_STD_Rounded = round(Angle_for_Long_Axis_STD, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data:

    Data_Points = 1:size(Results.Percent(Time_Points).Run, 1);

    figure('Renderer', 'painters', 'Position', [10 10 900 600])
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(Data_Points, Area_Mean)

                    Error_Info = errorbar(Data_Points, Area_Mean, Area_STD, Area_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('Area of the Ellipse')
                    
                    text(1:length(Area_Mean_Rounded), (Area_Mean + Area_STD + 60), num2str(Area_Mean_Rounded), 'vert', 'bottom', 'horiz', 'center');
   
                    text(1:length(Area_STD_Rounded), (Area_Mean + Area_STD), num2str(Area_STD_Rounded), 'vert', 'bottom', 'horiz', 'center');
                    
                    ylim([0, 1500]);
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(Data_Points, Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(Data_Points, Axis_Ratio_Mean, Axis_Ratio_STD, Axis_Ratio_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('Axis Ratio of the Ellipse')
                    
                    text(1:length(Axis_Ratio_Mean_Rounded), (Axis_Ratio_Mean + Axis_Ratio_STD + 0.05), num2str(Axis_Ratio_Mean_Rounded), 'vert', 'bottom', 'horiz', 'center');
   
                    text(1:length(Axis_Ratio_STD_Rounded), (Axis_Ratio_Mean + Axis_Ratio_STD), num2str(Axis_Ratio_STD_Rounded), 'vert', 'bottom', 'horiz', 'center');

                    ylim([0, 1]);
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(Data_Points, Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(Data_Points, Angle_for_Long_Axis_Mean, Angle_for_Long_Axis_STD, Angle_for_Long_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('Long Axis Angle of the Ellipse')
                    
                    text(1:4, (Angle_for_Long_Axis_Mean(1:4) + Angle_for_Long_Axis_STD(1:4) + 5), num2str(Angle_for_Long_Axis_Mean_Rounded(1:4)), 'vert', 'bottom', 'horiz', 'center');
   
                    text(1:4, (Angle_for_Long_Axis_Mean(1:4) + Angle_for_Long_Axis_STD(1:4)), num2str(Angle_for_Long_Axis_STD_Rounded(1:4)), 'vert', 'bottom', 'horiz', 'center');
                    
                    text(5:length(Angle_for_Long_Axis_Mean_Rounded), (Angle_for_Long_Axis_Mean(5:end) - Angle_for_Long_Axis_STD(5:end) - 5), num2str(Angle_for_Long_Axis_Mean_Rounded(5:end)), 'vert', 'top', 'horiz', 'center');
   
                    text(5:length(Angle_for_Long_Axis_STD_Rounded), (Angle_for_Long_Axis_Mean(5:end) - Angle_for_Long_Axis_STD(5:end)), num2str(Angle_for_Long_Axis_STD_Rounded(5:end)), 'vert', 'top', 'horiz', 'center');
                    
                    ylim([-60, 35]);
                    
                hold off;
                
        hold off;
