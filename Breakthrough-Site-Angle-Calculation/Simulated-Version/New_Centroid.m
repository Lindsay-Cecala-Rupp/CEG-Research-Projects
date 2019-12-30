
% Script to Determine the Parameters Corresponding to the Angle of the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.2;
        Percent_into_QRS_Peak = 0.15;
        
        Electrodes_Stimulated = 910;
    
    % Load in Data:

        Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Sock/14-10-27-Simulated-Electrodes', num2str(Electrodes_Stimulated), '.mat'));
        
            Points = Data.Sock_US.node;
            Faces = Data.Sock_US.face;
            Activation_Times = Data.Sock_US.field;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
% Script to Up Sample Sock Using Barycentric Coordinates:

    % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.

    [Upsampled_Points, Upsampled_Activation_Times] = Barycentricly_Upsample_Sock_Function(Points, Faces, Activation_Times, Grid_Resolution);
    
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

% Script to Determine Coordinates in the Breakthrough Site:

    % Functions: Determine Which Electrodes Have a Activation Time Less than the Set QRS Time.

    [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Percent_Act_Breakthrough_Site_Electrode_Determination_Function(Upsampled_Points, Upsampled_Activation_Times, Percent_into_QRS_Peak);
    
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
        
% Script to Center the Sock at the Axis Point Closest to the Breakthrough Site Centroid:

    % Determine Centroid:

        Breakthrough_Site_Centroid = [mean(Activated_Electrode_X_Location), mean(Activated_Electrode_Y_Location), mean(Activated_Electrode_Z_Location)];
    
        Possible_Z_Axis_Location_Points = [zeros(1, 1000); zeros(1, 1000); linspace(min(min(Upsampled_Points)), max(max(Upsampled_Points)), 1000)];
    
        Long_Axis_Closest_Index = dsearchn(Possible_Z_Axis_Location_Points', Breakthrough_Site_Centroid);
    
    % Implementing Centering:
    
        Centered_Upsampled_Points = Upsampled_Points - Possible_Z_Axis_Location_Points(:, Long_Axis_Closest_Index)';
        
        Centered_Activated_Electrode_X_Location = Activated_Electrode_X_Location - Possible_Z_Axis_Location_Points(1, Long_Axis_Closest_Index); 
        Centered_Activated_Electrode_Y_Location = Activated_Electrode_Y_Location - Possible_Z_Axis_Location_Points(2, Long_Axis_Closest_Index);
        Centered_Activated_Electrode_Z_Location = Activated_Electrode_Z_Location - Possible_Z_Axis_Location_Points(3, Long_Axis_Closest_Index);
        
        Centered_Breakthrough_Site_Centroid = Breakthrough_Site_Centroid - Possible_Z_Axis_Location_Points(:, Long_Axis_Closest_Index)';

        % Plot to Validate the Results:
            
            figure(3);
            
                hold on;
                
                    pcshow(Centered_Upsampled_Points, 'w');
                    
                    scatter3(Centered_Activated_Electrode_X_Location, Centered_Activated_Electrode_Y_Location, Centered_Activated_Electrode_Z_Location, 'or')
                
                hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to "Fit" A Global Plane to Breakthrough Site:

    % Original Axis Vectors (X, Y and Z):
    
        Centered_Breakthrough_Site_Points = [Centered_Activated_Electrode_X_Location, Centered_Activated_Electrode_Y_Location, Centered_Activated_Electrode_Z_Location];

        Origin_X_Vector = [1; 0; 0]; 
        Origin_Y_Vector = [0; 1; 0]; 
        Origin_Z_Vector = [0; 0; 1]; 
        
        Rotate_to_X_Axis_Values = vrrotvec(Centered_Breakthrough_Site_Centroid, Origin_X_Vector);

        Rotate_to_X_Axis_Matrix = vrrotvec2mat(Rotate_to_X_Axis_Values);

        Rotated_Breakthrough_Site_Points = Centered_Breakthrough_Site_Points * Rotate_to_X_Axis_Matrix';

        Rotated_Upsampled_Points = Centered_Upsampled_Points * Rotate_to_X_Axis_Matrix';
        
        Global_Projected_Points = Rotated_Breakthrough_Site_Points(:, 2:3);
        
        % Plot to Validate the Results:
        
            figure(4);
            
                hold on;
                
                    pcshow(Rotated_Upsampled_Points, 'w');
                    
                    scatter3(Rotated_Breakthrough_Site_Points(:, 1), Rotated_Breakthrough_Site_Points(:, 2), Rotated_Breakthrough_Site_Points(:, 3), 'r');
                
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
            
            [Ellipse_Information] = Calculate_Ellipse_Parameters_Function(Ellipse_Structure, Horizontal_Line, Vertical_Line);
            
        end
        