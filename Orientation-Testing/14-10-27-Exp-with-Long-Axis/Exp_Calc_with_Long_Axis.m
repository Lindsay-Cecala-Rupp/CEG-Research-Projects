
% Script to Calculate the Average Fiber Orientation from DTI MRI:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Magic Numbers:
        
        Run_Number = 36;
        
        Stimulation_Electrode_Location = 12;

        Beat_Number = 1;

        Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Electrodes 12
        % Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Electrodes 910
        
        Plotting_On_Versus_Off = 2; % Note: If Equals One Everything will be Plotted, if it Equals any other Values Nothing will be Plotted
        
    % Simulation Data:
    
        Number_of_Stimulation_Site_Centroid_Points = 5;
        Number_of_Heart_Surface_Centroid_Points = 5;

        Fiber_Core_Radius = 2;

        Fiber_Core_Division_Value = 0.25;

        Fiber_Plane_Grid_Resolution = 0.1;

        Phi_Fiber_Plane_Range = 0.25;
        Z_Fiber_Plane_Range = 0.05;
        Rho_Fiber_Plane_Range = 0.05;
        
        % Cartesian Model:
        
            CARP_Heart_Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
                CARP_Heart_Points = CARP_Heart_Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            CARP_Heart_Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
                CARP_Heart_Elements = CARP_Heart_Elements + 1; % To Make One Based Nodes that Make up "Face"
                
            CARP_Heart_Surface_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Heart-Surface/14-10-27-Electrodes', num2str(Stimulation_Electrode_Location), '-Data-on-Surface.mat'));
                CARP_Heart_Surface_Points = CARP_Heart_Surface_Data.scirunfield.node'; 

        % UVC Model:

            UVC_Rho_Values = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_RHO.pts');
                UVC_Rho_Values = UVC_Rho_Values(2:end, 1); % Ignore First Element

            UVC_Phi_Values = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_PHI.pts');
                UVC_Phi_Values = UVC_Phi_Values(2:end, 1); % Ignore First Element

            UVC_V_Values = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_V.pts');
                UVC_V_Values = UVC_V_Values(2:end, 1); % Ignore First Element

            UVC_Z_Values = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_Z.pts');
                UVC_Z_Values = UVC_Z_Values(2:end, 1); % Ignore First Element

            % Combine the UVC Coordinates:

                UVC_Coordinates = [UVC_Z_Values, UVC_Rho_Values, UVC_Phi_Values, UVC_V_Values];
            
    % Experimental Data:
    
        Barycentric_Grid_Resolution = 0.2;
    
        % Sock Geometry:
        
            Sock_Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/Geometry-Files/14-10-27_Carp_Sock_Snapped.mat');
                Sock_Points = Sock_Geometry.Sock_US.node; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
                Sock_Faces = Sock_Geometry.Sock_US.face; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
    
        % DTI Fiber Field:
        
            DTI_Fiber_Orientation_Data = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Fiber-Orientation/14-10-27-Fiber-Field.mat');
                DTI_Fiber_Points = DTI_Fiber_Orientation_Data.scirunfield.node;
                    DTI_Fiber_Points = DTI_Fiber_Points';
                DTI_Fiber_Vectors = DTI_Fiber_Orientation_Data.scirunfield.field;
                DTI_Fiber_Elements = DTI_Fiber_Orientation_Data.scirunfield.cell;
                
                % Apply Translation Due to Offset:
                
                    DTI_Fiber_Points = DTI_Fiber_Points + [39.677, 40.8222, 47.3222];
    
        % Time Signal:

            % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
        
                if Run_Number > 0 && Run_Number <= 9

                    Number_of_Zeros = '000';

                elseif Run_Number > 9 && Run_Number <= 99 

                    Number_of_Zeros = '00';

                else

                    Number_of_Zeros = '0';

                end

            % Grab File:
            
                if Beat_Number == 0

                    Sock_Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Signals/PFEIFER-Processed-Signals-Option-One/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));   
                        Sock_ECG_Signal = Sock_Time_Signal.ts.potvals;

                else

                    Sock_Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Signals/PFEIFER-Processed-Signals-Option-One/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number),'-cs.mat'));
                        Sock_ECG_Signal = Sock_Time_Signal.ts.potvals;

                end
                
            % Laplacian Interpolation Files:
            
                Sock_Bad_Leads = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
                    Sock_Bad_Leads = Sock_Bad_Leads.Bad_Lead_Mask;
            
                Sock_Mapping_Matrix = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');
                    Sock_Mapping_Matrix = Sock_Mapping_Matrix.scirunmatrix;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Visualize the Data to Ensure Everything is in the Same Reference Space:

    if Plotting_On_Versus_Off == 1
        
        figure(1);
        
            hold on;
            
                scatter3(Coordinate_of_Interest(1), Coordinate_of_Interest(2), Coordinate_of_Interest(3), 25, '*g');
            
                pcshow(CARP_Heart_Points, 'w');
                
                scatter3(Sock_Points(1, :), Sock_Points(2, :), Sock_Points(3, :), 'or', 'filled');
                
                pcshow(DTI_Fiber_Points, 'b');
                
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
                
            hold off;

    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Interpolate and Upsample the Sock:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % From the Signal File Obtain the Fiducials:

        Fiducial_Structure = Sock_Time_Signal.ts.fids; % Load the Fiducials
        Fiducial_Types = [Fiducial_Structure.type]; 

        % QRS On:

            QRS_On_Fiducial = find(Fiducial_Types == 2); % 2 is QRS on 
            QRS_On_Time = Fiducial_Structure(QRS_On_Fiducial);
            QRS_On_Time = getfield(QRS_On_Time, 'value'); % Get QRS On Value

        % QRS Off:

            QRS_Off_Fiducial = find(Fiducial_Types == 4); % 4 is QRS off
            QRS_Off_Time = Fiducial_Structure(QRS_Off_Fiducial);
            QRS_Off_Time = getfield(QRS_Off_Time, 'value'); % Get QRS Off Values

        % Activation Times:

            Activation_Time_Fiducial = find(Fiducial_Types == 10); % 10 is Activation Time
            Activation_Time = Fiducial_Structure(Activation_Time_Fiducial);
            Activation_Time = getfield(Activation_Time, 'value'); % Get QRS Off Values
            
            % Overall Activation Time:

                Sock_Activation_Times = Activation_Time - QRS_On_Time; % Want to Find Electrodes with the Earliest/Smallest Activation Times

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Interpolate Around Bad Leads:

        % Create Vector Containing Activation Times for Only Good Leads:
        
            Bad_Lead_Value = find(Sock_Bad_Leads == 1);

            Zeroed_Activation_Times = Sock_Activation_Times;
            Zeroed_Activation_Times(Bad_Lead_Value) = 0;

        % Apply Mapping Matrix Obtained from SCIRun:

            % Note: Format: Mapping_Matrix (All X Good) * Good Leads (Good X 1) = Interpolated (All X 1).

                Interpolated_Sock_Activation_Times = Sock_Mapping_Matrix * Zeroed_Activation_Times;
                    Interpolated_Sock_Activation_Times = Interpolated_Sock_Activation_Times';    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Up Sample Sock Using Barycentric Coordinates:

        [Upsampled_Sock_Points, Upsampled_Sock_Activation_Times] = Barycentricly_Upsample_Sock_Function(Sock_Points, Sock_Faces, Interpolated_Sock_Activation_Times, Barycentric_Grid_Resolution);
            % Function: Create Barycentric Coordinates and Determines their Corresponding Activation Time.
            
        % Plot to Validate the Results:
        
            if Plotting_On_Versus_Off == 1
                
                figure(2);
                
                    hold on;
                    
                        scatter3(Coordinate_of_Interest(1), Coordinate_of_Interest(2), Coordinate_of_Interest(3), 25, '*g');
            
                        pcshow(CARP_Heart_Points, 'w');
                    
                        pcshow(Upsampled_Sock_Points, 'r');
                        
                        pcshow(DTI_Fiber_Points, 'b');
                        
                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');
                        
                    hold off;
                
            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Orient the Necessary Data Dependent on the Long Axis of the Heart:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Long Axis of the Heart:
    
        % Fit an Ellipsoid to the Sock:

            [Ellipsoid_Center, Ellipsoid_Radii, Ellipsoid_Vectors, Ellipsoid_Equation, Ellipsoid_Error] = Fit_Ellipsoid_to_Points([Upsampled_Sock_Points(:, 1), Upsampled_Sock_Points(:, 2), Upsampled_Sock_Points(:, 3)], '');

        % Determine the Point on the Long Axis Closest to the Centroid of the Sock and Set Equal to the Origin:

            % Create a Line Along the Vector with 10000 Points Along it:

                Long_Axis_Variable = linspace((min(min(Upsampled_Sock_Points)) - 50), (max(max(Upsampled_Sock_Points)) + 50), 10000);

                Long_Axis_Vector_X = Ellipsoid_Center(1) + Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
                Long_Axis_Vector_Y = Ellipsoid_Center(2) + Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
                Long_Axis_Vector_Z = Ellipsoid_Center(3) + Long_Axis_Variable * Ellipsoid_Vectors(3, 1);

                Long_Axis_Components = [Long_Axis_Vector_X; Long_Axis_Vector_Y; Long_Axis_Vector_Z];

            % Determine the Closest Point to the Sock Centroid:
            
                Sock_Centroid = mean(Upsampled_Sock_Points);

                Long_Axis_Closest_Index = dsearchn(Long_Axis_Components', Sock_Centroid);

            % Translate the System so this Point is at the Origin:

                Centered_Coordinate_of_Interest = Coordinate_of_Interest - Long_Axis_Components(:, Long_Axis_Closest_Index)';
                Centered_CARP_Heart_Points = CARP_Heart_Points - Long_Axis_Components(:, Long_Axis_Closest_Index)';
                Centered_Upsampled_Sock_Points = Upsampled_Sock_Points - Long_Axis_Components(:, Long_Axis_Closest_Index)';
                Centered_DTI_Fiber_Points = DTI_Fiber_Points - Long_Axis_Components(:, Long_Axis_Closest_Index)';
                Centered_CARP_Heart_Surface_Points = CARP_Heart_Surface_Points - Long_Axis_Components(:, Long_Axis_Closest_Index)';
                
            % Plot the Results to Validate:
            
                if Plotting_On_Versus_Off == 1

                    figure(3);

                        hold on;

                            scatter3(Centered_Coordinate_of_Interest(1), Centered_Coordinate_of_Interest(2), Centered_Coordinate_of_Interest(3), 25, '*g');

                            pcshow(Centered_CARP_Heart_Points, 'w');

                            pcshow(Centered_Upsampled_Sock_Points, 'r');

                            pcshow(Centered_DTI_Fiber_Points, 'b');
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            zlabel('Z-Axis');

                        hold off;
                    
                end
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
    % Script to Orient the Data so the Long Axis of the Heart is Equivalent to the Z-Axis:
    
        % Evaluate Which Direction it is Facing and Orientate it so the Base will be Positive and the Apex will be Negative:

            % Long Axis Vector Orientation Assignment:

                Exists_Check = exist('Long_Axis_Direction_Check');

                if Exists_Check == 1

                    Long_Axis_Vector = 1 * [Ellipsoid_Vectors(1, 1), Ellipsoid_Vectors(2, 1), Ellipsoid_Vectors(3, 1)];

                else

                    Long_Axis_Vector = -1 * [Ellipsoid_Vectors(1, 1), Ellipsoid_Vectors(2, 1), Ellipsoid_Vectors(3, 1)];

                end
                
        % Apply the Rotation:
        
            Origin_Z_Vector = [0; 0; 1]; 
            
            Rotate_to_Z_Axis_Values = vrrotvec(Long_Axis_Vector, Origin_Z_Vector);
            Rotate_to_Z_Axis_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);
            
            Rotated_Centered_Coordinate_of_Interest = Centered_Coordinate_of_Interest * Rotate_to_Z_Axis_Matrix';
            Rotated_Centered_CARP_Heart_Points = Centered_CARP_Heart_Points * Rotate_to_Z_Axis_Matrix';
            Rotated_Centered_Upsampled_Sock_Points = Centered_Upsampled_Sock_Points * Rotate_to_Z_Axis_Matrix';
            Rotated_Centered_DTI_Fiber_Points = Centered_DTI_Fiber_Points * Rotate_to_Z_Axis_Matrix';
            Rotated_Centered_CARP_Heart_Surface_Points = Centered_CARP_Heart_Surface_Points * Rotate_to_Z_Axis_Matrix';
            Rotated_DTI_Fiber_Vectors = DTI_Fiber_Vectors' * Rotate_to_Z_Axis_Matrix';
            
        % Plot to Validate the Results:
        
            if Plotting_On_Versus_Off == 1

                figure(4);

                    hold on;

                        scatter3(Rotated_Centered_Coordinate_of_Interest(1), Rotated_Centered_Coordinate_of_Interest(2), Rotated_Centered_Coordinate_of_Interest(3), 25, '*g');

                        pcshow(Rotated_Centered_CARP_Heart_Points, 'w');

                        pcshow(Rotated_Centered_Upsampled_Sock_Points, 'r');

                        pcshow(Rotated_Centered_DTI_Fiber_Points, 'b');

                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');

                    hold off;

            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% Script to Perform the Fiber Analysis:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Fiber Indicies of Interest:
    
        % Calculate the Centroid of Each Element:

            DTI_Fiber_Element_Centroids = zeros(size(DTI_Fiber_Elements, 1), 3);

            for First_Index = 1:size(DTI_Fiber_Elements, 2)

                Temporary_Element_Indicies = DTI_Fiber_Elements(:, First_Index);

                Temporary_Points = Rotated_Centered_DTI_Fiber_Points(Temporary_Element_Indicies, :);

                DTI_Fiber_Element_Centroids(First_Index, 1) = mean(Temporary_Points(:, 1));
                DTI_Fiber_Element_Centroids(First_Index, 2) = mean(Temporary_Points(:, 2));
                DTI_Fiber_Element_Centroids(First_Index, 3) = mean(Temporary_Points(:, 3));

            end

        % Find the Designated Number of Centroid Points Near the Point of Interest:

            Stimulation_Site_Index_Values = zeros(Number_of_Stimulation_Site_Centroid_Points, 1);

            Adjusted_DTI_Fiber_Element_Centroids = DTI_Fiber_Element_Centroids;

            for First_Index = 1:Number_of_Stimulation_Site_Centroid_Points

                Temporary_Closest_Position_Index = dsearchn(Adjusted_DTI_Fiber_Element_Centroids, Rotated_Centered_Coordinate_of_Interest);

                Adjusted_DTI_Fiber_Element_Centroids(Temporary_Closest_Position_Index, :) = Adjusted_DTI_Fiber_Element_Centroids(Temporary_Closest_Position_Index, :) * 5000;

                Stimulation_Site_Index_Values(First_Index, 1) = Temporary_Closest_Position_Index;

            end

        % Take the Average of the Determined Points and Use as Stimulation Site:

            Stimulation_Site(1, 1) = mean(DTI_Fiber_Element_Centroids(Stimulation_Site_Index_Values, 1));
            Stimulation_Site(1, 2) = mean(DTI_Fiber_Element_Centroids(Stimulation_Site_Index_Values, 2));
            Stimulation_Site(1, 3) = mean(DTI_Fiber_Element_Centroids(Stimulation_Site_Index_Values, 3));

        % Determine Points on the Sock with the Earliest Activation Time:

            Upsampled_Sock_Activation_Times(2, :) = 1:size(Upsampled_Sock_Activation_Times, 2);
            Upsampled_Sock_Activation_Times = sortrows(Upsampled_Sock_Activation_Times', 1);

            Heart_Surface_Site_Index_Values = Upsampled_Sock_Activation_Times(1:Number_of_Heart_Surface_Centroid_Points, 2);

        % Take the Average of the Determined Points and Use as Heart Surface Points:

            Heart_Surface_Site(1, 1) = mean(Rotated_Centered_Upsampled_Sock_Points(Heart_Surface_Site_Index_Values, 1));
            Heart_Surface_Site(1, 2) = mean(Rotated_Centered_Upsampled_Sock_Points(Heart_Surface_Site_Index_Values, 2));
            Heart_Surface_Site(1, 3) = mean(Rotated_Centered_Upsampled_Sock_Points(Heart_Surface_Site_Index_Values, 3));

        % Rotate the Heart so that the Two Points Correspond to the Z-Axis:

            % Center the Sock around the Stimulation_Site:

                Centered_DTI_Fiber_Element_Centroids = DTI_Fiber_Element_Centroids - Stimulation_Site;
                Centered_Heart_Surface_Site = Heart_Surface_Site - Stimulation_Site;

            % Create a Vector to the Two Points:

                Fiber_Core_Vector = Centered_Heart_Surface_Site';

            % Rotate the Vector to be at the Z - Axis:

                Rotate_to_Z_Axis_Values = vrrotvec(Fiber_Core_Vector, Origin_Z_Vector);
                Rotation_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

                Rotated_Centered_DTI_Fiber_Element_Centroids = Centered_DTI_Fiber_Element_Centroids * Rotation_Matrix';
                Rotated_Centered_Heart_Surface_Site = Centered_Heart_Surface_Site * Rotation_Matrix';

        % Create Rectangular Core and Include Desired Points:

            % Core Creation:

                Rectangular_Core_Height = Rotated_Centered_Heart_Surface_Site(1, 3);

            % Point Inclusion:

                Region_of_Interest = [(-Fiber_Core_Radius/2), (Fiber_Core_Radius/2), (-Fiber_Core_Radius/2), (Fiber_Core_Radius/2), 0, Rectangular_Core_Height];

                Rotated_Centered_Element_Centroid_Point_Cloud = pointCloud(Rotated_Centered_DTI_Fiber_Element_Centroids);

                Fiber_Core_Indicies = findPointsInROI(Rotated_Centered_Element_Centroid_Point_Cloud, Region_of_Interest);

        % Plot to Validate the Results:

            if Plotting_On_Versus_Off == 1

                DTI_Fiber_Element_Centroids_Point_Cloud = pointCloud(DTI_Fiber_Element_Centroids);
                Desired_Fiber_Core_Point_Cloud = select(DTI_Fiber_Element_Centroids_Point_Cloud, Fiber_Core_Indicies);

                figure(5);

                    hold on;

                        pcshow(DTI_Fiber_Element_Centroids_Point_Cloud.Location, [0.5, 0.5, 0.5]);
                        pcshow(Desired_Fiber_Core_Point_Cloud.Location, 'r');

                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');

                    hold off;

            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Calcualte the Corresponding Angle(s) for Each Fiber Vector Identified:
    
        for First_Index = 1:size(Fiber_Core_Indicies, 1)
    
            % Grab the Center Point for the Fiber Point and Determine a Range of Values Along Side of It:

                Temporary_Fiber_Anchor = DTI_Fiber_Element_Centroids(Fiber_Core_Indicies(First_Index, 1), :);
                Temporary_Fiber_Vector = Rotated_DTI_Fiber_Vectors(Fiber_Core_Indicies(First_Index, 1), :);

                % Find the UVC Coordiante that Cooresponds to the Centroid of the Desired Vector:
                
                    % Find the Closest Point that Corresponds to the Fiber Anchor:
                    
                        Temporary_CARP_Heart_Index = dsearchn(Rotated_Centered_CARP_Heart_Points, Temporary_Fiber_Anchor);
                
                        Temporary_CARP_Heart_Point = Rotated_Centered_CARP_Heart_Points(Temporary_CARP_Heart_Index, :);
                
                        UVC_Coordinate_of_Interest = UVC_Coordinates(Temporary_CARP_Heart_Index, :);

                % Pull UVC Indicies who Fall within a Set Range of Phi, Rho, V, and Z:

                    Phi_UVC_Indicies_of_Interest_Fiber_Plane = find((UVC_Phi_Values < (UVC_Coordinate_of_Interest(3) + Phi_Fiber_Plane_Range)) & (UVC_Phi_Values > (UVC_Coordinate_of_Interest(3) - Phi_Fiber_Plane_Range))); % Perform Phi Range Determination
                    Rho_UVC_Indicies_of_Interest_Fiber_Plane = find((UVC_Rho_Values < (UVC_Coordinate_of_Interest(2) + Rho_Fiber_Plane_Range)) & (UVC_Rho_Values > (UVC_Coordinate_of_Interest(2) - Rho_Fiber_Plane_Range))); % Perform Rho Range Determination
                    V_UVC_Indicies_of_Interest_Fiber_Plane = find(UVC_V_Values == UVC_Coordinate_of_Interest(4)); % Perform V Range Determination
                    Z_UVC_Indicies_of_Interest_Fiber_Plane = find((UVC_Z_Values < (UVC_Coordinate_of_Interest(1) + Z_Fiber_Plane_Range)) & (UVC_Z_Values > (UVC_Coordinate_of_Interest(1) - Z_Fiber_Plane_Range))); % Perform Z Range Determination

                    Desired_Fiber_Plane_Indicies = intersect(Phi_UVC_Indicies_of_Interest_Fiber_Plane, Rho_UVC_Indicies_of_Interest_Fiber_Plane);
                    Desired_Fiber_Plane_Indicies = intersect(Desired_Fiber_Plane_Indicies, V_UVC_Indicies_of_Interest_Fiber_Plane);
                    Desired_Fiber_Plane_Indicies = intersect(Desired_Fiber_Plane_Indicies, Z_UVC_Indicies_of_Interest_Fiber_Plane);

                % Put them into Cartesian Space:

                    Fiber_Plane_Points_of_Interest = Rotated_Centered_CARP_Heart_Points(Desired_Fiber_Plane_Indicies, :);

            % Fit a Plane to the Points of Interest for Angle Calculations:

                Fiber_Plane_Surface_Fit = fit([Fiber_Plane_Points_of_Interest(:, 1), Fiber_Plane_Points_of_Interest(:, 2)], Fiber_Plane_Points_of_Interest(:, 3), 'poly11', 'normalize', 'on');

                [Fiber_Plane_X, Fiber_Plane_Y] = meshgrid((min(Fiber_Plane_Points_of_Interest(:, 1))  - 5):Fiber_Plane_Grid_Resolution:(max(Fiber_Plane_Points_of_Interest(:, 1)) + 5), (min(Fiber_Plane_Points_of_Interest(:, 2)) - 5):Fiber_Plane_Grid_Resolution:(max(Fiber_Plane_Points_of_Interest(:, 2)) + 5));

                Fiber_Plane_Z = Fiber_Plane_Surface_Fit(Fiber_Plane_X, Fiber_Plane_Y);

                % Plot to Validate the Results:

                    if Plotting_On_Versus_Off == 1

                        figure(6);

                            hold on;

                                pcshow(DTI_Fiber_Element_Centroids(Fiber_Core_Indicies, :), 'w');

                                surf(Fiber_Plane_X, Fiber_Plane_Y, Fiber_Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');

                                quiver3(Temporary_Fiber_Anchor(1), Temporary_Fiber_Anchor(2), Temporary_Fiber_Anchor(3), Temporary_Fiber_Vector(1) * 10, Temporary_Fiber_Vector(2) * 10, Temporary_Fiber_Vector(3) * 10, 'g');

                                pcshow(Fiber_Plane_Points_of_Interest, 'b');

                                xlabel('X-Axis');
                                ylabel('Y-Axis');
                                xlabel('Z-Axis');

                            hold off;

                    end

            % Determine Information About the Plane in Order to do Necessary Calculations:

                % Snap the Fiber's Anchor onto the Calculated Plane:

                    Temporary_Fiber_Distance_to_Plane = zeros(size(Fiber_Plane_X, 1), size(Fiber_Plane_Z, 2));

                    for Second_Index = 1:size(Fiber_Plane_Z, 1)

                        for Third_Index = 1:size(Fiber_Plane_Z, 2)

                            Temporary_Fiber_Distance_to_Plane(Second_Index, Third_Index) = sqrt(((Temporary_Fiber_Anchor(1) - Fiber_Plane_X(Second_Index, Third_Index))^2) + ((Temporary_Fiber_Anchor(2) - Fiber_Plane_Y(Second_Index, Third_Index))^2) + ((Temporary_Fiber_Anchor(3) - Fiber_Plane_Z(Second_Index, Third_Index))^2));

                        end

                    end

                    Minimum_Fiber_Distance_to_Plane_Value = min(min(Temporary_Fiber_Distance_to_Plane));

                    Minimum_Fiber_Distance_to_Plane_Index = find(Temporary_Fiber_Distance_to_Plane == Minimum_Fiber_Distance_to_Plane_Value);

                    [Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index] = ind2sub(size(Temporary_Fiber_Distance_to_Plane), Minimum_Fiber_Distance_to_Plane_Index);

                    Temporary_Fiber_Anchor_Plane_Point = [Fiber_Plane_X(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index), Fiber_Plane_Y(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index), Fiber_Plane_Z(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index)];

                % Calcualte the Normal of the Plane - Want this to be Directed towards the Surface of the Heart:

                    % Create Two Vectors on the Plane that have Anchors at the Fiber Anchor Plane Point and Extend Outward:

                        % Plane Vector One:

                            Plane_Vector_One_Point = [Fiber_Plane_X(1, 1), Fiber_Plane_Y(1, 1), Fiber_Plane_Z(1, 1)];
                            Plane_Vector_One = Temporary_Fiber_Anchor_Plane_Point - Plane_Vector_One_Point;
                            Plane_Vector_One_Unit_Vector = Plane_Vector_One/(sqrt(Plane_Vector_One(1)^2 + Plane_Vector_One(2)^2 + Plane_Vector_One(3)^2));

                        % Plane Vector Two:

                            Plane_Vector_Two_Point = [Fiber_Plane_X(1, end), Fiber_Plane_Y(1, end), Fiber_Plane_Z(1, end)];
                            Plane_Vector_Two = Temporary_Fiber_Anchor_Plane_Point - Plane_Vector_Two_Point;
                            Plane_Vector_Two_Unit_Vector = Plane_Vector_Two/(sqrt(Plane_Vector_Two(1)^2 + Plane_Vector_Two(2)^2 + Plane_Vector_Two(3)^2));

                    % Calculate the Normal from the Two Determined Vectors:

                        Plane_Normal = cross(Plane_Vector_One_Unit_Vector, Plane_Vector_Two_Unit_Vector);
                        Plane_Normal_Unit_Vector = Plane_Normal/(sqrt(Plane_Normal(1)^2 + Plane_Normal(2)^2 + Plane_Normal(3)^3));

                    % Determine the Direction of the Normal Vector - Need it to be Pointing Towards the Surface of the Heart:

                        % Create Two New UVC Points - One Positive Ten Points Away and One Negative Ten Points Away:

                            Positive_Plane_Normal_Point_Cartesian = Temporary_Fiber_Anchor_Plane_Point + (10 * Plane_Normal_Unit_Vector);

                                Positive_Plane_Normal_Point_Index = dsearchn(Rotated_Centered_CARP_Heart_Points, Positive_Plane_Normal_Point_Cartesian);

                                Positive_Plane_Normal_Point_UVC = UVC_Coordinates(Positive_Plane_Normal_Point_Index, :);

                            Negative_Plane_Normal_Point_Cartesian = Temporary_Fiber_Anchor_Plane_Point - (10 * Plane_Normal_Unit_Vector);

                                Negative_Plane_Normal_Point_Index = dsearchn(Rotated_Centered_CARP_Heart_Points, Negative_Plane_Normal_Point_Cartesian);

                                Negative_Plane_Normal_Point_UVC = UVC_Coordinates(Negative_Plane_Normal_Point_Index, :);

                        % Determine which One Has the Larger RHO Value - Larger Value is Closer to the Surface of the Heart:

                            if Negative_Plane_Normal_Point_UVC(2) > Positive_Plane_Normal_Point_UVC(2)

                                Plane_Normal_Unit_Vector = -1 * Plane_Normal_Unit_Vector;

                            elseif Negative_Plane_Normal_Point_UVC(2) < Positive_Plane_Normal_Point_UVC(2)

                                Plane_Normal_Unit_Vector = 1 * Plane_Normal_Unit_Vector;

                            end

                % Plot to Validate the Results:

                    if Plotting_On_Versus_Off == 1

                        figure(7);

                            hold on;

                                surf(Fiber_Plane_X, Fiber_Plane_Y, Fiber_Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');

                                quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Temporary_Fiber_Vector(1) * 10, Temporary_Fiber_Vector(2) * 10, Temporary_Fiber_Vector(3) * 10, 'g');

                                quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Plane_Normal_Unit_Vector(1) * 10, Plane_Normal_Unit_Vector(2) * 10, Plane_Normal_Unit_Vector(3) * 10, 'c');

                                pcshow(Rotated_Centered_CARP_Heart_Surface_Points, 'y');
                                
                                xlabel('X-Axis');
                                ylabel('Y-Axis');
                                xlabel('Z-Axis');

                            hold off;

                    end

            % Determine the Fiber Orientation Angle - Imbrication and Plane Angle:

            % Calcualte the Imbrication Angle of the Fiber:

                % Calcualte the Angle Between the Normal and the Fiber Vector:

                    Temporary_Imbrication_Angle = atan2d(norm(cross(Temporary_Fiber_Vector, Plane_Normal_Unit_Vector)), dot(Temporary_Fiber_Vector, Plane_Normal_Unit_Vector));

                    % Determine the Correct Orientation for the Angle with Respect to a RHO Plane and Epicardium:

                        if Temporary_Imbrication_Angle > 90

                            Imbrication_Angle(First_Index, 1) = -1 * (90 - Temporary_Imbrication_Angle);

                        elseif Temporary_Imbrication_Angle < 90

                            Imbrication_Angle(First_Index, 1) = 90 - Temporary_Imbrication_Angle;

                        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Plane Angle:

                % Project Fiber onto the Plane - Remove Imbrication Component:

                    Fiber_Vector_Projectied_with_Normal = (dot(Temporary_Fiber_Vector, Plane_Normal_Unit_Vector) / (norm(Plane_Normal_Unit_Vector) ^ 2)) * Plane_Normal_Unit_Vector;
                    Projected_Fiber_Vector = Temporary_Fiber_Vector - Fiber_Vector_Projectied_with_Normal;
                    
                % Project Long-Axis Vector to Preform Angle Calculation in Plane:
                
                    Long_Axis_Vector = [0, 0, 1];

                    Long_Axis_Projection_with_Normal = (dot(Long_Axis_Vector, Plane_Normal_Unit_Vector)/(norm(Plane_Normal_Unit_Vector)^2)) * Plane_Normal_Unit_Vector;
                    Projected_Long_Axis_Unit_Vector = Long_Axis_Vector - Long_Axis_Projection_with_Normal;

                % Calculate a Vector Perpendicular to the Projected Z Unit Vector:

                    Horizontal_Plane_Vector_Option_One = cross(Projected_Long_Axis_Unit_Vector, Plane_Normal_Unit_Vector);
                    Horizontal_Plane_Vector_Option_Two = -1 * Horizontal_Plane_Vector_Option_One;

                    % Determien Orientation of the Horizontal by Choosing Component that Follows the "Right Hand Rule":

                        Cross_Product_Option_One = cross(Horizontal_Plane_Vector_Option_One, Projected_Long_Axis_Unit_Vector);
                        Cross_Product_Option_Two = cross(Horizontal_Plane_Vector_Option_Two, Projected_Long_Axis_Unit_Vector);

                        % Determine which Resulting Vector Points in the Same Direction as the Normal:

                            Plane_Normal_Unit_Sign = sign(Plane_Normal_Unit_Vector);

                            Cross_Product_Option_One_Sign = sign(Cross_Product_Option_One);
                            Cross_Product_Option_Two_Sign = sign(Cross_Product_Option_Two);

                            Cross_Product_Option_One_Sign_Summation = sum(Cross_Product_Option_One_Sign - Plane_Normal_Unit_Sign);
                            Cross_Product_Option_Two_Sign_Summation = sum(Cross_Product_Option_Two_Sign - Plane_Normal_Unit_Sign);

                            if (Cross_Product_Option_One_Sign_Summation == 0) && (Cross_Product_Option_Two_Sign_Summation ~= 0)

                                Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_One;

                            elseif (Cross_Product_Option_One_Sign_Summation ~= 0) && (Cross_Product_Option_Two_Sign_Summation == 0)

                                Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_Two;

                            elseif (Cross_Product_Option_One_Sign_Summation ~= 0) && (Cross_Product_Option_Two_Sign_Summation ~= 0)

                                 Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_One;

                            end

                % Determine which Quadrant the Vector is in with Respect to the Two Defined Z and X Vectors and Calculate the Angle:

                    Z_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Projected_Long_Axis_Unit_Vector)),dot(Projected_Fiber_Vector, Projected_Long_Axis_Unit_Vector)));
                    X_Positive_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Horizontal_Plane_Vector)),dot(Projected_Fiber_Vector, Horizontal_Plane_Vector)));
                    X_Negative_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, (-1*Horizontal_Plane_Vector))),dot(Projected_Fiber_Vector, (-1 * Horizontal_Plane_Vector))));

                    if (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value < 90)

                        Quadrant_Location = 1;

                        Fiber_Angle(First_Index, 1) = abs(X_Positive_Vector_Angle_Value);

                    elseif (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value > 90)

                        Quadrant_Location = 2;

                        Fiber_Angle(First_Index, 1) = -1 * abs(X_Negative_Vector_Angle_Value);

                    elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value < 90)

                        Quadrant_Location = 3;

                        Fiber_Angle(First_Index, 1) = -1 * abs(X_Positive_Vector_Angle_Value);

                    elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value > 90)

                        Quadrant_Location = 4;

                        Fiber_Angle(First_Index, 1) = abs(X_Negative_Vector_Angle_Value);

                    end
                    
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                