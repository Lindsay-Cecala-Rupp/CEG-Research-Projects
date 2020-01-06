
% Script to Determine the Average Fiber Orientation from a Stimulation Site to the Surface of the Heart:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Magic Numbers::
    
        % Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Epicardial Site
        Implemented_Stimulation_Site = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Endocardial Site
        
        Electrodes_Stimulated = 12;
        
        Number_of_Stimulation_Points = 5;
        Number_of_Surface_Points = 5;
        
        Cylinder_Radius = 2;
        
        Cylinder_Division_Value = 0.25;
        
        Fiber_Grid_Resolution = 0.1;
        Barycentric_Grid_Resolution = 0.2;

        Phi_Range = 0.25;
        Z_Range = 0.05;
        Rho_Range = 0.05;

    % Data:
    
        % Cartesian Model:

            Fiber_Orientation = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
                Fiber_Orientation = Fiber_Orientation(:, 1:3)'; % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

            CARP_Heart_Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
                CARP_Heart_Points = CARP_Heart_Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            CARP_Heart_Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
                CARP_Heart_Elements = CARP_Heart_Elements + 1; % To Make One Based Nodes that Make up "Face"

            Heart_Surface_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Heart-Surface/14-10-27-Electrodes', num2str(Electrodes_Stimulated), '-Data-on-Surface.mat'));
                Heart_Surface = Heart_Surface_Data.scirunfield.node'; 
                Activation_Times = Heart_Surface_Data.scirunfield.field;
                
            Sock_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Sock/14-10-27-Simulated-Electrodes', num2str(Electrodes_Stimulated), '.mat'));
                Sock_Points = Sock_Data.Sock_US.node;
                Sock_Faces = Sock_Data.Sock_US.face;
                Sock_Activation_Times = Sock_Data.Sock_US.field;
                
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

