
% Script to Determine the Average Fiber Orientation from a Stimulation Site to the Surface of the Heart:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

% Magic Numbers::
    
        %Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Epicardial Site
        Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Endocardial Site
        
        Electrode_Location = 12;
        
        Number_of_Centroid_Points = 5;
        Number_of_Surface_Points = 5;
        
        Cylinder_Radius = 2;
        
        Division_Value = 0.25;
        
        Grid_Resolution = 0.1;
        
                    PHI_Range = 0.25;
            Z_Range = 0.05;
            RHO_Range = 0.05;

    % Data:
    
        % Cartesian Model:

            Fiber_Orientation = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
            % Fiber_Orientation = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.lon.txt');
                Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

            Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
            % Points = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.pts.txt');
                Points = Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
            % Elements = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.elem.txt');
                Elements = Elements + 1; % To Make One Based Nodes that Make up "Face"

            Heart_Surface_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/Geometry-Files/14-10-27-CARP-Epicardial-Surface-Electrodes', num2str(Electrode_Location), '.mat'));
            % Heart_Surface = load('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/14-10-27-CARP-Heart-Surface.mat');
                Heart_Surface = Heart_Surface_Data.scirunfield.node'; % Scaling is Different 
                Activation_Times = Heart_Surface_Data.scirunfield.field;
                
        % UVC Model:
                
            UVC_RHO = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_RHO.pts');
                UVC_RHO = UVC_RHO(2:end, 1); % Ignore First Element
                
            UVC_PHI = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_PHI.pts');
                UVC_PHI = UVC_PHI(2:end, 1); % Ignore First Element
                
            UVC_V = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_V.pts');
                UVC_V = UVC_V(2:end, 1); % Ignore First Element
                
            UVC_Z = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_Z.pts');
                UVC_Z = UVC_Z(2:end, 1); % Ignore First Element
                
            % Combine the Coordinates:
            
                UVC_Coordinates = [UVC_Z, UVC_RHO, UVC_PHI, UVC_V];
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine the Fiber Indicies of Interest:

    [Cylinder_Indicies, Element_Centroid, Stimulation_Site, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Coordinate_of_Interest, Number_of_Centroid_Points, Number_of_Surface_Points, Cylinder_Radius, Points, Elements, Heart_Surface, Activation_Times);
    
    % Plot to Validate the Results:
    
        Element_Centroid_Point_Cloud = pointCloud(Element_Centroid);
        Desired_Cylinder_Point_Cloud = select(Element_Centroid_Point_Cloud, Cylinder_Indicies);

        figure(1);

            hold on;

                pcshow(Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
                pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');

                title('Selected Cylinder Points');

            hold off;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Calculate the Angle for Each Fiber in the Cylinder:

        Imbrication_Angle = zeros(size(Cylinder_Indicies, 1), 1);
        Fiber_Angle = zeros(size(Cylinder_Indicies, 1), 1);

        for First_Index = 1:size(Cylinder_Indicies, 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Find the Center Point for the Fiber Point and Determine a Range of Values Along Side of It:

                Temporary_Anchor = Element_Centroid(Cylinder_Indicies(First_Index, 1), :);
                Temporary_Vector = Fiber_Orientation(Cylinder_Indicies(First_Index, 1), :);

% %                     % Plot to Validate Results:
% %     
% %                         figure(1);
% %     
% %                             hold on;
% %     
% %                                 quiver3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'k');
% %                                 scatter3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), 'r');
% %                                 scatter3(Temporary_Head(1), Temporary_Head(2), Temporary_Head(3), 'r');
% %     
% %                                 title('Plot of the Current Vector of Interest');
% %                                 
% %                                 xlabel('X-Axis');
% %                                 ylabel('Y-Axis');
% %                                 zlabel('Z-Axis');
% %                                 
% %                             hold off;

                % Find the UVC Coordinate the Cooresponds to the Centroid of the Desired Element:

                    % Grab the Four Nodes that Make up the Desired Element:

                        Node_Distance_Calculation = sqrt((Temporary_Anchor(1) - Points(:, 1)).^2 + (Temporary_Anchor(2) - Points(:, 2)).^2 + (Temporary_Anchor(3) - Points(:, 3)).^2);
                        Node_Distance_Calculation(:, 2) = 1:size(Points, 1);

                        Node_Distance_Calculation = sortrows(Node_Distance_Calculation, 1);

                        Element_Nodes = Node_Distance_Calculation(1:4, 2);

                    % Determine Cooresonding UVC Coordinate to the Four Nodes and Take the Average:

                        for Second_Index = 1:4

                            UVC_Coordiantes_of_Interest(Second_Index, :) = UVC_Coordinates(Element_Nodes(Second_Index), :);

                        end

                        UVC_Coordinate_of_Interest = [mean(UVC_Coordiantes_of_Interest(:, 1)), mean(UVC_Coordiantes_of_Interest(:, 2)), mean(UVC_Coordiantes_of_Interest(:, 3)), mean(UVC_Coordiantes_of_Interest(:, 4))];

                % Pull UVC Indicies who Fall within a Set Range of Phi and Z:

                    Desired_Plane_Indicies_Storage_Vector = zeros(size(UVC_Coordinates, 1), 1);

                    for Second_Index = 1:size(UVC_Coordinates, 1)

                        Temporary_RHO = UVC_RHO(Second_Index, 1);
                        Temporary_PHI = UVC_PHI(Second_Index, 1);
                        Temporary_Z = UVC_Z(Second_Index, 1);

                        if (Temporary_RHO < (UVC_Coordinate_of_Interest(2) + RHO_Range)) && (Temporary_RHO > (UVC_Coordinate_of_Interest(2) - RHO_Range))

                            if (Temporary_PHI < (UVC_Coordinate_of_Interest(3) + PHI_Range)) && (Temporary_PHI > (UVC_Coordinate_of_Interest(3) - PHI_Range))

                                if (Temporary_Z < (UVC_Coordinate_of_Interest(1) + Z_Range)) && (Temporary_Z > (UVC_Coordinate_of_Interest(1) - Z_Range))

                                    Desired_Plane_Indicies_Storage_Vector(Second_Index, 1) = 1;

                                end

                            end

                        end

                    end

                    Desired_Plane_Indicies = find(Desired_Plane_Indicies_Storage_Vector == 1);

                % Put them Into Cartesian Space for Visualization:

                    Plane_Points_of_Interest = Points(Desired_Plane_Indicies, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Fit a Plane to the Points of Interest for Angle Calculations:

                Surface_Fit = fit([Plane_Points_of_Interest(:, 1), Plane_Points_of_Interest(:, 2)], Plane_Points_of_Interest(:, 3), 'poly11', 'normalize', 'on');

                [Plane_X, Plane_Y] = meshgrid((min(Plane_Points_of_Interest(:, 1))  - 5):Grid_Resolution:(max(Plane_Points_of_Interest(:, 1)) + 5), (min(Plane_Points_of_Interest(:, 2)) - 5):Grid_Resolution:(max(Plane_Points_of_Interest(:, 2)) + 5));

                Plane_Z = Surface_Fit(Plane_X, Plane_Y);

% %                 % Plot to Validate Results:
% % 
% %                     % Determine Which Points Have the Desired RHO Value for Visualization Purposes:
% % 
% %                         for Second_Index = 1:size(UVC_RHO, 1)
% % 
% %                             Temporary_Value = UVC_RHO(Second_Index, 1);
% % 
% %                             Wanted_Value = UVC_Coordinate_of_Interest(2);
% % 
% %                             if Temporary_Value > (Wanted_Value - 0.05)
% % 
% %                                 if Temporary_Value < (Wanted_Value + 0.05)
% % 
% %                                     RHO_Check(Second_Index, 1) = 1;
% % 
% %                                 else
% % 
% %                                     RHO_Check(Second_Index, 1) = 0;
% % 
% %                                 end
% % 
% %                             else
% % 
% %                                 RHO_Check(Second_Index, 1) = 0;
% % 
% %                             end
% % 
% %                         end
% % 
% %                         Desired_RHO_Indicies = find(RHO_Check == 1);
% % 
% %                         Cartesian_RHO_Coordiantes = Points(Desired_RHO_Indicies, :);
% % 
% %                     % Plot All Necessary Results:
% % 
% %                         figure(2);
% % 
% %                             hold on;
% % 
% %                                 surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% % 
% %                                 pcshow(Cartesian_RHO_Coordiantes, 'w');
% % 
% %                                 scatter3(Temporary_Anchor(1), Temporary_Anchor(2), Temporary_Anchor(3), '*b');
% % 
% %                                 pcshow(Element_Centroid(Cylinder_Indicies, :), 'g');
% % 
% %                                 pcshow(Heart_Surface, 'y');
% % 
% %                                 zlabel('Z-Axis');
% %                                 ylabel('Y-Axis');
% %                                 xlabel('X-Axis');
% % 
% %                                 legend('Fitted Plane', 'RHO Plane', 'Point of Interest', 'Fiber Box', 'Heart Surface');
% % 
% %                                 title('Tangent Plane Fitted to the RHO Plane of Interest');
% % 
% %                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Determine Information About the Plane in Order to do Necessary Calculations:

                % Fiber Anchor's Location on the Calculated Plane:

                    Fiber_Distance_to_Plane = zeros(size(Plane_X, 1), size(Plane_Z, 2));

                    for Second_Index = 1:size(Plane_Z, 1)

                        for Third_Index = 1:size(Plane_Z, 2)

                            Fiber_Distance_to_Plane(Second_Index, Third_Index) = sqrt(((Temporary_Anchor(1) - Plane_X(Second_Index, Third_Index))^2) + ((Temporary_Anchor(2) - Plane_Y(Second_Index, Third_Index))^2) + ((Temporary_Anchor(3) - Plane_Z(Second_Index, Third_Index))^2));

                        end

                    end

                    Minimum_Fiber_Distance_to_Plane_Value = min(min(Fiber_Distance_to_Plane));

                    Minimum_Fiber_Distance_to_Plane_Index = find(Fiber_Distance_to_Plane == Minimum_Fiber_Distance_to_Plane_Value);

                    [Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index] = ind2sub(size(Fiber_Distance_to_Plane), Minimum_Fiber_Distance_to_Plane_Index);

                    Anchor_Plane_Point = [Plane_X(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index), Plane_Y(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index), Plane_Z(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index)];

                % Calcualte the Normal to the Plane:

                    % Create Two Vectors on the Plane that have Anchors at the Fiber Anchor Plane Point:

                        % Plane Vector One:

                            Plane_Vector_One_Point = [Plane_X(1, 1), Plane_Y(1, 1), Plane_Z(1, 1)];
                            Plane_Vector_One = Anchor_Plane_Point - Plane_Vector_One_Point;
                            Plane_Vector_One_Unit = Plane_Vector_One/(sqrt(Plane_Vector_One(1)^2 + Plane_Vector_One(2)^2 + Plane_Vector_One(3)^2));

                        % Plane Vector Two:

                            Plane_Vector_Two_Point = [Plane_X(1, end), Plane_Y(1, end), Plane_Z(1, end)];
                            Plane_Vector_Two = Anchor_Plane_Point - Plane_Vector_Two_Point;
                            Plane_Vector_Two_Unit = Plane_Vector_Two/(sqrt(Plane_Vector_Two(1)^2 + Plane_Vector_Two(2)^2 + Plane_Vector_Two(3)^2));

                    % Calculate the Normal from the Two Vectors:

                        Plane_Normal = cross(Plane_Vector_One_Unit, Plane_Vector_Two_Unit);
                        Plane_Normal_Unit = Plane_Normal/(sqrt(Plane_Normal(1)^2 + Plane_Normal(2)^2 + Plane_Normal(3)^3));

                        % Determine the Direction of the Normal Vector - Need it to be Pointing Towards the Surface of the Heart:

                            % Convert Plane Anchor Point into UVC Coordinates:

                                Plane_Anchor_Point_UVC_Index = dsearchn(Points, Anchor_Plane_Point);

                                Plane_Anchor_Point_UVC = UVC_Coordinates(Plane_Anchor_Point_UVC_Index, :);

                            % Convert Normal Vector Point into UVC Coordinates:

                                Plane_Normal_Point = Anchor_Plane_Point + Plane_Normal_Unit;

                                Plane_Normal_Point_UVC_Index = dsearchn(Points, Plane_Normal_Point);

                                Plane_Normal_Point_UVC = UVC_Coordinates(Plane_Normal_Point_UVC_Index, :);

                            % Determine which One Has the Larger RHO Value - Larger Value is Closer to the Surface of the Heart:

                                if Plane_Anchor_Point_UVC(2) > Plane_Normal_Point_UVC(2)

                                    Plane_Normal_Unit = -1 * Plane_Normal_Unit;

                                elseif Plane_Anchor_Point_UVC(2) < Plane_Normal_Point_UVC(2)

                                    Plane_Normal_Unit = 1 * Plane_Normal_Unit;

                                end

% %                         % Plot to Validate the Results:
% % 
% %                             figure(3);
% % 
% %                                 hold on;
% % 
% %                                     surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% % 
% %                                     scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*g');
% % 
% %                                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_One_Unit(1), Plane_Vector_One_Unit(2), Plane_Vector_One_Unit(3), 'b');
% % 
% %                                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_Two_Unit(1), Plane_Vector_Two_Unit(2), Plane_Vector_Two_Unit(3), 'b');
% % 
% %                                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'b');
% % 
% %                                     pcshow(Heart_Surface, 'y');
% % 
% %                                     title('Fitted Plane with Desired Components');
% % 
% %                                     xlabel('X-Axis');
% %                                     ylabel('Y-Axis');
% %                                     zlabel('Z-Axis');
% % 
% %                                 hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Determine the Fiber Orientation Angle - Imbrication and Plane Angle:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Imbrication Angle: 

                    % Calcualte the Angle Between the Normal and the Fiber Vector:

                        Temporary_Imbrication_Angle = atan2d(norm(cross(Temporary_Vector, Plane_Normal_Unit)),dot(Temporary_Vector, Plane_Normal_Unit));

                        % Determine the Correct Orientation for the Angle with Respect to a RHO Plane and Epicardium:

                            if Temporary_Imbrication_Angle > 90

                                Imbrication_Angle(First_Index, 1) = -1 * (90 - Temporary_Imbrication_Angle);

                            elseif Temporary_Imbrication_Angle < 90

                                Imbrication_Angle(First_Index, 1) = 90 - Temporary_Imbrication_Angle;

                            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                 % Fiber Angle:

                    % Project Fiber onto the Plane - Remove Imbrication Component:

                        Fiber_Projection_with_Normal = (dot(Temporary_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                        Projected_Fiber_Vector = Temporary_Vector - Fiber_Projection_with_Normal;

                    % Project Z-Unit Vector to Preform Angle Calculation in Plane:

                        Z_Unit_Vector = [0, 0, 1];

                        Z_Projection_with_Normal = (dot(Z_Unit_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                        Projected_Z_Unit_Vector = Z_Unit_Vector - Z_Projection_with_Normal;

                    % Calculate a Vector Perpendicular to the Projected Z Unit Vector:

                        Horizontal_Plane_Vector_Option_One = cross(Projected_Z_Unit_Vector, Plane_Normal_Unit);
                        Horizontal_Plane_Vector_Option_Two = -1 * Horizontal_Plane_Vector_Option_One;

                        % Determien Orientation of the Horizontal by Choosing Component that Follows the "Right Hand Rule":
                        
                            Cross_Product_Option_One = cross(Horizontal_Plane_Vector_Option_One, Projected_Z_Unit_Vector);
                            Cross_Product_Option_Two = cross(Horizontal_Plane_Vector_Option_Two, Projected_Z_Unit_Vector);
                            
                            % Determine which Resulting Vector Points in the Same Direction as the Normal:
                            
                                Plane_Normal_Unit_Sign = sign(Plane_Normal_Unit);
                            
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

                        Z_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Projected_Z_Unit_Vector)),dot(Projected_Fiber_Vector, Projected_Z_Unit_Vector)));
                        X_Positive_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Horizontal_Plane_Vector)),dot(Projected_Fiber_Vector, Horizontal_Plane_Vector)));
                        X_Negative_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, (-1*Horizontal_Plane_Vector))),dot(Projected_Fiber_Vector, (-1 * Horizontal_Plane_Vector))));

                        if (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value < 90)

                            Quadrant_Location = 1;

                            Fiber_Angle(First_Index, 1) = X_Positive_Vector_Angle_Value;

                        elseif (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value > 90)

                            Quadrant_Location = 2;

                            Fiber_Angle(First_Index, 1) = -1 * X_Negative_Vector_Angle_Value;

                        elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value < 90)

                            Quadrant_Location = 3;

                            Fiber_Angle(First_Index, 1) = -1 * X_Positive_Vector_Angle_Value;

                        elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value > 90)

                            Quadrant_Location = 4;

                            Fiber_Angle(First_Index, 1) = X_Negative_Vector_Angle_Value;

                        end

