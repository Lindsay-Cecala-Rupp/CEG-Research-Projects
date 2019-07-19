
% Script to Create a Graph to Visualize How the Area Changes:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input and Data:

    % Percentage:

        Percent_Values = (0:5:50)/100;

        Percent_Index = 6;
    
        Percent_Value = Percent_Values(Percent_Index);

    % Data:

        Results = load('/Users/rupp/Documents/Breakthrough-Site-Angle-Calculation/Experimental-Version/Results/14_10_27_Percent_Act_Ellipse_V2_Stats_All.mat');
            Results = Results.Statistics;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grad Data at the Specified Time Point:

    for First_Index = 1:size(Results.Percent(Percent_Index).Run, 1)
        
        % Grab Means:
        
            Area_Mean(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Area_Mean;
            Axis_Ratio_Mean(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Axis_Ratio_Mean;
            Angle_for_Long_Axis_Mean(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Angle_for_Long_Axis_Mean;
            Angle_for_Short_Axis_Mean(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Angle_for_Short_Axis_Mean;
        
        % Grab STDs:
        
            Area_STD(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Area_STD;
            Axis_Ratio_STD(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Axis_Ratio_STD;
            Angle_for_Long_Axis_STD(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Angle_for_Long_Axis_STD;
            Angle_for_Short_Axis_STD(First_Index, 1) = Results.Percent(Percent_Index).Run(First_Index).Angle_for_Short_Axis_STD;
             
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Grab Data Dependent on the Pacing Site:

    % LV Base:
    
        LV_Base_Runs = [7:11, 14, 16:17] - 6; % NOTE: Minus Six is Due to Where the Runs Start in the Saved Structure
        
        LV_Base_Area_Mean = Area_Mean(LV_Base_Runs);
        LV_Base_Area_STD = Area_STD(LV_Base_Runs);
        
        LV_Base_Axis_Ratio_Mean = Axis_Ratio_Mean(LV_Base_Runs);
        LV_Base_Axis_Ratio_STD = Axis_Ratio_STD(LV_Base_Runs);
        
        LV_Base_Angle_for_Long_Axis_Mean = Angle_for_Long_Axis_Mean(LV_Base_Runs);
        LV_Base_Angle_for_Long_Axis_STD = Angle_for_Long_Axis_STD(LV_Base_Runs);
        
        LV_Base_Angle_for_Short_Axis_Mean = Angle_for_Short_Axis_Mean(LV_Base_Runs);
        LV_Base_Angle_for_Short_Axis_STD = Angle_for_Short_Axis_STD(LV_Base_Runs);
        
    % LV Apex:
    
        LV_Apex_Runs = (21:26) - 6; % NOTE: Minus Six is Due to Where the Runs Start in the Saved Structure
        
        LV_Apex_Area_Mean = Area_Mean(LV_Apex_Runs);
        LV_Apex_Area_STD = Area_STD(LV_Apex_Runs);
        
        LV_Apex_Axis_Ratio_Mean = Axis_Ratio_Mean(LV_Apex_Runs);
        LV_Apex_Axis_Ratio_STD = Axis_Ratio_STD(LV_Apex_Runs);
        
        LV_Apex_Angle_for_Long_Axis_Mean = Angle_for_Long_Axis_Mean(LV_Apex_Runs);
        LV_Apex_Angle_for_Long_Axis_STD = Angle_for_Long_Axis_STD(LV_Apex_Runs);
        
        LV_Apex_Angle_for_Short_Axis_Mean = Angle_for_Short_Axis_Mean(LV_Apex_Runs);
        LV_Apex_Angle_for_Short_Axis_STD = Angle_for_Short_Axis_STD(LV_Apex_Runs);

    % LV Septum:
    
        LV_Septum_Runs = (27:35) - 6; % NOTE: Minus Six is Due to Where the Runs Start in the Saved Structure
        
        LV_Septum_Area_Mean = Area_Mean(LV_Septum_Runs);
        LV_Septum_Area_STD = Area_STD(LV_Septum_Runs);
        
        LV_Septum_Axis_Ratio_Mean = Axis_Ratio_Mean(LV_Septum_Runs);
        LV_Septum_Axis_Ratio_STD = Axis_Ratio_STD(LV_Septum_Runs);
        
        LV_Septum_Angle_for_Long_Axis_Mean = Angle_for_Long_Axis_Mean(LV_Septum_Runs);
        LV_Septum_Angle_for_Long_Axis_STD = Angle_for_Long_Axis_STD(LV_Septum_Runs);
        
        LV_Septum_Angle_for_Short_Axis_Mean = Angle_for_Short_Axis_Mean(LV_Septum_Runs);
        LV_Septum_Angle_for_Short_Axis_STD = Angle_for_Short_Axis_STD(LV_Septum_Runs);
        
    % LV Free Wall:
    
        LV_Free_Wall_Runs = (36:44) - 6; % NOTE: Minus Six is Due to Where the Runs Start in the Saved Structure
        
        LV_Free_Wall_Area_Mean = Area_Mean(LV_Free_Wall_Runs);
        LV_Free_Wall_Area_STD = Area_STD(LV_Free_Wall_Runs);
        
        LV_Free_Wall_Axis_Ratio_Mean = Axis_Ratio_Mean(LV_Free_Wall_Runs);
        LV_Free_Wall_Axis_Ratio_STD = Axis_Ratio_STD(LV_Free_Wall_Runs);
        
        LV_Free_Wall_Angle_for_Long_Axis_Mean = Angle_for_Long_Axis_Mean(LV_Free_Wall_Runs);
        LV_Free_Wall_Angle_for_Long_Axis_STD = Angle_for_Long_Axis_STD(LV_Free_Wall_Runs);
        
        LV_Free_Wall_Angle_for_Short_Axis_Mean = Angle_for_Short_Axis_Mean(LV_Free_Wall_Runs);
        LV_Free_Wall_Angle_for_Short_Axis_STD = Angle_for_Short_Axis_STD(LV_Free_Wall_Runs);
        
    % RV Free Wall:
   
        RV_Free_Wall_Runs = [45:48, 50:54] - 6; % NOTE: Minus Six is Due to Where the Runs Start in the Saved Structure
        
        RV_Free_Wall_Area_Mean = Area_Mean(RV_Free_Wall_Runs);
        RV_Free_Wall_Area_STD = Area_STD(RV_Free_Wall_Runs);
        
        RV_Free_Wall_Axis_Ratio_Mean = Axis_Ratio_Mean(RV_Free_Wall_Runs);
        RV_Free_Wall_Axis_Ratio_STD = Axis_Ratio_STD(RV_Free_Wall_Runs);
        
        RV_Free_Wall_Angle_for_Long_Axis_Mean = Angle_for_Long_Axis_Mean(RV_Free_Wall_Runs);
        RV_Free_Wall_Angle_for_Long_Axis_STD = Angle_for_Long_Axis_STD(RV_Free_Wall_Runs);
        
        RV_Free_Wall_Angle_for_Short_Axis_Mean = Angle_for_Short_Axis_Mean(RV_Free_Wall_Runs);
        RV_Free_Wall_Angle_for_Short_Axis_STD = Angle_for_Short_Axis_STD(RV_Free_Wall_Runs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data - LV Base:

    LV_Base_Data_Points = 1:8;

    figure(1);
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(LV_Base_Data_Points, LV_Base_Area_Mean)

                    Error_Info = errorbar(LV_Base_Data_Points, LV_Base_Area_Mean, LV_Base_Area_STD, LV_Base_Area_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Base Area of the Ellipse')
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(LV_Base_Data_Points, LV_Base_Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(LV_Base_Data_Points, LV_Base_Axis_Ratio_Mean, LV_Base_Axis_Ratio_STD, LV_Base_Axis_Ratio_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Base Axis Ratio of the Ellipse')
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(LV_Base_Data_Points, LV_Base_Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Base_Data_Points, LV_Base_Angle_for_Long_Axis_Mean, LV_Base_Angle_for_Long_Axis_STD, LV_Base_Angle_for_Long_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Base Long Axis Angle of the Ellipse')
                    
                hold off;

            subplot(2, 2, 4)
            
                hold on;
            
                    bar(LV_Base_Data_Points, LV_Base_Angle_for_Short_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Base_Data_Points, LV_Base_Angle_for_Short_Axis_Mean, LV_Base_Angle_for_Short_Axis_STD, LV_Base_Angle_for_Short_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Base Short Axis Angle of the Ellipse')
                    
                hold off;
                
        hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data - LV Apex:

    LV_Apex_Data_Points = 4:9;

    figure(2);
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(LV_Apex_Data_Points, LV_Apex_Area_Mean)

                    Error_Info = errorbar(LV_Apex_Data_Points, LV_Apex_Area_Mean, LV_Apex_Area_STD, LV_Apex_Area_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Apex Area of the Ellipse')
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(LV_Apex_Data_Points, LV_Apex_Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(LV_Apex_Data_Points, LV_Apex_Axis_Ratio_Mean, LV_Apex_Axis_Ratio_STD, LV_Apex_Axis_Ratio_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Apex Axis Ratio of the Ellipse')
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(LV_Apex_Data_Points, LV_Apex_Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Apex_Data_Points, LV_Apex_Angle_for_Long_Axis_Mean, LV_Apex_Angle_for_Long_Axis_STD, LV_Apex_Angle_for_Long_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Apex Long Axis Angle of the Ellipse')
                    
                hold off;

            subplot(2, 2, 4)
            
                hold on;
            
                    bar(LV_Apex_Data_Points, LV_Apex_Angle_for_Short_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Apex_Data_Points, LV_Apex_Angle_for_Short_Axis_Mean, LV_Apex_Angle_for_Short_Axis_STD, LV_Apex_Angle_for_Short_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Apex Short Axis Angle of the Ellipse')
                    
                hold off;
                
        hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data - LV Septum:

    LV_Septum_Data_Points = 1:9;

    figure(3);
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(LV_Septum_Data_Points, LV_Septum_Area_Mean)

                    Error_Info = errorbar(LV_Septum_Data_Points, LV_Septum_Area_Mean, LV_Septum_Area_STD, LV_Septum_Area_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Septum Area of the Ellipse')
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(LV_Septum_Data_Points, LV_Septum_Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(LV_Septum_Data_Points, LV_Septum_Axis_Ratio_Mean, LV_Septum_Axis_Ratio_STD, LV_Septum_Axis_Ratio_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Septum Axis Ratio of the Ellipse')
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(LV_Septum_Data_Points, LV_Septum_Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Septum_Data_Points, LV_Septum_Angle_for_Long_Axis_Mean, LV_Septum_Angle_for_Long_Axis_STD, LV_Septum_Angle_for_Long_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Septum Long Axis Angle of the Ellipse')
                    
                hold off;

            subplot(2, 2, 4)
            
                hold on;
            
                    bar(LV_Septum_Data_Points, LV_Septum_Angle_for_Short_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Septum_Data_Points, LV_Septum_Angle_for_Short_Axis_Mean, LV_Septum_Angle_for_Short_Axis_STD, LV_Septum_Angle_for_Short_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Septum Short Axis Angle of the Ellipse')
                    
                hold off;
                
        hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data - LV Free Wall:

    LV_Free_Wall_Data_Points = 1:9;

    figure(4);
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(LV_Free_Wall_Data_Points, LV_Free_Wall_Area_Mean)

                    Error_Info = errorbar(LV_Free_Wall_Data_Points, LV_Free_Wall_Area_Mean, LV_Free_Wall_Area_STD, LV_Free_Wall_Area_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Free Wall Area of the Ellipse')
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(LV_Free_Wall_Data_Points, LV_Free_Wall_Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(LV_Free_Wall_Data_Points, LV_Free_Wall_Axis_Ratio_Mean, LV_Free_Wall_Axis_Ratio_STD, LV_Free_Wall_Axis_Ratio_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Free Wall Axis Ratio of the Ellipse')
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(LV_Free_Wall_Data_Points, LV_Free_Wall_Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Free_Wall_Data_Points, LV_Free_Wall_Angle_for_Long_Axis_Mean, LV_Free_Wall_Angle_for_Long_Axis_STD, LV_Free_Wall_Angle_for_Long_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Free Wall Long Axis Angle of the Ellipse')
                    
                hold off;

            subplot(2, 2, 4)
            
                hold on;
            
                    bar(LV_Free_Wall_Data_Points, LV_Free_Wall_Angle_for_Short_Axis_Mean)
                    
                    Error_Info = errorbar(LV_Free_Wall_Data_Points, LV_Free_Wall_Angle_for_Short_Axis_Mean, LV_Free_Wall_Angle_for_Short_Axis_STD, LV_Free_Wall_Angle_for_Short_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('LV Free Wall Short Axis Angle of the Ellipse')
                    
                hold off;
                
        hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Plot the Data - LV Free Wall:

    RV_Free_Wall_Data_Points = 1:9;

    figure(5);
    
        hold on;
        
            subplot(2, 2, 1)
            
                hold on;
            
                    bar(RV_Free_Wall_Data_Points, RV_Free_Wall_Area_Mean)

                    Error_Info = errorbar(RV_Free_Wall_Data_Points, RV_Free_Wall_Area_Mean, RV_Free_Wall_Area_STD, RV_Free_Wall_Area_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('RV Free Wall Area of the Ellipse')
                    
                hold off;
                
            subplot(2, 2, 2)
            
                hold on; 
            
                    bar(RV_Free_Wall_Data_Points, RV_Free_Wall_Axis_Ratio_Mean)
                    
                    Error_Info = errorbar(RV_Free_Wall_Data_Points, RV_Free_Wall_Axis_Ratio_Mean, RV_Free_Wall_Axis_Ratio_STD, RV_Free_Wall_Axis_Ratio_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('RV Free Wall Axis Ratio of the Ellipse')
                    
                hold off;

            subplot(2, 2, 3)
            
                hold on;
            
                    bar(RV_Free_Wall_Data_Points, RV_Free_Wall_Angle_for_Long_Axis_Mean)
                    
                    Error_Info = errorbar(RV_Free_Wall_Data_Points, RV_Free_Wall_Angle_for_Long_Axis_Mean, RV_Free_Wall_Angle_for_Long_Axis_STD, RV_Free_Wall_Angle_for_Long_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('RV Free Wall Long Axis Angle of the Ellipse')
                    
                hold off;

            subplot(2, 2, 4)
            
                hold on;
            
                    bar(RV_Free_Wall_Data_Points, RV_Free_Wall_Angle_for_Short_Axis_Mean)
                    
                    Error_Info = errorbar(RV_Free_Wall_Data_Points, RV_Free_Wall_Angle_for_Short_Axis_Mean, RV_Free_Wall_Angle_for_Short_Axis_STD, RV_Free_Wall_Angle_for_Short_Axis_STD);

                        Error_Info.Color = [0 0 0];
                        Error_Info.LineStyle = 'none';

                    title('RV Free Wall Short Axis Angle of the Ellipse')
                    
                hold off;
                
        hold off;