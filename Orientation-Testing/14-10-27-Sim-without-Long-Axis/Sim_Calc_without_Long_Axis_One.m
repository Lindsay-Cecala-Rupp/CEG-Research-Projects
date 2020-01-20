
% Script to Calculate the Breakthrough Site and Average Fiber Orientation in the Same Reference Field:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Both Calculations:
    
        Stimulation_Electrode_Location = 12;

    % Breakthrough Site Specific Calculation:
    
        % Magic Numbers:

            Barycentric_Grid_Resolution = 0.2;
            
            Percent_into_QRS_Peak = 0.15;

        % Load in Data:

            Breakthrough_Site_Sock_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Sock/14-10-27-Simulated-Electrodes', num2str(Stimulation_Electrode_Location), '.mat'));
                Sock_Points = Breakthrough_Site_Sock_Data.Sock_US.node;
                Sock_Faces = Breakthrough_Site_Sock_Data.Sock_US.face;
                Sock_Activation_Times = Breakthrough_Site_Sock_Data.Sock_US.field;

    % Fiber Specific Calculation:

        % Magic Numbers:
        
            % Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Epicardial Site (910)
            Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Endocardial Site (12)

            Number_of_Stimulation_Site_Centroid_Points = 5;

            Fiber_Core_Radius = 2;

            Fiber_Core_Division_Value = 0.25;

            Fiber_Plane_Grid_Resolution = 0.1;
        
            Phi_Fiber_Plane_Range = 0.25;
            Z_Fiber_Plane_Range = 0.05;
            Rho_Fiber_Plane_Range = 0.05;

        % Load in Data:

            % Cartesian Model:

                Fiber_Orientation = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
                    Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

                CARP_Heart_Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
                    CARP_Heart_Points = CARP_Heart_Points/1000; % Scale Factor for CARP Node Locations of Ventricles

                CARP_Heart_Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
                    CARP_Heart_Elements = CARP_Heart_Elements + 1; % To Make One Based Nodes that Make up "Face"

                CARP_Heart_Surface_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Heart-Surface/14-10-27-Electrodes', num2str(Stimulation_Electrode_Location), '-Data-on-Surface.mat'));
                    CARP_Heart_Surface_Points = CARP_Heart_Surface_Data.scirunfield.node'; 
                    CARP_Heart_Surface_Activation_Times = CARP_Heart_Surface_Data.scirunfield.field;
                    
            % UVC Model:

                UVC_RHO = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_RHO.pts');
                    UVC_RHO = UVC_RHO(2:end, 1); % Ignore First Element

                UVC_PHI = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_PHI.pts');
                    UVC_PHI = UVC_PHI(2:end, 1); % Ignore First Element

                UVC_V = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_V.pts');
                    UVC_V = UVC_V(2:end, 1); % Ignore First Element

                UVC_Z = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_Z.pts');
                    UVC_Z = UVC_Z(2:end, 1); % Ignore First Element

                % Combine the UVC Coordinates:

                    UVC_Coordinates = [UVC_Z, UVC_RHO, UVC_PHI, UVC_V];
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % Script to Visualize all of the Data to Ensure Everything is in the Same Reference Space: 
% % 
% %     figure(1)
% %     
% %         hold on;
% %         
% %             pcshow(CARP_Heart_Points, 'w');
% %             
% %             pcshow(Sock_Points', 'r');
% %             
% %             xlabel('X-Axis');
% %             ylabel('Y-Axis');
% %             zlabel('Z-Axis');
% %         
% %         hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Orient the Necessary Data Dependent on the Location of the Breakthrough Site Centroid:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Up Sample Sock Using Barycentric Coordinates:

        [Upsampled_Sock_Points, Upsampled_Sock_Activation_Times] = Barycentricly_Upsample_Sock_Function(Sock_Points, Sock_Faces, Sock_Activation_Times, Barycentric_Grid_Resolution);
            % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.
            
% %         % Plot to Validate the Results:
% %         
% %             figure(2)
% %     
% %                 hold on;
% % 
% %                     pcshow(CARP_Heart_Points, 'w');
% % 
% %                     pcshow(Upsampled_Sock_Points, 'r');
% % 
% %                     xlabel('X-Axis');
% %                     ylabel('Y-Axis');
% %                     zlabel('Z-Axis');
% % 
% %                 hold off;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Center the Data so that the Centroid of the Sock is at the Origin:

        % Find Centroid of the Sock:

            Sock_Centroid = [mean(Upsampled_Sock_Points(:, 1)); mean(Upsampled_Sock_Points(:, 2)); mean(Upsampled_Sock_Points(:, 3))];

        % Translate Centroid to the Origin for all Data Components:

            Centered_Upsampled_Sock_Points = Upsampled_Sock_Points - Sock_Centroid';
            
            Centered_Coordinate_of_Interest = Coordinate_of_Interest - Sock_Centroid';
            
            Centered_CARP_Heart_Points = CARP_Heart_Points - Sock_Centroid';
            
            Centered_CARP_Heart_Surface_Points = CARP_Heart_Surface_Points - Sock_Centroid';
            
% %             % Plot to Validate the Results:
% %             
% %                 figure(3)
% %     
% %                     hold on;
% % 
% %                         pcshow(Centered_CARP_Heart_Points, 'w');
% % 
% %                         pcshow(Centered_Upsampled_Sock_Points, 'r');
% %                         
% %                         scatter3(Centered_Coordinate_of_Interest(1), Centered_Coordinate_of_Interest(2), Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');
% % 
% %                         xlabel('X-Axis');
% %                         ylabel('Y-Axis');
% %                         zlabel('Z-Axis');
% % 
% %                     hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Sock Coordinates in the Breakthrough Site:

        [Activated_Electrode_Sock_X_Location, Activated_Electrode_Sock_Y_Location, Activated_Electrode_Sock_Z_Location] = Percent_Act_Breakthrough_Site_Electrode_Determination_Function(Centered_Upsampled_Sock_Points, Upsampled_Sock_Activation_Times, Percent_into_QRS_Peak);
            % Functions: Determine Which Electrodes Have a Activation Time Less than the Set Percentage of the Total Acitvation Time.

        % Plot to Validate Results:

            figure(4);

                hold on;
                
                    pcshow(Centered_CARP_Heart_Points, 'w');

                    pcshow(Centered_Upsampled_Sock_Points, 'r');
                    
                    scatter3(Centered_Coordinate_of_Interest(1), Centered_Coordinate_of_Interest(2), Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                    scatter3(Activated_Electrode_Sock_X_Location, Activated_Electrode_Sock_Y_Location, Activated_Electrode_Sock_Z_Location, 'ob');

                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    zlabel('Z-Axis');

                hold off;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Rotate the Data so that the Breakthrough Site Projection is Successful:   
    
        % Script to Orient the Data so that the Base is Positive and Apex is Negative:
        
            Breakthrough_Site_Sock_Points = [Activated_Electrode_Sock_X_Location, Activated_Electrode_Sock_Y_Location, Activated_Electrode_Sock_Z_Location]';
                Breakthrough_Site_Sock_Points = Breakthrough_Site_Sock_Points';
            
            % Perform Negative Rotation or Rotation to Exact Same Position:
                % NOTE: THIS IS NOT AUTOMATIC YET !!!!!!!!!!
        
                Exists_Check = exist('Direction_Info');

                if Exists_Check ~= 1

                    Apex_Base_Orientation_Vector = 1 * [0; 0; 1];

                end
            
            % Apply Rotation:
            
                Origin_Z_Vector = [0; 0; 1];
            
                Apex_Base_Orientation_Rotation_Values = vrrotvec(Apex_Base_Orientation_Vector, Origin_Z_Vector);
                
                Apex_Base_Orientation_Rotation_Matrix = vrrotvec2mat(Apex_Base_Orientation_Rotation_Values);
                
                Rotated_Once_Breakthrough_Site_Sock_Points = Breakthrough_Site_Sock_Points * Apex_Base_Orientation_Rotation_Matrix';

                Rotated_Once_Centered_CARP_Heart_Points = Centered_CARP_Heart_Points * Apex_Base_Orientation_Rotation_Matrix';
                
                Rotated_Once_Centered_Upsampled_Sock_Points = Centered_Upsampled_Sock_Points * Apex_Base_Orientation_Rotation_Matrix';
                
                Rotated_Once_Centered_Coordinate_of_Interest = Centered_Coordinate_of_Interest * Apex_Base_Orientation_Rotation_Matrix';
                
                Rotated_Once_Centered_CARP_Heart_Surface_Points = Centered_CARP_Heart_Surface_Points * Apex_Base_Orientation_Rotation_Matrix';
                
                Rotated_Once_Fiber_Orientation = Fiber_Orientation * Apex_Base_Orientation_Rotation_Matrix';
                
                % Plot to Validate the Results:
                
                    figure(5);

                        hold on;

                            pcshow(Rotated_Once_Centered_CARP_Heart_Points, 'w');

                            pcshow(Rotated_Once_Centered_Upsampled_Sock_Points, 'r');

                            scatter3(Rotated_Once_Centered_Coordinate_of_Interest(1), Rotated_Once_Centered_Coordinate_of_Interest(2), Rotated_Once_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                            scatter3(Rotated_Once_Breakthrough_Site_Sock_Points(:, 1), Rotated_Once_Breakthrough_Site_Sock_Points(:, 2), Rotated_Once_Breakthrough_Site_Sock_Points(:, 3), 'ob');

                            quiver3(0, 0, 0, 0, 0, 75, 'g');
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            zlabel('Z-Axis');

                        hold off;
    
        % Calculate the Centroid of the Breakthrough Site:

            Breakthrough_Site_Centroid = mean(Rotated_Once_Breakthrough_Site_Sock_Points);

        % Create a Sock Centroid Vector and Coordinate Axis Vectors:

            % Coordinate Axis Vectors (X, Y and Z):

                Origin_X_Vector = [1; 0; 0]; 
                Origin_Y_Vector = [0; 1; 0];  

            % Breakthrough Site Vector:

                Breakthrough_Site_Centroid_Vector = [Breakthrough_Site_Centroid(1); Breakthrough_Site_Centroid(2); Breakthrough_Site_Centroid(3)];

        % Determine the Coordinate Axis that has the Smallest Angle to the Breakthrough Site Centroid Vector and Perform the Rotation:
        
            Rotate_to_X_Axis_Values = vrrotvec(Breakthrough_Site_Centroid_Vector, Origin_X_Vector);
            Rotate_to_Y_Axis_Values = vrrotvec(Breakthrough_Site_Centroid_Vector, Origin_Y_Vector);
            Rotate_Fiber_Core_to_Z_Axis_Values = vrrotvec(Breakthrough_Site_Centroid_Vector, Origin_Z_Vector);

            Combined_Rotation_Values = [Rotate_to_X_Axis_Values(1, 4), Rotate_to_Y_Axis_Values(1, 4), Rotate_Fiber_Core_to_Z_Axis_Values(1, 4)];

            [~, Minimum_Rotation_Angle_Location] = min(Combined_Rotation_Values);

            % Create Rotation Matrix Depending on Minimum Angle Value:

                if Minimum_Rotation_Angle_Location == 1

                    Axis_Project_Rotation_Matrix = vrrotvec2mat(Rotate_to_X_Axis_Values);

                elseif Minimum_Rotation_Angle_Location == 2

                    Axis_Project_Rotation_Matrix = vrrotvec2mat(Rotate_to_Y_Axis_Values);

                elseif Minimum_Rotation_Angle_Location == 3

                    Axis_Project_Rotation_Matrix = vrrotvec2mat(Rotate_Fiber_Core_to_Z_Axis_Values);

                end
                
            % Perform Rotation:

                Rotated_Twice_Breakthrough_Site_Sock_Points = Rotated_Once_Breakthrough_Site_Sock_Points * Axis_Project_Rotation_Matrix';
                
                Rotated_Once_Long_Axis_Vector = Origin_Z_Vector' * Axis_Project_Rotation_Matrix';
                
                Rotated_Twice_Centered_CARP_Heart_Points = Rotated_Once_Centered_CARP_Heart_Points * Axis_Project_Rotation_Matrix';
                
                Rotated_Twice_Centered_Upsampled_Sock_Points = Rotated_Once_Centered_Upsampled_Sock_Points * Axis_Project_Rotation_Matrix';
                
                Rotated_Twice_Centered_Coordinate_of_Interest = Rotated_Once_Centered_Coordinate_of_Interest * Axis_Project_Rotation_Matrix';
                
                Rotated_Twice_Centered_CARP_Heart_Surface_Points = Rotated_Once_Centered_CARP_Heart_Surface_Points * Axis_Project_Rotation_Matrix';
                
                Rotated_Twice_Fiber_Orientation = Rotated_Once_Fiber_Orientation * Axis_Project_Rotation_Matrix';
                
                % Plot to Validate the Results:
                
                figure(6);

                    hold on;

                        pcshow(Rotated_Twice_Centered_CARP_Heart_Points, 'w');

                        pcshow(Rotated_Twice_Centered_Upsampled_Sock_Points, 'r');

                        scatter3(Rotated_Twice_Centered_Coordinate_of_Interest(1), Rotated_Twice_Centered_Coordinate_of_Interest(2), Rotated_Twice_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                        pcshow(Rotated_Twice_Breakthrough_Site_Sock_Points, 'b');
                        
                        quiver3(0, 0, 0, Rotated_Once_Long_Axis_Vector(1) * 75, Rotated_Once_Long_Axis_Vector(2) * 75, Rotated_Once_Long_Axis_Vector(3) * 75, 'g');
                        quiver3(0, 0, 0, 0, 0, 75, 'g');
                        
                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');

                    hold off;
                    
        % Apply Inverse Rotation for Apex Base Calculation:
        
            Exists_Check = exist('Direction_Info');

            if Exists_Check ~= 1

                Inverse_Long_Axis_Orientation_Vector = -1 * Rotated_Once_Long_Axis_Vector;

            end
            
            Inverse_Long_Axis_Rotation_Values = vrrotvec(Rotated_Once_Long_Axis_Vector, Inverse_Long_Axis_Orientation_Vector);
            
            Inverse_Long_Axis_Rotation_Matrix = vrrotvec2mat(Inverse_Long_Axis_Rotation_Values);
            
            % Perform Rotation:
            
                Rotated_Thrice_Breakthrough_Site_Sock_Points = Rotated_Twice_Breakthrough_Site_Sock_Points * Inverse_Long_Axis_Rotation_Matrix';

                Rotated_Twice_Long_Axis_Vector = Rotated_Once_Long_Axis_Vector * Inverse_Long_Axis_Rotation_Matrix;

                Rotated_Thrice_Centered_CARP_Heart_Points = Rotated_Twice_Centered_CARP_Heart_Points * Inverse_Long_Axis_Rotation_Matrix';

                Rotated_Thrice_Centered_Upsampled_Sock_Points = Rotated_Twice_Centered_Upsampled_Sock_Points * Inverse_Long_Axis_Rotation_Matrix';

                Rotated_Thrice_Centered_Coordinate_of_Interest = Rotated_Twice_Centered_Coordinate_of_Interest * Inverse_Long_Axis_Rotation_Matrix';
                
                Rotated_Thrice_Centered_CARP_Heart_Surface_Points = Rotated_Twice_Centered_CARP_Heart_Surface_Points * Inverse_Long_Axis_Rotation_Matrix';
                
                Rotated_Thrice_Fiber_Orientation = Rotated_Twice_Fiber_Orientation * Inverse_Long_Axis_Rotation_Matrix';
                
                % Plot to Validate the Results:
                
                    figure(7);
                    
                        hold on;
                        
                            pcshow(Rotated_Thrice_Centered_CARP_Heart_Points, 'w');

                            pcshow(Rotated_Thrice_Centered_Upsampled_Sock_Points, 'r');

                            scatter3(Rotated_Thrice_Centered_Coordinate_of_Interest(1), Rotated_Thrice_Centered_Coordinate_of_Interest(2), Rotated_Thrice_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                            pcshow(Rotated_Thrice_Breakthrough_Site_Sock_Points, 'b');

                            quiver3(0, 0, 0, Rotated_Twice_Long_Axis_Vector(1) * 75, Rotated_Twice_Long_Axis_Vector(2) * 75, Rotated_Twice_Long_Axis_Vector(3) * 75, 'g');
                            quiver3(0, 0, 0, Rotated_Once_Long_Axis_Vector(1) * 75, Rotated_Once_Long_Axis_Vector(2) * 75, Rotated_Once_Long_Axis_Vector(3) * 75, 'g');
                            quiver3(0, 0, 0, 0, 0, 75, 'g');

                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            zlabel('Z-Axis');
                            
                        hold off;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Finish Calculating the Information about the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Remove Points in the Set of Points that is Equivalent to the Rotated Axis in Order to "Project" the Breakthrough Site:

        if Minimum_Rotation_Angle_Location == 1

            Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Twice_Breakthrough_Site_Sock_Points(:, 2), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 3)];
            Zeroed_Global_Projected_Breakthrough_Site_Sock_Points = [zeros(size(Rotated_Twice_Breakthrough_Site_Sock_Points, 1), 1), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 2), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 3)];
            
            Implemented_Points = [2, 3];

        elseif Minimum_Rotation_Angle_Location == 2

            Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Twice_Breakthrough_Site_Sock_Points(:, 1), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 3)];
            Zeroed_Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Twice_Breakthrough_Site_Sock_Points(:, 1), zeros(size(Rotated_Twice_Breakthrough_Site_Sock_Points, 1), 1), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 3)];
            
            Implemented_Points = [1, 3];

        elseif Minimum_Rotation_Angle_Location == 3

            Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Twice_Breakthrough_Site_Sock_Points(:, 1), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 2)];
            Zeroed_Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Twice_Breakthrough_Site_Sock_Points(:, 1), Rotated_Twice_Breakthrough_Site_Sock_Points(:, 2), zeros(size(Rotated_Twice_Breakthrough_Site_Sock_Points, 1), 1)];
            
            Implemented_Points = [1, 2];

        end

        % Plot to Validate the Results:

            figure(8);

                hold on;

                    scatter(Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Global_Projected_Breakthrough_Site_Sock_Points(:, 2), 'ok');

                    xlabel('Horizontal-Axis');
                    ylabel('Vertical-Axis');

                hold off;
                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    % Script to Re-Orient the Projected Points to be in the Same Reference Field as the "New" Long Axis of the Heart:
    
        % Calculate the Rotation Matrix for the Coordinate Z-Axis and the "New" Long Axis of the Heart:
        
            Long_Axis_Orientation_Rotation_Values = vrrotvec(Rotated_Once_Long_Axis_Vector, Origin_Z_Vector);
                
            Long_Axis_Orientation_Rotation_Matrix = vrrotvec2mat(Long_Axis_Orientation_Rotation_Values); 
            
        % Perform the Rotation:
        
            Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points = Zeroed_Global_Projected_Breakthrough_Site_Sock_Points * Long_Axis_Orientation_Rotation_Matrix';
            
        % Remove Coordinate Again:
        
            if Minimum_Rotation_Angle_Location == 1

                Rotated_Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points(:, 2), Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points(:, 3)];

            elseif Minimum_Rotation_Angle_Location == 2

                Rotated_Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points(:, 3)];

            elseif Minimum_Rotation_Angle_Location == 3

                Rotated_Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Rotated_Zeroed_Global_Projected_Breakthrough_Site_Sock_Points(:, 2)];

            end

