
% Script to Determine the Parameters Corresponding to the Angle of the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.2;
        Percent_into_QRS_Peak = 0.15;
    
    % Load in Sock:

            Geometry = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
% %         Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
            
            Points = Geometry.outSock.pts; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            Faces = Geometry.outSock.fac; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            
    % Load in Time Signal:

        Run_Number = 44; % NOTE: CHANGE THIS DEPENDING ON WHAT RUN I WANT TO LOOK AT!!!!!!!!!!!
        Beat_Number = 9; % NOTE: CHANGE THIS DEPENDING ON WHAT BEAT I WANT TO LOOK AT!!!!!!!!!!!

        % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
        
            if Run_Number > 0 && Run_Number <= 9
                
                Number_of_Zeros = '000';
                
            elseif Run_Number > 9 && Run_Number <= 99 
                
                Number_of_Zeros = '00';
                
            else
                
                Number_of_Zeros = '0';
                
            end

        % Grab File:
        
            Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));
            %Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number),'-cs.mat'));

                ECG_Signal = Time_Signal.ts.potvals;
                
            % From File Obtain the Fiducials:
            
                Fiducial_Structure = Time_Signal.ts.fids; % Load the Fiducials
                Fiducial_Types = [Fiducial_Structure.type]; 
                        
                % QRS On:

                    QRS_On_Fiducial = find(Fiducial_Types == 2); % 2 is QRS on 
                    QRS_On_Time = Fiducial_Structure(QRS_On_Fiducial);
                    QRS_On_Time = getfield(QRS_On_Time, 'value'); % Get QRS On Value

                % QRS Off:

                    QRS_Off_Fiducial = find(Fiducial_Types == 4); % 4 is QRS off
                    QRS_Off_Time = Fiducial_Structure(QRS_Off_Fiducial);
                    QRS_Off_Time = getfield(QRS_Off_Time, 'value'); % Get QRS Off Values

            % Implement Function from PEFIER Pull Out:

                Activation_Time = Calculate_Activation_Time_PFEIFER_Pullout(ECG_Signal, QRS_On_Time, (QRS_Off_Time + 5));
                        
            % Overall Activation Time:

                Overall_Activation_Times = Activation_Time - QRS_On_Time; % Want to Find Electrodes with the Earliest/Smallest Activation Times
                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
% Script to Interpolate Around Bad Leads:

    % Laplacian Interpolation:
    
        Bad_Leads = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
            Bad_Leads = Bad_Leads.Bad_Lead_Mask;
        
% %         Bad_Leads = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Bad_Leads_14_10_27.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
% %             Bad_Leads = Bad_Leads.Bad_Leads_14_10_27; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
                
        Bad_Lead_Value = find(Bad_Leads == 1);
        
       Mapping_Matrix = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');
            