% Script to Change the Orientation of Data to be Equivalent to the Breakthrough Site Angle Calculation:

    % Script to Up Sample Sock Using Barycentric Coordinates:
    
        [Upsampled_Sock_Points, Upsampled_Sock_Activation_Times] = Barycentricly_Upsample_Sock_Function(Sock_Points, Sock_Faces, Sock_Activation_Times, Barycentric_Grid_Resolution);
    
            % Visualization to see what Relative Space All Components are In:
            
                figure(1);
                
                    hold on;
                    
                        pcshow(CARP_Heart_Points, 'w');
                        
                        pcshow(Heart_Surface, 'r');
                        
                        scatter3(Sock_Points(1, :), Sock_Points(2, :), Sock_Points(3, :), 'ob', 'filled');
                        
                        pcshow(Upsampled_Sock_Points, 'g');
                        
                    hold off;
                    
    % Script to Orient the Data Based on the Long Axis of the Heart Calcualted Via the Upsampled Sock:
    
        % Script to Determine the Long Axis of the Heart:

            [Ellipsoid_Center, Ellipsoid_Radii, Ellipsoid_Vectors, Ellipsoid_Equation, Ellipsoid_Error] = Fit_Ellipsoid_to_Points([Upsampled_Sock_Points(:, 1), Upsampled_Sock_Points(:, 2), Upsampled_Sock_Points(:, 3)], '');

            % Determine the Point on the Long Axis Closest to the Centroid of the Breakthrough Site:

                % Create a Line Along the Vector with 10000 Points Along it:

                    Long_Axis_Variable = linspace((min(min(Upsampled_Sock_Points)) - 50), (max(max(Upsampled_Sock_Points)) + 50), 10000);

                    Long_Axis_Vector_X = Ellipsoid_Center(1) + Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
                    Long_Axis_Vector_Y = Ellipsoid_Center(2) + Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
                    Long_Axis_Vector_Z = Ellipsoid_Center(3) + Long_Axis_Variable * Ellipsoid_Vectors(3, 1);

                    Long_Axis_Components = [Long_Axis_Vector_X; Long_Axis_Vector_Y; Long_Axis_Vector_Z];

                % Determine the Closest Point Centroid of the Upsampled Sock:

                    Upsampled_Sock_Centroid = [mean(Upsampled_Sock_Points(:, 1)); mean(Upsampled_Sock_Points(:, 2)); mean(Upsampled_Sock_Points(:, 3))];

                    Long_Axis_Closest_Index = dsearchn(Long_Axis_Components', Upsampled_Sock_Centroid');

                    % For Future Calculations - I Want this Points to be at the Origin:

                        Centered_Upsampled_Sock_Points = Upsampled_Sock_Points' - Long_Axis_Components(:, Long_Axis_Closest_Index);

                        Centered_Ellipsoid_Center = Ellipsoid_Center - Long_Axis_Components(:, Long_Axis_Closest_Index);

                        Centered_CARP_Heart_Points = CARP_Heart_Points' - Long_Axis_Components(:, Long_Axis_Closest_Index);
                        
                        Centered_Implemented_Stimulation_Site = Implemented_Stimulation_Site' - Long_Axis_Components(:, Long_Axis_Closest_Index);
                        
                        Centered_Heart_Surface = Heart_Surface' - Long_Axis_Components(:, Long_Axis_Closest_Index);
                       
                        % Plot to Validate the Results:
                        
                            figure(2);
                            
                                hold on;
                                
                                    pcshow(Centered_CARP_Heart_Points', 'w');
                                    
                                    pcshow(Centered_Heart_Surface', 'r');
                                    
                                    pcshow(Centered_Upsampled_Sock_Points', 'b');
                                    
                                    scatter3(Centered_Implemented_Stimulation_Site(1), Centered_Implemented_Stimulation_Site(2), Centered_Implemented_Stimulation_Site(3), 25, 'oc', 'filled');
                                    
                                hold off;
                                
    % Script to Rotate the System so the Long Axis of the Heart is the Z-Axis:
                                    
        % Determine which Direction the Apex of the Heart is Located Corresponding to the Ellipsoid Vectors:

            Direction_Counter = 1;

            while Direction_Counter < 50

                    % Increase Size of the Line Until Reached A Desirable Distance Away from a Point:

                        Direction_Counter_Long_Axis_Variable = linspace((min(min(Centered_Upsampled_Sock_Points)) - Direction_Counter), (max(max(Centered_Upsampled_Sock_Points)) + Direction_Counter), 100);

                        Direction_Counter_Long_Axis_Vector_X = Centered_Ellipsoid_Center(1) + Direction_Counter_Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
                        Direction_Counter_Long_Axis_Vector_Y = Centered_Ellipsoid_Center(2) + Direction_Counter_Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
                        Direction_Counter_Long_Axis_Vector_Z = Centered_Ellipsoid_Center(3) + Direction_Counter_Long_Axis_Variable * Ellipsoid_Vectors(3, 1);

                        Direction_Counter_Long_Axis_Vector = [Direction_Counter_Long_Axis_Vector_X; Direction_Counter_Long_Axis_Vector_Y; Direction_Counter_Long_Axis_Vector_Z];

                    % Determine the Smallest Distance and See if Okay:

                        Direction_Distance = pdist2(Direction_Counter_Long_Axis_Vector', Centered_Upsampled_Sock_Points');

                        Minimum_Distance = min(min(Direction_Distance));

                        if Minimum_Distance < 5

                            Direction_Info = 1;

                            Direction_Counter = 100;

                        else

                            Direction_Counter = Direction_Counter + 1;

                        end

            end

            % Evaluate Which Direction it is Facing and Orientate to be Towards the Base of the Heart:

                % Long Axis Vector:

                    Exists_Check = exist('Direction_Info');

                    if Exists_Check == 1

                        Desired_Vector_One = -1 * [Ellipsoid_Vectors(1, 1), Ellipsoid_Vectors(2, 1), Ellipsoid_Vectors(3, 1)];

                    else

                        Desired_Vector_One = 1 * [Ellipsoid_Vectors(1, 1), Ellipsoid_Vectors(2, 1), Ellipsoid_Vectors(3, 1)];

                    end

                % Original Axis Vectors (X, Y and Z):

                    Origin_X_Vector = [1; 0; 0]; 
                    Origin_Y_Vector = [0; 1; 0]; 
                    Origin_Z_Vector = [0; 0; 1]; 

                % Project Long Axis Vector to Z-Axis:

                    Rotate_to_Z_Axis_Values = vrrotvec(Desired_Vector_One, Origin_Z_Vector);

                    Rotate_to_Z_Axis_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

                    Rotated_Upsampled_Sock_Points = Centered_Upsampled_Sock_Points' * Rotate_to_Z_Axis_Matrix';

                    Rotated_CARP_Heart_Points = Centered_CARP_Heart_Points' * Rotate_to_Z_Axis_Matrix';
                    
                    Rotated_Implemented_Stimulation_Site = Centered_Implemented_Stimulation_Site' * Rotate_to_Z_Axis_Matrix';
                   
                    Rotated_Heart_Surface = Centered_Heart_Surface' * Rotate_to_Z_Axis_Matrix';
                    
                    Rotated_Fiber_Orientation = Fiber_Orientation' * Rotate_to_Z_Axis_Matrix';

                    % Rotated_Fiber_Orientation = Fiber_Orientation' * Rotate_to_Z_Axis_Matrix;
                    
                    % Plot to Validate the Results:
                        
                        figure(3);

                            hold on;

                                pcshow(Rotated_CARP_Heart_Points, 'w');

                                pcshow(Rotated_Heart_Surface, 'r');

                                pcshow(Rotated_Upsampled_Sock_Points, 'b');

                                scatter3(Rotated_Implemented_Stimulation_Site(1), Rotated_Implemented_Stimulation_Site(2), Rotated_Implemented_Stimulation_Site(3), 25, 'oc', 'filled');

                            hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine the Fiber Indicies of Interest:

    [Cylinder_Indicies, Element_Centroids, Stimulation_Site, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Rotated_Implemented_Stimulation_Site, Number_of_Stimulation_Points, Number_of_Surface_Points, Cylinder_Radius, Rotated_CARP_Heart_Points, CARP_Heart_Elements, Rotated_Heart_Surface, Activation_Times);
    
    % Plot to Validate the Results:
    
        Element_Centroid_Point_Cloud = pointCloud(Element_Centroids);
        Desired_Cylinder_Point_Cloud = select(Element_Centroid_Point_Cloud, Cylinder_Indicies);

        figure(4);

            hold on;

                pcshow(Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
                pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');

                title('Selected Cylinder Points');

            hold off;
            
        figure(5);
        
            hold on;
            
                pcshow(Rotated_Heart_Surface, 'w');
                
                scatter3(Rotated_Implemented_Stimulation_Site(1), Rotated_Implemented_Stimulation_Site(2), Rotated_Implemented_Stimulation_Site(3), 25, 'oc', 'filled');
            
                pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');
                
            hold off;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine the Fiber Angle and Imbrication Angle for each of the Determined Fibers of Interest:

    [Imbrication_Angles, Fiber_Angles] = Calculate_Specific_Fiber_Angle_for_Given_Fiber_Vector_Function(Element_Centroids, Cylinder_Indicies, Rotated_Fiber_Orientation, Rotated_CARP_Heart_Points, UVC_Coordinates, UVC_RHO, UVC_PHI, UVC_Z, Fiber_Grid_Resolution, Phi_Range, Z_Range, Rho_Range, Rotated_Heart_Surface);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Average Fiber Angle:

    Element_Centroids_of_Interest = Element_Centroids(Cylinder_Indicies, :);

    [Mean_Fiber_Angle, STD_Fiber_Angle] = Calculate_Average_of_Fiber_Angles_Function(Fiber_Angles, Element_Centroids_of_Interest, Stimulation_Site, Heart_Surface_Point, Cylinder_Division_Value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
