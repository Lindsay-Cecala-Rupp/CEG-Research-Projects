
% Script to Calculate the Breakthrough Site and Average Fiber Orientation in the Same Reference Field:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Both Calculations:
    
        Stimulation_Electrode_Location = 12;
        
        Phi_Long_Axis_Range = 0.1;
        Rho_Long_Axis_Range = 0.1;

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

        Breakthrough_Site_Sock_Points = [Activated_Electrode_Sock_X_Location, Activated_Electrode_Sock_Y_Location, Activated_Electrode_Sock_Z_Location]';
                Breakthrough_Site_Sock_Points = Breakthrough_Site_Sock_Points';
            
        % Plot to Validate Results:

            figure(4);

                hold on;
                
                    pcshow(Centered_CARP_Heart_Points, 'w');

                    pcshow(Centered_Upsampled_Sock_Points, 'r');
                    
                    pcshow(Centered_CARP_Heart_Surface_Points, 'y');
                    
                    scatter3(Centered_Coordinate_of_Interest(1), Centered_Coordinate_of_Interest(2), Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');
                    
                    scatter3(Activated_Electrode_Sock_X_Location, Activated_Electrode_Sock_Y_Location, Activated_Electrode_Sock_Z_Location, 'ob');

                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    zlabel('Z-Axis');

                hold off;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Approximate the Long Axis of the Heart and Set Equal to the Z-Axis:
    
        % Pull UVC Coordinate Index Values with A Rho Value of 0.5, V Value of -1, Phi Value of 0, and a varrying Z Value:

            Rho_UVC_Indicies_of_Interest = find((UVC_RHO < (0.5 + Rho_Long_Axis_Range)) & (UVC_RHO > (0.5 - Rho_Long_Axis_Range))); % Perform Rho Range Determination
            V_UVC_Indicies_of_Interest = find(UVC_V == -1); % Perform V Range Determination
            Phi_UVC_Indicies_of_Interest = find((UVC_PHI < (0 + Phi_Long_Axis_Range)) & (UVC_PHI > (0 - Phi_Long_Axis_Range))); % Perform Phi Range Determination
                  
            % Determine Intersecting Coordinates: 
            
                UVC_Indicies_of_Interest = intersect(Rho_UVC_Indicies_of_Interest, V_UVC_Indicies_of_Interest);
                UVC_Indicies_of_Interest = intersect(UVC_Indicies_of_Interest, Phi_UVC_Indicies_of_Interest);
                
                Long_Axis_Points_of_Interest_from_UVC = Centered_CARP_Heart_Points(UVC_Indicies_of_Interest, :);
                    Long_Axis_Points_of_Interest_from_UVC = Long_Axis_Points_of_Interest_from_UVC';
      
        % Fit an Line to the Resulting Points and Create a Vector:
        
            Mean_of_Long_Axis_Points_of_Interest_from_UVC = mean(Long_Axis_Points_of_Interest_from_UVC, 2);
            
            Centered_Long_Axis_Points_of_Interest_from_UVC = Long_Axis_Points_of_Interest_from_UVC - Mean_of_Long_Axis_Points_of_Interest_from_UVC;
            
            [SVD_U, SVD_S, ~] = svd(Centered_Long_Axis_Points_of_Interest_from_UVC);
            
            SVD_D = SVD_U(:, 1);
            
            SVD_T = SVD_D' * Centered_Long_Axis_Points_of_Interest_from_UVC;
            
            SVD_T_Minimum = min(SVD_T);
            SVD_T_Maximum = max(SVD_T);
            
            Long_Axis_Fitted_Line = Mean_of_Long_Axis_Points_of_Interest_from_UVC + [SVD_T_Minimum, SVD_T_Maximum] .* SVD_D;
                Point_One = [Long_Axis_Fitted_Line(1, 1), Long_Axis_Fitted_Line(2, 1), Long_Axis_Fitted_Line(3, 1)];
                Point_Two = [Long_Axis_Fitted_Line(1, 2), Long_Axis_Fitted_Line(2, 2), Long_Axis_Fitted_Line(3, 2)];
            
            CARP_Heart_Long_Axis_Vector = Point_One - Point_Two;
                CARP_Heart_Long_Axis_Vector = CARP_Heart_Long_Axis_Vector / norm(CARP_Heart_Long_Axis_Vector);
        
            % Plot to Validate the Results:
                
                figure(5);

                    hold on;

                        pcshow(Centered_CARP_Heart_Surface_Points, 'w');

                        pcshow(Long_Axis_Points_of_Interest_from_UVC', 'r');
                        
                        quiver3(0, 0, 0, CARP_Heart_Long_Axis_Vector(1) * 50, CARP_Heart_Long_Axis_Vector(2) * 50, CARP_Heart_Long_Axis_Vector(3) * 50, 'b');

                        quiver3(0, 0, 0, 0, 0, -50, 'g');
                        
                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');
                        
                    hold off;
                    
        % Apply Rotation:
        
            Origin_Z_Vector = [0, 0, 1];
            
            Long_Axis_Orientation_Rotation_Values = vrrotvec(CARP_Heart_Long_Axis_Vector, Origin_Z_Vector);   
            Long_Axis_Orientation_Rotation_Matrix = vrrotvec2mat(Long_Axis_Orientation_Rotation_Values);

            Rotated_Breakthrough_Site_Sock_Points = Breakthrough_Site_Sock_Points * Long_Axis_Orientation_Rotation_Matrix';

            Rotated_Centered_CARP_Heart_Points = Centered_CARP_Heart_Points * Long_Axis_Orientation_Rotation_Matrix';

            Rotated_Centered_Upsampled_Sock_Points = Centered_Upsampled_Sock_Points * Long_Axis_Orientation_Rotation_Matrix';

            Rotated_Centered_Coordinate_of_Interest = Centered_Coordinate_of_Interest * Long_Axis_Orientation_Rotation_Matrix';

            Rotated_Centered_CARP_Heart_Surface_Points = Centered_CARP_Heart_Surface_Points * Long_Axis_Orientation_Rotation_Matrix';

            Rotated_Once_Fiber_Orientation = Fiber_Orientation * Long_Axis_Orientation_Rotation_Matrix';
            
            % Plot to Validate the Results:
            
                figure(6);
                
                    hold on;
                    
                        pcshow(Rotated_Centered_CARP_Heart_Points, 'w');

                        pcshow(Rotated_Centered_Upsampled_Sock_Points, 'r');

                        pcshow(Rotated_Centered_CARP_Heart_Surface_Points, 'y');
                        
                        pcshow(Rotated_Breakthrough_Site_Sock_Points, 'b');

                        scatter3(Rotated_Centered_Coordinate_of_Interest(1), Rotated_Centered_Coordinate_of_Interest(2), Rotated_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');
                        
                    hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Rotate the Data so that the Breakthrough Site Projection is Successful:
    
        % Determine the Centroid of the Breakthrough Site:
        
            Rotated_Once_Breakthrough_Site_Centroid = mean(Rotated_Breakthrough_Site_Sock_Points);
            
        % Shift Heart so that the Breakthrough Site is Perpendicular to the Z Axis at the Origin:
        
            Centered_Rotated_Breakthrough_Site_Sock_Points = Rotated_Breakthrough_Site_Sock_Points - [0, 0, Rotated_Once_Breakthrough_Site_Centroid(3)];

            Centered_Rotated_Centered_CARP_Heart_Points = Rotated_Centered_CARP_Heart_Points - [0, 0, Rotated_Once_Breakthrough_Site_Centroid(3)];

            Centered_Rotated_Centered_Upsampled_Sock_Points = Rotated_Centered_Upsampled_Sock_Points - [0, 0, Rotated_Once_Breakthrough_Site_Centroid(3)];

            Centered_Rotated_Centered_Coordinate_of_Interest = Rotated_Centered_Coordinate_of_Interest - [0, 0, Rotated_Once_Breakthrough_Site_Centroid(3)];

            Centered_Rotated_Centered_CARP_Heart_Surface_Points = Rotated_Centered_CARP_Heart_Surface_Points - [0, 0, Rotated_Once_Breakthrough_Site_Centroid(3)];

        % Create Vector:
        
            Breakthrough_Site_Vector = [Rotated_Once_Breakthrough_Site_Centroid(1), Rotated_Once_Breakthrough_Site_Centroid(2), 0];
            
            % Plot to Validate the Results:
            
                figure(7);
                
                    hold on;
                    
                        pcshow(Centered_Rotated_Centered_CARP_Heart_Points, 'w');

                        pcshow(Centered_Rotated_Centered_Upsampled_Sock_Points, 'r');

                        pcshow(Centered_Rotated_Centered_CARP_Heart_Surface_Points, 'y');
                        
                        pcshow(Centered_Rotated_Breakthrough_Site_Sock_Points, 'b');

                        scatter3(Centered_Rotated_Centered_Coordinate_of_Interest(1), Centered_Rotated_Centered_Coordinate_of_Interest(2), Centered_Rotated_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                        quiver3(0, 0, 0, Breakthrough_Site_Vector(1), Breakthrough_Site_Vector(2), Breakthrough_Site_Vector(3), 'g');
                        
                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');
                        
                    hold off;
                    
        % Apply Rotation so Vector is Equal to the X-Axis:
        
            Origin_X_Vector = [1, 0, 0];
        
            Projection_Rotation_Values = vrrotvec(Breakthrough_Site_Vector, Origin_X_Vector);   
            Projection_Rotation_Matrix = vrrotvec2mat(Projection_Rotation_Values);
            
            Rotated_Centered_Rotated_Breakthrough_Site_Sock_Points = Rotated_Breakthrough_Site_Sock_Points * Projection_Rotation_Matrix';

            Rotated_Centered_Rotated_Centered_CARP_Heart_Points = Rotated_Centered_CARP_Heart_Points * Projection_Rotation_Matrix';

            Rotated_Centered_Rotated_Centered_Upsampled_Sock_Points = Rotated_Centered_Upsampled_Sock_Points * Projection_Rotation_Matrix';

            Rotated_Centered_Rotated_Centered_Coordinate_of_Interest = Rotated_Centered_Coordinate_of_Interest * Projection_Rotation_Matrix';

            Rotated_Centered_Rotated_Centered_CARP_Heart_Surface_Points = Rotated_Centered_CARP_Heart_Surface_Points * Projection_Rotation_Matrix';

            Rotated_Twice_Fiber_Orientation = Rotated_Once_Fiber_Orientation * Projection_Rotation_Matrix';
            
            % Plot to Validate the Results:
            
                figure(8);
                
                    hold on;
                    
                        pcshow(Rotated_Centered_Rotated_Centered_CARP_Heart_Points, 'w');

                        pcshow(Rotated_Centered_Rotated_Centered_Upsampled_Sock_Points, 'r');

                        pcshow(Rotated_Centered_Rotated_Centered_CARP_Heart_Surface_Points, 'y');
                        
                        pcshow(Rotated_Centered_Rotated_Breakthrough_Site_Sock_Points, 'b');

                        scatter3(Rotated_Centered_Rotated_Centered_Coordinate_of_Interest(1), Rotated_Centered_Rotated_Centered_Coordinate_of_Interest(2), Rotated_Centered_Rotated_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');
                        
                    hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Finish Calculating the Information about the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Remove Points in the Set of Points that is Equivalent to the Rotated Axis in Order to "Project" the Breakthrough Site:
        
        Global_Projected_Breakthrough_Site_Sock_Points = [Rotated_Centered_Rotated_Breakthrough_Site_Sock_Points(:, 2), Rotated_Centered_Rotated_Breakthrough_Site_Sock_Points(:, 3)];
        
        % Plot to Validate the Results:
        
            figure(9);
            
                hold on;
                
                    scatter(Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Global_Projected_Breakthrough_Site_Sock_Points(:, 2), 'ok');
                
                hold off;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Fit an Ellipse to the Data Points:

        [Breakthrough_Site_Ellipse_Structure, Breakthrough_Site_Ellipse_Vertical_Line, Breakthrough_Site_Ellipse_Horizontal_Line, Breakthrough_Site_Ellipse] = Fit_an_Ellipse_Function(Global_Projected_Breakthrough_Site_Sock_Points);
            % Functions: Fits an Ellipse to the Data Points Using Conics.
        
            % Plot to Validate the Results:

                % If Statement to Check if Structure is Empty:

                    if size(Breakthrough_Site_Ellipse_Structure.a,1) == 0

                    else

                        figure(10)

                            hold on;

                                scatter(Global_Projected_Breakthrough_Site_Sock_Points(:, 1), Global_Projected_Breakthrough_Site_Sock_Points(:, 2), 'k');

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

                [Breakthrough_Site_Ellipse_Information] = Calculate_Ellipse_Parameters_Function(Breakthrough_Site_Ellipse_Structure, Breakthrough_Site_Ellipse_Horizontal_Line, Breakthrough_Site_Ellipse_Vertical_Line);
                    % Functions: Calculate the Area, Axis Ratio, Long Axis Angle and Short Axis Angle.
                
            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Script to Finish Calculating the Information about the Average Fiber Angle:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Fiber Indicies of Interest:

        [Fiber_Core_Indicies, CARP_Heart_Element_Centroids, Stimulation_Site, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Rotated_Centered_Rotated_Centered_Coordinate_of_Interest, Number_of_Stimulation_Site_Centroid_Points, Number_of_Stimulation_Site_Centroid_Points, Fiber_Core_Radius, Rotated_Centered_Rotated_Centered_CARP_Heart_Points, CARP_Heart_Elements, Rotated_Centered_Rotated_Centered_Upsampled_Sock_Points, Upsampled_Sock_Activation_Times);

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
    
        Long_Axis_Vector = [0, 0, 1];

        [Imbrication_Angles, Fiber_Angles] = Calculate_Specific_Fiber_Angle(CARP_Heart_Element_Centroids, Fiber_Core_Indicies, Rotated_Twice_Fiber_Orientation, Rotated_Centered_Rotated_Centered_CARP_Heart_Points, UVC_Coordinates, UVC_RHO, UVC_PHI, UVC_Z, Fiber_Plane_Grid_Resolution, Phi_Fiber_Plane_Range, Z_Fiber_Plane_Range, Rho_Fiber_Plane_Range, Long_Axis_Vector);
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Calculate the Average Fiber Angle:

        Element_Centroids_of_Interest = CARP_Heart_Element_Centroids(Fiber_Core_Indicies, :);

        [Mean_Fiber_Angle, STD_Fiber_Angle] = Calculate_Average_of_Fiber_Angles_Function(Fiber_Angles, Element_Centroids_of_Interest, Stimulation_Site, Heart_Surface_Point, Fiber_Core_Division_Value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