% %                     % Plot to Validate the Results:
% % 
% %                         figure(10);
% % 
% %                             hold on;
% % 
% %                                 pcshow(Anchor_Plane_Point, 'k');
% % 
% %                                 surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'y');
% % 
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Z_Unit_Vector(1), Projected_Z_Unit_Vector(2), Projected_Z_Unit_Vector(3), 'r');
% % 
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Fiber_Vector(1), Projected_Fiber_Vector(2), Projected_Fiber_Vector(3), 'b');
% % 
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Horizontal_Plane_Vector(1), Horizontal_Plane_Vector(2), Horizontal_Plane_Vector(3), 'g');
% % 
% %                             hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %             % Plot to Validate the Results:
% % 
% %                 figure(5);
% % 
% %                     hold on;
% % 
% %                         surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'y');
% % 
% %                         scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*b');
% % 
% %                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'r');
% % 
% %                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Fiber_Vector(1), Projected_Fiber_Vector(2), Projected_Fiber_Vector(3), 'b');
% % 
% %                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Z_Unit_Vector(1), Projected_Z_Unit_Vector(2), Projected_Z_Unit_Vector(3), 'g');
% % 
% %                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'm');
% % 
% %                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Horizontal_Plane_Vector(1), Horizontal_Plane_Vector(2), Horizontal_Plane_Vector(3), 'c');
% % 
% %                         legend('Fitted Plane', 'Point of Interest', 'Original Fiber Vector', 'Projected Fiber Vector', 'Projected Unit Z', 'Plane Normal', 'Projected Horizontal');
% % 
% %                         xlabel('X-Axis');
% %                         ylabel('Y-Axis');
% %                         zlabel('Z-Axis');
% % 
% %                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Rotate the Points so the Stimulation Site and Heart Surface Point are Along the Z-Axis:

        % Make the Stimulation Site the Origin:
        
            Element_Centroids_of_Interest = Element_Centroid(Cylinder_Indicies, :);

            Centered_Element_Centroids_of_Interest = Element_Centroids_of_Interest - Stimulation_Site;
            Centered_Heart_Surface_Point = Heart_Surface_Point - Stimulation_Site;

        % Make the Heart Surface Point Line Up with the Z-Axis:

            % Create a Vector to the Two Points:

                    Cylinder_Vector = Centered_Heart_Surface_Point';
                    Z_Axis_Vector = [0; 0; 1];

                % Rotate the Vector to be at the Z - Axis:

                    Rotate_to_Z_Axis_Values = vrrotvec(Cylinder_Vector, Z_Axis_Vector);
                    Rotation_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

                    Rotated_Centered_Element_Centroids_of_Interest = Centered_Element_Centroids_of_Interest * Rotation_Matrix';
                    Rotated_Centered_Heart_Surface_Point = Centered_Heart_Surface_Point * Rotation_Matrix';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Divide the Cylinder into Sections and Calcualte the Mean of the Sections:

        % Determine the Range the Values Fall Into

            Minimum_Value = floor(min(Rotated_Centered_Element_Centroids_of_Interest(:, 3)));
            Maximum_Value = ceil(max(Rotated_Centered_Element_Centroids_of_Interest(:, 3)));

        % Go Through and Calculate the Mean for the Ranges Set Above:

            Division_Points = Minimum_Value:Division_Value:Maximum_Value;

            Average = zeros((size(Division_Points, 2) - 1), 1);

            for First_Index = 1:(size(Division_Points, 2) - 1)

                Temporary_Lower_Bound = Division_Points(First_Index);
                Temporary_Upper_Bound = Division_Points(First_Index + 1);

                % Find Points with the Given Range:

                    Temporary_Indicies = find(Rotated_Centered_Element_Centroids_of_Interest(:, 3) > Temporary_Lower_Bound & Rotated_Centered_Element_Centroids_of_Interest(:, 3) < Temporary_Upper_Bound);
                    Average(First_Index, 1) = median(Fiber_Angle(Temporary_Indicies));
                    
                    if size(Temporary_Indicies, 1) == 0
                        
                        Average_Location(First_Index, 1) = NaN;
                        
                    else
                        
                        Bounding_Points = [Temporary_Lower_Bound, Temporary_Upper_Bound];
                        Average_Location(First_Index, 1) = mean(Bounding_Points);
                        
                    end

            end

        % Calculate the Final Average Value:

            % Remove NaN from Data incase No Value is Present:

                Average = rmmissing(Average);
                Average_Location = rmmissing(Average_Location);
                
                Average_Location(:, 2:3) = 0;

                Mean_Fiber_Angle = mean(Average);
                STD_Fiber_Angle = std(Average);

% %         % Plot to Validate the Results:
% % 
% %             Number_of_Points = 1:size(Average, 1);
% % 
% %             figure(1);
% % 
% %                 hold on;
% % 
% %                     plot(Number_of_Points, Average, '-ko')
% % 
% %                 hold off;
        