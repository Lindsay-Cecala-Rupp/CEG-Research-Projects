
% Script to Determine the Parameters Corresponding to the Angle of the Assymetrical Maxima:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.75;
        Time_Point = 40;
        Number_of_Points = 5;
    
    % Load in Sock:

        % Geometry = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
        Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
            
            Points = Geometry.outSock.pts; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            Faces = Geometry.outSock.fac; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            
    % Load in Time Signal:

        Run_Number = 44; % NOTE: CHANGE THIS DEPENDING ON WHAT RUN I WANT TO LOOK AT!!!!!!!!!!!
        Beat_Number = 1; % NOTE: CHANGE THIS DEPENDING ON WHAT BEAT I WANT TO LOOK AT!!!!!!!!!!!

        % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
            if Run_Number > 0 && Run_Number <= 9
                Number_of_Zeros = '000';
            elseif Run_Number > 9 && Run_Number <= 99 
                Number_of_Zeros = '00';
            else
                Number_of_Zeros = '0';
            end

        % Grab File:
        
            %Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));
            %Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number),'-cs.mat'));

            Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));
            
                ECG_Signal = Time_Signal.ts.potvals;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
% Script to Interpolate Around Bad Leads:

    % Laplacian Interpolation:
    
        % Bad_Leads = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
            % Bad_Leads = Bad_Leads.Bad_Lead_Mask;
            
        Bad_Leads = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
            Bad_Leads = Bad_Leads.Bad_Lead_Mask;
        
        Bad_Lead_Value = find(Bad_Leads == 1);
        
       % Mapping_Matrix = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');
            
       Mapping_Matrix = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');

            Mapping_Matrix = Mapping_Matrix.scirunmatrix;
            
    % Create Matrix Containing Potentials for Only Good Leads:
    
        Zeroed_ECG_Signal = ECG_Signal;
        Zeroed_ECG_Signal(Bad_Lead_Value, :) = 0;
       
    % Apply Mapping Matrix Obtained from SCIRun:
    
        % Note: Format: Mapping_Matrix (All X Good) * Good Leads (Good X 1) = Interpolated (All X 1).
        
            Interpolated_ECG_Signal = Mapping_Matrix * Zeroed_ECG_Signal;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
% Script to Up Sample Sock Using Barycentric Coordinates:

    % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.
    
    for First_Index = 1:size(Interpolated_ECG_Signal, 2)

        [Upsampled_Points, Temporary_Upsampled_Interpolated_ECG_Signal] = Barycentricly_Upsample_Sock_Function(Points, Faces, Interpolated_ECG_Signal(:, First_Index)', Grid_Resolution);
    
        Upsampled_Interpolated_ECG_Signal(:, First_Index) = Temporary_Upsampled_Interpolated_ECG_Signal;
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine where the Asymmetrical Maxima are (Largest Positive Voltage) and the Breakthrough Site (Largest Negative Voltage):
      
    Temporary_Part_of_ECG_Signal = Upsampled_Interpolated_ECG_Signal(:, Time_Point);
    Temporary_Part_of_ECG_Signal(:, 2) = 1:size(Upsampled_Interpolated_ECG_Signal, 1);
    Temporary_Part_of_ECG_Signal = sortrows(Temporary_Part_of_ECG_Signal, 1);

    % Asymmetrical Maxima:
    
        % One:
        
            % Find Single Point with Largest Voltage:
        
                Asymmetrical_Maxima_One_Center_Point_Index = Temporary_Part_of_ECG_Signal(end, 2);
                Asymmetrical_Maxima_One_Center_Point = Upsampled_Points(Asymmetrical_Maxima_One_Center_Point_Index, :);
            
            % Find the Closest Points to the Previously Found Point:
            
                Adjusted_Upsampled_Points = Upsampled_Points;
                Adjusted_Upsampled_Points(Asymmetrical_Maxima_One_Center_Point_Index, :) = Adjusted_Upsampled_Points(Asymmetrical_Maxima_One_Center_Point_Index, :) * 1000;
            
                for First_Index = 1:(Number_of_Points - 1)
                    
                    Asymmetrical_Maxima_One_Point_Index(First_Index, 1) = dsearchn(Adjusted_Upsampled_Points, Asymmetrical_Maxima_One_Center_Point);
                    
                    Adjusted_Upsampled_Points(Asymmetrical_Maxima_One_Point_Index(First_Index, 1), :) = Adjusted_Upsampled_Points(Asymmetrical_Maxima_One_Point_Index(First_Index, 1), :) * 1000;
                    
                end
                
                Asymmetrical_Maxima_One_Point_Index(Number_of_Points, 1) = Asymmetrical_Maxima_One_Center_Point_Index;
                
            % Calculate the Average of the Desired Points:
            
                Asymmetrical_Maxima_One_Point = [mean(Upsampled_Points(Asymmetrical_Maxima_One_Point_Index, 1)); mean(Upsampled_Points(Asymmetrical_Maxima_One_Point_Index, 2)); mean(Upsampled_Points(Asymmetrical_Maxima_One_Point_Index, 3))];
        
        % Two:
        
            
    
    % Breakthrough Site:
    
        % Determine the Points with the Smallest Potential:
    
            Breakthrough_Site_Point_Index = Temporary_Part_of_ECG_Signal(1:Number_of_Points, 2);
        
        % Calcualte the Average of the Desired Points:
        
            Breakthrough_Site_Point = [mean(Upsampled_Points(Breakthrough_Site_Point_Index, 1)); mean(Upsampled_Points(Breakthrough_Site_Point_Index, 2)); mean(Upsampled_Points(Breakthrough_Site_Point_Index, 3))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