% %         Mapping_Matrix = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Experimental-Version/Laplacian-Interpolate/SCIRun-Component/Mapping_Matrix.mat');
            
            Mapping_Matrix = Mapping_Matrix.scirunmatrix;
            
    % Create Vector Containing Activation Times for Only Good Leads:
    
        Zeroed_Activation_Times = Overall_Activation_Times;
        Zeroed_Activation_Times(Bad_Lead_Value) = 0;
       
    % Apply Mapping Matrix Obtained from SCIRun:
    
        % Note: Format: Mapping_Matrix (All X Good) * Good Leads (Good X 1) = Interpolated (All X 1).
        
            Interpolated_Activation_Times = Mapping_Matrix * Zeroed_Activation_Times;
                Interpolated_Activation_Times = Interpolated_Activation_Times';
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
% Script to Up Sample Sock Using Barycentric Coordinates:

    % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.

    [Upsampled_Points, Upsampled_Interpolated_Activation_Times] = Barycentricly_Upsample_Sock_Function(Points, Faces, Interpolated_Activation_Times, Grid_Resolution);
    
    % Plot to Validate Results:
    
        figure(1);
        
            hold on;
            
                plot3(Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3), '.k')
                
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
                
                title('Barycentricly UpSampled Sock');
                
            hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Center the Sock Coordinates at the Origin:

    % Find Centroid:
    
        Sock_Centroid = [mean(Upsampled_Points(:, 1)); mean(Upsampled_Points(:, 2)); mean(Upsampled_Points(:, 3))];
        
    % Translate Centroid to the Origin:
    
        Centered_Upsampled_Points = Upsampled_Points - Sock_Centroid';
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine Coordinates in the Breakthrough Site:

    % Functions: Determine Which Electrodes Have a Activation Time Less than the Set QRS Time.

    [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Percent_Act_Breakthrough_Site_Electrode_Determination_Function(Centered_Upsampled_Points, Upsampled_Interpolated_Activation_Times, Percent_into_QRS_Peak);
    
    if size(Activated_Electrode_X_Location, 1) == 0
        
        Ellipse_Information.Area = NaN;
        Ellipse_Information.Axis_Ratio = NaN;
        Ellipse_Information.Angle_for_Long_Axis = NaN;
        Ellipse_Information.Angle_for_Short_Axis = NaN;
        
    else
    
        % Plot to Validate Results:

            figure(2);

                hold on;

                    scatter3(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location, 'k');

                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    zlabel('Z-Axis');

                    title('Original Breakthrough Site Coordinates');

                hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to "Cluster" the Points Together and Remove Second Breakthrough Sites:
    
        % Functions: Create Clusters and Chooses Cluster with the Most Points.

        [Clustered_Activated_Electrode_X_Location, Clustered_Activated_Electrode_Y_Location, Clustered_Activated_Electrode_Z_Location] = Clustering_Function(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location);
        
        % Plot the Results to Validate:
        
            figure(3);
            
                hold on;
                
                    scatter3(Clustered_Activated_Electrode_X_Location, Clustered_Activated_Electrode_Y_Location, Clustered_Activated_Electrode_Z_Location, 'k');
                    
                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    zlabel('Z-Axis');
                    
                    title('Clustered Breakthrough Site Coordiantes');
                    
                hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to "Fit" A Global Plane to Breakthrough Site:

        % Functions: Fits a Vector from the Sock Centroid to the Breakthrough Site Centroid and Rotates to the Nearest Axis.

        [Global_Projected_Points, Implemented_Points] = Global_Plane_Fitting_Function(Clustered_Activated_Electrode_X_Location, Clustered_Activated_Electrode_Y_Location, Clustered_Activated_Electrode_Z_Location);

        % Plot to Validate Results:

            figure(4);

                hold on;

                    scatter(Global_Projected_Points(:, 1), Global_Projected_Points(:, 2), 'k');

                    % If Statements to Determine Axis System:

                        % Horizontal Axis:

                            if Implemented_Points(1, 1) == 1

                                xlabel('X-Axis');

                            elseif Implemented_Points(1, 1) == 2

                                xlabel('Y-Axis');

                            elseif Implemented_Points(1, 1) == 3

                                xlabel('Z-Axis');

                            end

                        % Vertical Axis:

                            if Implemented_Points(1, 2) == 1

                                ylabel('X-Axis');

                            elseif Implemented_Points(1, 2) == 2

                                ylabel('Y-Axis');

                            elseif Implemented_Points(1, 2) == 3

                                ylabel('Z-Axis');

                            end

                hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Fit an Ellipse to the Data Points:

        % Functions: Fits an Ellipse to the Data Points Using Conics.

        [Ellipse_Structure, Vertical_Line, Horizontal_Line, Rotated_Ellipse] = Fit_an_Ellipse_Function(Global_Projected_Points);

            % Plot to Validate the Results:

                % If Statement to Check if Structure is Empty:

                    if size(Ellipse_Structure.a,1) == 0

                    else

                        figure(5)

                            hold on;

                                scatter(Global_Projected_Points(:, 1), Global_Projected_Points(:, 2), 'k');

                                plot(Vertical_Line(1,:),Vertical_Line(2,:),'r');
                                plot(Horizontal_Line(1,:),Horizontal_Line(2,:),'r');
                                plot(Rotated_Ellipse(1,:),Rotated_Ellipse(2,:),'r');

                            hold off;

                    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Calculate the Parameters of the Fitted Ellipse:

        % Functions: Calculate the Area, Axis Ratio, Long Axis Angle and Short Axis Angle.

        % Check to See if an Ellipse was Fitted in Order to Decide Whether or Not Parameters can be Calculated:

            if size(Ellipse_Structure.a,1) == 0

                Ellipse_Information.Area = NaN;
                Ellipse_Information.Axis_Ratio = NaN;
                Ellipse_Information.Angle_for_Long_Axis = NaN;
                Ellipse_Information.Angle_for_Short_Axis = NaN;

            else

                [Ellipse_Information] = Calculate_Ellipse_Parameters_Function_V2(Ellipse_Structure, Horizontal_Line, Vertical_Line);

            end
            
    end