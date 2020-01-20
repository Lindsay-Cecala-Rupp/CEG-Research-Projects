
% Script to Determine the Average Fiber Orientation from a Stimulation Site to the Surface of the Heart Based on an Instantaneously Long Axis Vector:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    Plotting_On_Versus_Off = 0; % If Equals One Everything will be Plotted - Any Other Number No Plotting will Occur

    % Magic Numbers:
    
        % Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Epicardial Site
        Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Endocardial Site
        
        Electrode_Location = 12;
        
        Number_of_Stimulation_Site_Centroid_Points = 5;
        Number_of_Surface_Site_Centroid_Points = 5;
        
        Fiber_Core_Radius = 2;

        Phi_Fiber_Plane_Range = 0.25;
        Rho_Fiber_Plane_Range = 0.05;
        Z_Fiber_Plane_Range = 0.05;

        Fiber_Plane_Grid_Resolution = 0.1;
        
        Phi_Long_Axis_Range = 0.05;
        Rho_Long_Axis_Range = 0.05;
        Z_Long_Axis_Range = 0.05;
        
        Fiber_Core_Division_Value = 0.25;

    % Data:
    
        % Cartesian Model:

            Fiber_Orientation = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
                Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

            CARP_Heart_Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
                CARP_Heart_Points = CARP_Heart_Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            CARP_Heart_Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
                CARP_Heart_Elements = CARP_Heart_Elements + 1; % To Make One Based Nodes that Make up "Face"

            CARP_Heart_Surface_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Heart-Surface/14-10-27-Electrodes', num2str(Electrode_Location), '-Data-on-Surface.mat'));
                CARP_Heart_Surface_Points = CARP_Heart_Surface_Data.scirunfield.node'; 
                CARP_Heart_Surface_Activation_Times = CARP_Heart_Surface_Data.scirunfield.field;
                
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
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Rotate/Translate the Heart to be in the Correct Orientation:

    % Find the Centroid of the CARP Heart Points and Set as the Origin:

        CARP_Heart_Points_Centroid = mean(CARP_Heart_Points);
        
        Centered_CARP_Heart_Points = CARP_Heart_Points - CARP_Heart_Points_Centroid;
        Centered_CARP_Heart_Surface_Points = CARP_Heart_Surface_Points - CARP_Heart_Points_Centroid;
        Centered_Coordinate_of_Interest = Coordinate_of_Interest - CARP_Heart_Points_Centroid;
        
    % Rotate so that the Base is Along the Positive Z and the Apex is Along the Negative Z:
    
        Apex_Base_Exists_Check = exist('Apex_Base_Orientation_Vector');
        
        if Apex_Base_Exists_Check ~= 1
            
            Apex_Base_Orientation_Vector = -1 * [0, 0, 1];
            
        end
        
        Origin_Z_Vector = [0, 0, 1];
            
        Apex_Base_Orientation_Rotation_Values = vrrotvec(Apex_Base_Orientation_Vector, Origin_Z_Vector);
        Apex_Base_Orientation_Rotation_Matrix = vrrotvec2mat(Apex_Base_Orientation_Rotation_Values);
        
        Rotated_Centered_CARP_Heart_Points = Centered_CARP_Heart_Points * Apex_Base_Orientation_Rotation_Matrix';
        Rotated_Centered_CARP_Heart_Surface_Points = Centered_CARP_Heart_Surface_Points * Apex_Base_Orientation_Rotation_Matrix';
        Rotated_Centered_Coordinate_of_Interest = Centered_Coordinate_of_Interest * Apex_Base_Orientation_Rotation_Matrix';
        Rotated_Fiber_Orientation = Fiber_Orientation * Apex_Base_Orientation_Rotation_Matrix;
        
    % Plot to Validate the Results:
    
        if Plotting_On_Versus_Off == 1
            
            figure(1);
            
                hold on;
            
                    pcshow(Rotated_Centered_CARP_Heart_Points, 'w');

                    pcshow(Rotated_Centered_CARP_Heart_Surface_Points, 'r');

                    scatter3(Rotated_Centered_Coordinate_of_Interest(1), Rotated_Centered_Coordinate_of_Interest(2), Rotated_Centered_Coordinate_of_Interest(3), 25, 'og', 'filled');

                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    xlabel('Z-Axis');
                    
                hold off;
            
        end
                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine the Fiber Indicies of Interest:

    [Fiber_Core_Indicies, CARP_Heart_Element_Centroids, Stimulation_Point, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Rotated_Centered_Coordinate_of_Interest, Number_of_Stimulation_Site_Centroid_Points, Number_of_Surface_Site_Centroid_Points, Fiber_Core_Radius, Rotated_Centered_CARP_Heart_Points, CARP_Heart_Elements, Rotated_Centered_CARP_Heart_Surface_Points, CARP_Heart_Surface_Activation_Times);
    
    % Plot to Validate the Results:
    
        if Plotting_On_Versus_Off == 1
    
            Element_Centroid_Point_Cloud = pointCloud(CARP_Heart_Element_Centroids);
            Desired_Cylinder_Point_Cloud = select(Element_Centroid_Point_Cloud, Fiber_Core_Indicies);

            figure(2);

                hold on;

                    pcshow(Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
                    pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');

                    title('Selected Cylinder Points');
                    
                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    xlabel('Z-Axis');

                hold off;
            
        end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Angle for Each Fiber in the Cylinder:

    Imbrication_Angle = zeros(size(Fiber_Core_Indicies, 1), 1);
    Fiber_Angle = zeros(size(Fiber_Core_Indicies, 1), 1);

    for First_Index = 1:size(Fiber_Core_Indicies, 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Grab the Center Point for the Fiber Point and Determine a Range of Values Along Side of It:

            Temporary_Fiber_Anchor = CARP_Heart_Element_Centroids(Fiber_Core_Indicies(First_Index, 1), :);
            Temporary_Fiber_Vector = Rotated_Fiber_Orientation(Fiber_Core_Indicies(First_Index, 1), :);
            
            % Find the UVC Coordiante that Cooresponds to the Centroid of the Desired Element:
            
                % Grab the Four UVC Coordiantes:
                
                    UVC_Coordinates_of_Interest = UVC_Coordinates(CARP_Heart_Elements(Fiber_Core_Indicies(First_Index), 2:5), :);
                    
                % Take the Average to Correspond to the Centroid:
                
                    UVC_Coordinate_of_Interest = [mean(UVC_Coordinates_of_Interest(:, 1)), mean(UVC_Coordinates_of_Interest(:, 2)), mean(UVC_Coordinates_of_Interest(:, 3)), mean(UVC_Coordinates_of_Interest(:, 4))];

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
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Fit a Plane to the Points of Interest for Angle Calculations:
        
            Fiber_Plane_Surface_Fit = fit([Fiber_Plane_Points_of_Interest(:, 1), Fiber_Plane_Points_of_Interest(:, 2)], Fiber_Plane_Points_of_Interest(:, 3), 'poly11', 'normalize', 'on');

            [Fiber_Plane_X, Fiber_Plane_Y] = meshgrid((min(Fiber_Plane_Points_of_Interest(:, 1))  - 5):Fiber_Plane_Grid_Resolution:(max(Fiber_Plane_Points_of_Interest(:, 1)) + 5), (min(Fiber_Plane_Points_of_Interest(:, 2)) - 5):Fiber_Plane_Grid_Resolution:(max(Fiber_Plane_Points_of_Interest(:, 2)) + 5));

            Fiber_Plane_Z = Fiber_Plane_Surface_Fit(Fiber_Plane_X, Fiber_Plane_Y);
            
            % Plot to Validate the Results:
            
                if Plotting_On_Versus_Off == 1
                    
                    figure(3);
                    
                        hold on;
                        
                            pcshow(CARP_Heart_Element_Centroids(Fiber_Core_Indicies, :), 'w');
                        
                            surf(Fiber_Plane_X, Fiber_Plane_Y, Fiber_Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
                        
                            quiver3(Temporary_Fiber_Anchor(1), Temporary_Fiber_Anchor(2), Temporary_Fiber_Anchor(3), Temporary_Fiber_Vector(1) * 10, Temporary_Fiber_Vector(2) * 10, Temporary_Fiber_Vector(3) * 10, 'g');
                            
                            pcshow(Fiber_Plane_Points_of_Interest, 'b');
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            xlabel('Z-Axis');
                            
                        hold off;
                        
                end
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
                    
                    figure(4);
                    
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
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Determine the Fiber Orientation Angle - Imbrication and Plane Angle:
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
                
            % Determine the Instanteous Long Axis for the Fiber:
            
                % Create Four Additional Points on the Plane Surrounding the Original Fiber Plane Point:
                
                    % Long Edge of Plane Vector and Point Creation:
                    
                        Long_Edge_of_Plane_Vector = [Fiber_Plane_X(1, 1), Fiber_Plane_Y(1, 1), Fiber_Plane_Z(1, 1)] - [Fiber_Plane_X(1, end), Fiber_Plane_Y(1, end), Fiber_Plane_Z(1, end)];
                            Long_Edge_of_Plane_Unit_Vector = Long_Edge_of_Plane_Vector / norm(Long_Edge_of_Plane_Vector);
                            
                        Long_Edge_Point_One = Temporary_Fiber_Anchor_Plane_Point + (1 * Long_Edge_of_Plane_Unit_Vector);
                        Long_Edge_Point_Two = Temporary_Fiber_Anchor_Plane_Point - (1 * Long_Edge_of_Plane_Unit_Vector);
                    
                    % Short Edge of Plane Vector and Point Creation:
                    
                        Short_Edge_of_Plane_Vector = [Fiber_Plane_X(1, 1), Fiber_Plane_Y(1, 1), Fiber_Plane_Z(1, 1)] - [Fiber_Plane_X(end, 1), Fiber_Plane_Y(end, 1), Fiber_Plane_Z(end, 1)];
                            Short_Edge_of_Plane_Unit_Vector = Short_Edge_of_Plane_Vector / norm(Short_Edge_of_Plane_Vector);
                            
                        Short_Edge_Point_One = Temporary_Fiber_Anchor_Plane_Point + (1 * Short_Edge_of_Plane_Unit_Vector);
                        Short_Edge_Point_Two = Temporary_Fiber_Anchor_Plane_Point - (1 * Short_Edge_of_Plane_Unit_Vector);
                        
                    Long_Axis_Points_of_Interest_Created = [Long_Edge_Point_One; Long_Edge_Point_Two; Short_Edge_Point_One; Short_Edge_Point_Two; Temporary_Fiber_Anchor_Plane_Point];
                        
                    % Plot to Validate the Results:
                    
                        if Plotting_On_Versus_Off == 1
                            
                            figure(5);
                            
                                hold on;
                                
                                    surf(Fiber_Plane_X, Fiber_Plane_Y, Fiber_Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
                                    
                                    scatter3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), 'ok', 'filled');

                                    scatter3(Fiber_Plane_X(1, 1), Fiber_Plane_Y(1, 1), Fiber_Plane_Z(1, 1), '*b');
                                    scatter3(Fiber_Plane_X(1, end), Fiber_Plane_Y(1, end), Fiber_Plane_Z(1, end), '*b');
                                    
                                    quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Long_Edge_of_Plane_Unit_Vector(1), Long_Edge_of_Plane_Unit_Vector(2), Long_Edge_of_Plane_Unit_Vector(3), 'b');

                                    scatter3(Fiber_Plane_X(1, 1), Fiber_Plane_Y(1, 1), Fiber_Plane_Z(1, 1), '*c');
                                    scatter3(Fiber_Plane_X(end, 1), Fiber_Plane_Y(end, 1), Fiber_Plane_Z(end, 1), '*c');
                                    
                                    quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Short_Edge_of_Plane_Unit_Vector(1), Short_Edge_of_Plane_Unit_Vector(2), Short_Edge_of_Plane_Unit_Vector(3), 'c');
                                    
                                    scatter3(Long_Axis_Points_of_Interest_Created(:, 1), Long_Axis_Points_of_Interest_Created(:, 2), Long_Axis_Points_of_Interest_Created(:, 3), 'ok');
                                
                                hold off;
                            
                        end
            
                % Determine the Instantesouly Long Axis for Each of the Determined Points:
                
                    for Second_Index = 1:size(Long_Axis_Points_of_Interest_Created, 1)
                        
                        % Determine UVC Value of Point Itself:
                        
                            Distance_between_Point_of_Interest_and_True_Points = pdist2(Long_Axis_Points_of_Interest_Created(Second_Index, :), Rotated_Centered_CARP_Heart_Points);

                            [~, Smallest_Distance_Index_Value] = min(Distance_between_Point_of_Interest_and_True_Points);
                                Test(Second_Index, 1) = Smallest_Distance_Index_Value;
                            
                            Point_of_Interest_UVC_Coordinate = UVC_Coordinates(Smallest_Distance_Index_Value, :);
                    
                        % Determine New Point with Increased Z Value:
                        
                            Phi_UVC_Indicies_of_Interest_Point_of_Interest = find((UVC_Phi_Values < (Point_of_Interest_UVC_Coordinate(3) + Phi_Long_Axis_Range)) & (UVC_Phi_Values > (Point_of_Interest_UVC_Coordinate(3) - Phi_Long_Axis_Range))); % Perform Phi Range Determination
                            Rho_UVC_Indicies_of_Interest_Point_of_Interest = find((UVC_Rho_Values < (Point_of_Interest_UVC_Coordinate(2) + Rho_Long_Axis_Range)) & (UVC_Rho_Values > (Point_of_Interest_UVC_Coordinate(2) - Rho_Long_Axis_Range))); % Perform Rho Range Determination
                            V_UVC_Indicies_of_Interest_Point_of_Interest = find(UVC_V_Values == Point_of_Interest_UVC_Coordinate(4)); % Perform V Range Determination
                            Z_UVC_Indicies_of_Interest_Point_of_Interest = find((UVC_Z_Values < ((Point_of_Interest_UVC_Coordinate(1) + 0.05) + Z_Long_Axis_Range)) & (UVC_Z_Values > ((Point_of_Interest_UVC_Coordinate(1) + 0.05) - Z_Long_Axis_Range))); % Perform Z Range Determination

                            Desired_Indicies_for_Point_of_Interest = intersect(Phi_UVC_Indicies_of_Interest_Point_of_Interest, Rho_UVC_Indicies_of_Interest_Point_of_Interest);
                            Desired_Indicies_for_Point_of_Interest = intersect(Desired_Indicies_for_Point_of_Interest, V_UVC_Indicies_of_Interest_Point_of_Interest);
                            Desired_Indicies_for_Point_of_Interest = intersect(Desired_Indicies_for_Point_of_Interest, Z_UVC_Indicies_of_Interest_Point_of_Interest);

                            Long_Axis_Calculation(Second_Index, 1).Index_Values = Desired_Indicies_for_Point_of_Interest;
                            
                        % Take the Average of the Determined Points - Add Find Corresponding True Value:
                        
                            Long_Axis_Points_of_Interest_True(Second_Index, :) = mean(Rotated_Centered_CARP_Heart_Points(Desired_Indicies_for_Point_of_Interest, :));
                        
                    end
                    
                % Determine the Average of the Determined Points to Act as the Sole Long Axis Vector:
                
                    Long_Axis_Point = mean(Long_Axis_Points_of_Interest_True);
                    
                    Long_Axis_Vector = Long_Axis_Point - Temporary_Fiber_Anchor_Plane_Point;
                        Long_Axis_Unit_Vector = Long_Axis_Vector / norm(Long_Axis_Vector);
                        
                % Plot to Validate the Results:
                
                    if Plotting_On_Versus_Off == 1
                        
                        figure(6);

                            hold on;

                                surf(Fiber_Plane_X, Fiber_Plane_Y, Fiber_Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');

                                quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Temporary_Fiber_Vector(1) * 10, Temporary_Fiber_Vector(2) * 10, Temporary_Fiber_Vector(3) * 10, 'g');

                                quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Plane_Normal_Unit_Vector(1) * 10, Plane_Normal_Unit_Vector(2) * 10, Plane_Normal_Unit_Vector(3) * 10, 'c');

                                scatter3(Long_Axis_Points_of_Interest_True(:, 1), Long_Axis_Points_of_Interest_True(:, 2), Long_Axis_Points_of_Interest_True(:, 3), '*k');
                                
                                scatter3(Long_Axis_Point(1), Long_Axis_Point(2), Long_Axis_Point(3), 'ok', 'filled');
                                
                                xlabel('X-Axis');
                                ylabel('Y-Axis');
                                xlabel('Z-Axis');

                            hold off;
                        
                    end
                    
            % Project Long Axis to Preform Angle Calculation in Plane:
            
                Long_Axis_Projection_with_Normal = (dot(Long_Axis_Unit_Vector, Plane_Normal_Unit_Vector)/(norm(Plane_Normal_Unit_Vector)^2)) * Plane_Normal_Unit_Vector;
                Projected_Long_Axis_Unit_Vector = Long_Axis_Unit_Vector - Long_Axis_Projection_with_Normal;
                
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
                
            % Plot to Validate the Results:
            
                if Plotting_On_Versus_Off == 1
                        
                    figure(7);

                        hold on;

                            surf(Fiber_Plane_X, Fiber_Plane_Y, Fiber_Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'w');

                            quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Temporary_Fiber_Vector(1) * 5, Temporary_Fiber_Vector(2) * 5, Temporary_Fiber_Vector(3) * 5, 'r');

                            quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Plane_Normal_Unit_Vector(1) * 5, Plane_Normal_Unit_Vector(2) * 5, Plane_Normal_Unit_Vector(3) * 5, 'g');

                            quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Projected_Long_Axis_Unit_Vector(1) * 5, Projected_Long_Axis_Unit_Vector(2) * 5, Projected_Long_Axis_Unit_Vector(3) * 5, 'k');

                            quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Horizontal_Plane_Vector(1) * 5, Horizontal_Plane_Vector(2) * 5, Horizontal_Plane_Vector(3) * 5, 'b');

                            quiver3(Temporary_Fiber_Anchor_Plane_Point(1), Temporary_Fiber_Anchor_Plane_Point(2), Temporary_Fiber_Anchor_Plane_Point(3), Long_Axis_Unit_Vector(1) * 5, Long_Axis_Unit_Vector(2) * 5, Long_Axis_Unit_Vector(3) * 5, 'c');

                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            xlabel('Z-Axis');

                        hold off;

                end
          
    end
        