% %             % Plot to Validate te Results:
% %         
% %                 figure(9);
% %                 
% %                     hold on;
% %                     
% %                         scatter(Rotated_Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Rotated_Global_Projected_Breakthrough_Site_Sock_Points(:, 2), 'ok');
% %                     
% %                         xlabel('Horizontal-Axis');
% %                         ylabel('Vertical-Axis');
% %                         
% %                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Fit an Ellipse to the Data Points:

        [Breakthrough_Site_Ellipse_Structure, Breakthrough_Site_Ellipse_Vertical_Line, Breakthrough_Site_Ellipse_Horizontal_Line, Breakthrough_Site_Ellipse] = Fit_an_Ellipse_Function(Rotated_Global_Projected_Breakthrough_Site_Sock_Points);
            % Functions: Fits an Ellipse to the Data Points Using Conics.
        
            % Plot to Validate the Results:

                % If Statement to Check if Structure is Empty:

                    if size(Breakthrough_Site_Ellipse_Structure.a,1) == 0

                    else

                        figure(10)

                            hold on;

                                scatter(Rotated_Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Rotated_Global_Projected_Breakthrough_Site_Sock_Points(:, 2), 'k');

                                plot(Breakthrough_Site_Ellipse_Vertical_Line(1, :), Breakthrough_Site_Ellipse_Vertical_Line(2, :), 'r');
                                plot(Breakthrough_Site_Ellipse_Horizontal_Line(1, :), Breakthrough_Site_Ellipse_Horizontal_Line(2, :), 'r');
                                plot(Breakthrough_Site_Ellipse(1, :), Breakthrough_Site_Ellipse(2, :), 'r');

                                xlabel('X-Axis');
                                ylabel('Y-Axis');
                                
                            hold off;

                    end
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
    % Script to Calculate the Parameters of the Fitted Ellipse:

        % Check to See if an Ellipse was Fitted in Order to Decide Whether or Not Parameters can be Calculated:

            if size(Breakthrough_Site_Ellipse_Structure.a, 1) == 0

                Ellipse_Information.Area = NaN;
                Ellipse_Information.Axis_Ratio = NaN;
                Ellipse_Information.Angle_for_Long_Axis = NaN;
                Ellipse_Information.Angle_for_Short_Axis = NaN;

            else

                [Breakthrough_Site_Ellipse_Ellipse_Information] = Calculate_Ellipse_Parameters_Function(Breakthrough_Site_Ellipse_Structure, Breakthrough_Site_Ellipse_Horizontal_Line, Breakthrough_Site_Ellipse_Vertical_Line);
                    % Functions: Calculate the Area, Axis Ratio, Long Axis Angle and Short Axis Angle.
                
            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Script to Finish Calculating the Information about the Average Fiber Angle:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Fiber Indicies of Interest:

        [Fiber_Core_Indicies, CARP_Heart_Element_Centroids, Stimulation_Site, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Rotated_Thrice_Centered_Coordinate_of_Interest, Number_of_Stimulation_Site_Centroid_Points, Number_of_Stimulation_Site_Centroid_Points, Fiber_Core_Radius, Rotated_Thrice_Centered_CARP_Heart_Points, CARP_Heart_Elements, Rotated_Thrice_Centered_Upsampled_Sock_Points, Upsampled_Sock_Activation_Times);

        % Plot to Validate the Results:

            Element_Centroid_Point_Cloud = pointCloud(CARP_Heart_Element_Centroids);
            Desired_Cylinder_Point_Cloud = select(Element_Centroid_Point_Cloud, Fiber_Core_Indicies);

            figure(11);

                hold on;

                    pcshow(Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
                    pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');

                    title('Selected Cylinder Points');
                    
                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    zlabel('Z-Axis');

                hold off;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Fiber Angle and Imbrication Angle for each of the Determined Fibers of Interest:

        [Imbrication_Angles, Fiber_Angles] = Calculate_Specific_Fiber_Angle(CARP_Heart_Element_Centroids, Fiber_Core_Indicies, Rotated_Thrice_Fiber_Orientation, Rotated_Thrice_Centered_CARP_Heart_Points, UVC_Coordinates, UVC_RHO, UVC_PHI, UVC_Z, Fiber_Plane_Grid_Resolution, Phi_Fiber_Plane_Range, Z_Fiber_Plane_Range, Rho_Fiber_Plane_Range, Rotated_Once_Long_Axis_Vector);
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Calculate the Average Fiber Angle:

        Element_Centroids_of_Interest = CARP_Heart_Element_Centroids(Fiber_Core_Indicies, :);

        [Mean_Fiber_Angle, STD_Fiber_Angle] = Calculate_Average_of_Fiber_Angles_Function(Fiber_Angles, Element_Centroids_of_Interest, Stimulation_Site, Heart_Surface_Point, Fiber_Core_Division_Value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
