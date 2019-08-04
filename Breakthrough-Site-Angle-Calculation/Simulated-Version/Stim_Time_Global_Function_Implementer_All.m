
% Script to Determine the Parameters Corresponding to the Angle of the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.2;
        Run_Values = [12, 23, 34, 45, 56, 67, 78, 89, 910];
    
    % Load in Data:

        Geometry = load('/Users/lindsayrupp/Documents/CEG Research/Breakthrough Site Angle Calculation/Stimulated Version/Data/CARP_Sock_Biomesh_Space.mat');
            Points = Geometry.scirunfield.node;
            Faces = Geometry.scirunfield.face;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Go Through All of the Runs and Calculate Everything:

    for First_Index = 1:size(Run_Values, 2)

        Activation = load(strcat('/Users/lindsayrupp/Documents/CEG Research/Current MATLAB/Stimulated Version/Data/act_needle_', num2str(Run_Values(1, First_Index)), '.txt'));
            Activation_Times = Activation(:, 1)';
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Up Sample Sock Using Barycentric Coordinates:

            % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.

            [Upsampled_Points, Upsampled_Activation_Times] = Barycentricly_Upsample_Sock_Function(Points, Faces, Activation_Times, Grid_Resolution);

% %             % Plot to Validate Results:
% % 
% %                 figure(1);
% % 
% %                     hold on;
% % 
% %                         plot3(Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3), '.k')
% % 
% %                         xlabel('X-Axis');
% %                         ylabel('Y-Axis');
% %                         zlabel('Z-Axis');
% % 
% %                         title('Barycentricly UpSampled Sock');
% % 
% %                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Center the Sock Coordinates at the Origin:

            % Find Centroid:

                Sock_Centroid = [mean(Upsampled_Points(:, 1)); mean(Upsampled_Points(:, 2)); mean(Upsampled_Points(:, 3))];

            % Translate Centroid to the Origin:

                Centered_Upsampled_Points = Upsampled_Points - Sock_Centroid';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Go Through Various QRS on Time Points and Calcualte Ellipse Information:

            for Second_Index = (ceil(min(Upsampled_Activation_Times)) + 1):(floor(max(Upsampled_Activation_Times)) - 1)

                % Script to Determine Coordinates in the Breakthrough Site:

                    % Functions: Determine Which Electrodes Have a Activation Time Less than the Set QRS Time.

                    [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Time_Breakthrough_Site_Electrode_Determination_Function(Centered_Upsampled_Points, Upsampled_Activation_Times, Second_Index);

% %                     % Plot to Validate Results:
% %         
% %                         figure(2);
% %         
% %                             hold on;
% %         
% %                                 scatter3(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location, 'k');
% %         
% %                                 xlabel('X-Axis');
% %                                 ylabel('Y-Axis');
% %                                 zlabel('Z-Axis');
% %         
% %                                 title('Original Breakthrough Site Coordinates');
% %         
% %                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Script to "Fit" A Global Plane to Breakthrough Site:

                    % Functions: Fits a Vector from the Sock Centroid to the Breakthrough Site Centroid and Rotates to the Nearest Axis.

                    [Global_Projected_Points, Implemented_Points] = Global_Plane_Fitting_Function(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location);

% %                     % Plot to Validate Results:
% %         
% %                         figure(3);
% %         
% %                             hold on;
% %         
% %                                 scatter(Global_Projected_Points(:, 1), Global_Projected_Points(:, 2), 'k');
% %         
% %                                 % If Statements to Determine Axis System:
% %         
% %                                     % Horizontal Axis:
% %         
% %                                         if Implemented_Points(1, 1) == 1
% %         
% %                                             xlabel('X-Axis');
% %         
% %                                         elseif Implemented_Points(1, 1) == 2
% %         
% %                                             xlabel('Y-Axis');
% %         
% %                                         elseif Implemented_Points(1, 1) == 3
% %         
% %                                             xlabel('Z-Axis');
% %         
% %                                         end
% %         
% %                                     % Vertical Axis:
% %         
% %                                         if Implemented_Points(1, 2) == 1
% %         
% %                                             ylabel('X-Axis');
% %         
% %                                         elseif Implemented_Points(1, 2) == 2
% %         
% %                                             ylabel('Y-Axis');
% %         
% %                                         elseif Implemented_Points(1, 2) == 3
% %         
% %                                             ylabel('Z-Axis');
% %         
% %                                         end
% %         
% %                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Script to Fit an Ellipse to the Data Points:

                    % Functions: Fits an Ellipse to the Data Points Using Conics.

                    [Ellipse_Structure, Vertical_Line, Horizontal_Line, Rotated_Ellipse] = Fit_an_Ellipse_Function(Global_Projected_Points);

% %                         % Plot to Validate the Results:
% %         
% %                             % If Statement to Check if Structure is Empty:
% %         
% %                                 if size(Ellipse_Structure.a,1) == 0
% %         
% %                                 else
% %         
% %                                     figure(4)
% %         
% %                                         hold on;
% %         
% %                                             scatter(Global_Projected_Points(:, 1), Global_Projected_Points(:, 2), 'k');
% %         
% %                                             plot(Vertical_Line(1,:),Vertical_Line(2,:),'r');
% %                                             plot(Horizontal_Line(1,:),Horizontal_Line(2,:),'r');
% %                                             plot(Rotated_Ellipse(1,:),Rotated_Ellipse(2,:),'r');
% %         
% %                                         hold off;
% %         
% %                                 end

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

                            [Compiled_Ellipse_Information.Run(First_Index).QRS_Time_Point(Second_Index)] = Calculate_Ellipse_Parameters_Function(Ellipse_Structure, Horizontal_Line, Vertical_Line);

                        end

            end
    
    end
 