
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

        Data = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Sock/14-10-27-Simulated-Electrodes', num2str(Electrodes_Stimulated), '.mat'));
        
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

% Script to Determine the Long Axis of the Heart:

    [Ellipsoid_Center, Ellipsoid_Radii, Ellipsoid_Vectors, Ellipsoid_Equation, Ellipsoid_Error] = Fit_Ellipsoid_to_Points([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)], '');
    
    % Determine the Point on the Long Axis Closest to the Centroid of the Breakthrough Site:
    
        % Create a Line Along the Vector with 1000 Points Along it:
        
            Long_Axis_Variable = linspace((min(min(Upsampled_Points)) - 50), (max(max(Upsampled_Points)) + 50), 10000);
        
            Long_Axis_Vector_X = Ellipsoid_Center(1) + Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
            Long_Axis_Vector_Y = Ellipsoid_Center(2) + Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
            Long_Axis_Vector_Z = Ellipsoid_Center(3) + Long_Axis_Variable * Ellipsoid_Vectors(3, 1);
    
            Long_Axis_Components = [Long_Axis_Vector_X; Long_Axis_Vector_Y; Long_Axis_Vector_Z];
            
        % Determine the Closest Point to the Breakthrough Cite Centroid:
        
            Breakthrough_Site_Centroid = [mean(Activated_Electrode_X_Location); mean(Activated_Electrode_Y_Location); mean(Activated_Electrode_Z_Location)];
            
            Long_Axis_Closest_Index = dsearchn(Long_Axis_Components', Breakthrough_Site_Centroid');
            
            % For Future Calculations - I Want this Points to be at the Origin:
            
                Centered_Activated_Electrode_X_Location = Activated_Electrode_X_Location - Long_Axis_Vector_X(Long_Axis_Closest_Index);
                Centered_Activated_Electrode_Y_Location = Activated_Electrode_Y_Location - Long_Axis_Vector_Y(Long_Axis_Closest_Index);
                Centered_Activated_Electrode_Z_Location = Activated_Electrode_Z_Location - Long_Axis_Vector_Z(Long_Axis_Closest_Index);
                
                Centered_Breakthrough_Site_Centroid = Breakthrough_Site_Centroid - Long_Axis_Components(:, Long_Axis_Closest_Index);
            
    % Plot the Results to Validate:

        Minimum_Sock_Value = min([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)]);
        Maximum_Sock_Value = max([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)]);
    
        Number_of_Plotting_Steps = 50;
        Step_Size = (Maximum_Sock_Value - Minimum_Sock_Value) / Number_of_Plotting_Steps;
        [Ellipsoid_X, Ellipsoid_Y, Ellipsoid_Z] = meshgrid(linspace(Minimum_Sock_Value(1) - Step_Size(1), Maximum_Sock_Value(1) + Step_Size(1), Number_of_Plotting_Steps), linspace(Minimum_Sock_Value(2) - Step_Size(2), Maximum_Sock_Value(2) + Step_Size(2), Number_of_Plotting_Steps), linspace(Minimum_Sock_Value(3) - Step_Size(3), Maximum_Sock_Value(3) + Step_Size(3), Number_of_Plotting_Steps));

        Ellipsoid_Points = Ellipsoid_Equation(1) * Ellipsoid_X .* Ellipsoid_X + Ellipsoid_Equation(2) * Ellipsoid_Y .* Ellipsoid_Y + Ellipsoid_Equation(3) * Ellipsoid_Z .* Ellipsoid_Z + 2 * Ellipsoid_Equation(4) * Ellipsoid_X .* Ellipsoid_Y + 2 * Ellipsoid_Equation(5) * Ellipsoid_X .* Ellipsoid_Z + 2 * Ellipsoid_Equation(6) * Ellipsoid_Y .* Ellipsoid_Z + 2 * Ellipsoid_Equation(7) * Ellipsoid_X + 2 * Ellipsoid_Equation(8) * Ellipsoid_Y + 2 * Ellipsoid_Equation(9) * Ellipsoid_Z;
        
        figure(3);
        
            hold on;
            
                plot3(Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3), '.r' );
                
                Patched_Ellipsoid_Points = patch(isosurface(Ellipsoid_X, Ellipsoid_Y, Ellipsoid_Z, Ellipsoid_Points, -Ellipsoid_Equation(10)));
                
                    set(Patched_Ellipsoid_Points, 'FaceColor', 'g', 'EdgeColor', 'none' );
        
                quiver3(Ellipsoid_Center(1), Ellipsoid_Center(2), Ellipsoid_Center(3), Ellipsoid_Vectors(1, 1)*100, Ellipsoid_Vectors(2, 1)*100, Ellipsoid_Vectors(3, 1)*100, 'k');
                
                plot3(Long_Axis_Vector_X, Long_Axis_Vector_Y, Long_Axis_Vector_Z, 'b');
                
                scatter3(Long_Axis_Vector_X(Long_Axis_Closest_Index), Long_Axis_Vector_Y(Long_Axis_Closest_Index), Long_Axis_Vector_Z(Long_Axis_Closest_Index), 'ob');
                
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
                
                title('Fitted Ellipsoid');
                
                axis vis3d equal;
                camlight;
                lighting phong;
                
            hold off;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
% Script to "Fit" A Global Plane to Breakthrough Site:

    % Functions: Fits a Vector from the Sock Centroid to the Breakthrough Site Centroid and Rotates to the Nearest Axis.
    
    [Global_Projected_Points, Implemented_Points] = Global_Plane_Fitting_Function_Long_Axis(Centered_Breakthrough_Site_Centroid, Centered_Activated_Electrode_X_Location, Centered_Activated_Electrode_Y_Location, Centered_Activated_Electrode_Z_Location);
    
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