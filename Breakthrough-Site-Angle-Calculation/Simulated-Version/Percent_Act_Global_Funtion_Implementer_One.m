
% Script to Determine the Parameters Corresponding to the Angle of the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.2;
        Percent_into_QRS_Peak = 0.5;
        
        Electrodes_Stimulated = 910;
    
    % Load in Data:

        Data = load(strcat('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Simulated-Version/SCIRun-Scripts/Results/14-10-27-Simulated-Electrodes', num2str(Electrodes_Stimulated), '.mat'));
        
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

% Script to Center the Sock Coordinates at the Origin:

    % Find Centroid:
    
        Sock_Centroid = [mean(Upsampled_Points(:, 1)); mean(Upsampled_Points(:, 2)); mean(Upsampled_Points(:, 3))];
        
    % Translate Centroid to the Origin:
    
        Centered_Upsampled_Points = Upsampled_Points - Sock_Centroid';
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine Coordinates in the Breakthrough Site:

    % Functions: Determine Which Electrodes Have a Activation Time Less than the Set QRS Time.

    [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Percent_Act_Breakthrough_Site_Electrode_Determination_Function(Centered_Upsampled_Points, Upsampled_Activation_Times, Percent_into_QRS_Peak);
    
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
            
% Script to "Fit" A Global Plane to Breakthrough Site:

    % Functions: Fits a Vector from the Sock Centroid to the Breakthrough Site Centroid and Rotates to the Nearest Axis.
    
    [Global_Projected_Points, Implemented_Points] = Global_Plane_Fitting_Function(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location);
    
    % Plot to Validate Results:
    
        figure(3);
        
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

                    figure(4)

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
        