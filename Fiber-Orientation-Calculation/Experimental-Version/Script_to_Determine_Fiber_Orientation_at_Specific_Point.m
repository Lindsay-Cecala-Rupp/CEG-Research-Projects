
% Script to Create Cylinder to Crop DTI-MRI Fiber Field with in SCIRun:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Manually Input Data:
    
        % Stimulation Site:
    
            Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Electrodes 12
            % Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Electrodes 910
        
        % Time Signal:
            
            Run_Number = 36; 

            % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
                if Run_Number > 0 && Run_Number <= 9
                    
                    Number_of_Zeros = '000';
                    
                elseif Run_Number > 9 && Run_Number <= 99 
                    
                    Number_of_Zeros = '00';
                    
                else
                    
                    Number_of_Zeros = '0';
                    
                end

    % Magic Numbers for Code to Function:
        
        Number_of_Centroid_Points = 5;
        Number_of_Surface_Points = 5;
        
        Cylinder_Radius = 5;
        
        Division_Value = 0.25;
        
        Barycentric_Grid_Resolution = 0.2;
        Angle_Grid_Resolution = 0.1;
        
        PHI_Range = 0.25;
        Z_Range = 0.05;
        RHO_Range = 0.05;

    % Data:
    
        % Cartesian CARP Model:

            Fiber_Orientation = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
            % Fiber_Orientation = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.lon.txt');
                Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

            Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
            % Points = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.pts.txt');
                Points = Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
            % Elements = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.elem.txt');
                Elements = Elements + 1; % To Make One Based Nodes that Make up "Face"
                
        % UVC CARP Model:
                
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
                
        % Experimental Sock:

            Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/Geometry-Files/14-10-27_Carp_sock_Snapped.mat');
                Sock_Points = Geometry.Sock_US.node;
                Sock_Faces = Geometry.Sock_US.face;
            
        % Laplacian Interpolation Files:
        
            Bad_Leads = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat'); 
                Bad_Leads = Bad_Leads.Bad_Lead_Mask; 
                
            Mapping_Matrix = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');
                Mapping_Matrix = Mapping_Matrix.scirunmatrix;
                
        % DTI-MRI Fiber Field:
        
            DTI_Fiber_Orientation_Data = load('/Users/lindsayrupp/Downloads/DDTIFieldClipped-1.mat');
                DTI_Fiber_Points = DTI_Fiber_Orientation_Data.scirunfield.node;
                DTI_Fiber_Vectors = DTI_Fiber_Orientation_Data.scirunfield.field;
                DTI_Fiber_Elements = DTI_Fiber_Orientation_Data.scirunfield.cell;
                
                % Apply Translation Due to Offset:
                
                    DTI_Fiber_Points = DTI_Fiber_Points + [39.677, 40.8222, 47.3222]';
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine the Centroid of the MRI-Mesh:

    DTI_Element_Centroid = zeros(size(DTI_Fiber_Elements, 2), 3);

        for First_Index = 1:size(DTI_Fiber_Elements, 2)

            Temporary_Element_Points = DTI_Fiber_Elements(:, First_Index);

            Temporary_Points = DTI_Fiber_Points(:, Temporary_Element_Points);

            DTI_Element_Centroid(First_Index, 1) = mean(Temporary_Points(1, :));
            DTI_Element_Centroid(First_Index, 2) = mean(Temporary_Points(2, :));
            DTI_Element_Centroid(First_Index, 3) = mean(Temporary_Points(3, :));

        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the Designated Number of Centroid Points Near the Point of Interest:

    Desired_Index = zeros(Number_of_Centroid_Points, 1);

    Adjusted_DTI_Element_Centroid = DTI_Element_Centroid;

    for First_Index = 1:Number_of_Centroid_Points
        
        Closest_Position_Index = dsearchn(Adjusted_DTI_Element_Centroid, Coordinate_of_Interest);
        
        Adjusted_DTI_Element_Centroid(Closest_Position_Index, :) = Adjusted_DTI_Element_Centroid(Closest_Position_Index, :) * 5000;
        
        Desired_Index(First_Index, 1) = Closest_Position_Index;
          
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Centroid of Each CARP Element:

    CARP_Element_Centroid = zeros(size(Elements, 1), 3);

        for First_Index = 1:size(Elements, 1)

            Temporary_Element_Points = Elements(First_Index, 2:5);

            Temporary_Points = Points(Temporary_Element_Points, :);

            CARP_Element_Centroid(First_Index, 1) = mean(Temporary_Points(:, 1));
            CARP_Element_Centroid(First_Index, 2) = mean(Temporary_Points(:, 2));
            CARP_Element_Centroid(First_Index, 3) = mean(Temporary_Points(:, 3));

        end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Calcualte the Fiber Angle for the Designated Number of Points:

    Fiber_Angle = zeros(size(Number_of_Centroid_Points, 1), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go Through Each Fiber Individually:
    
        for First_Index = 1:Number_of_Centroid_Points
            
            Temporary_Index = Desired_Index(First_Index, 1);
            
            Temporary_DTI_Point = DTI_Element_Centroid(Temporary_Index, :);
            
            Temporary_DTI_Vector = DTI_Fiber_Vectors(:, Temporary_Index);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Script to Find the Closest CARP Mesh Point in Cartesian and UVC to the DTI Fiber Location:
            
                Temporary_CARP_Index = dsearchn(Points, Temporary_DTI_Point);
                
                Temporary_CARP_Point = Points(Temporary_CARP_Index, :);
                
                Temprary_CARP_UVC = UVC_Coordinates(Temporary_CARP_Index, :);
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Script to Create a Plane Corresponding to RHO:
            
                % Pull UVC Indicies who Fall within a Set Range of PHI and Z:

                    Desired_Plane_Indicies_Storage_Vector = zeros(size(UVC_Coordinates, 1), 1);

                    for Second_Index = 1:size(UVC_Coordinates, 1)

                        Temporary_RHO = UVC_RHO(Second_Index, 1);
                        Temporary_PHI = UVC_PHI(Second_Index, 1);
                        Temporary_Z = UVC_Z(Second_Index, 1);

                        if (Temporary_RHO < (Temprary_CARP_UVC(2) + RHO_Range)) && (Temporary_RHO > (Temprary_CARP_UVC(2) - RHO_Range))

                            if (Temporary_PHI < (Temprary_CARP_UVC(3) + PHI_Range)) && (Temporary_PHI > (Temprary_CARP_UVC(3) - PHI_Range))

                                if (Temporary_Z < (Temprary_CARP_UVC(1) + Z_Range)) && (Temporary_Z > (Temprary_CARP_UVC(1) - Z_Range))

                                    Desired_Plane_Indicies_Storage_Vector(Second_Index, 1) = 1;

                                end

                            end

                        end

                    end

                    Desired_Plane_Indicies = find(Desired_Plane_Indicies_Storage_Vector == 1);

                % Fit a Plane to the Points:

                    Plane_Points_of_Interest = Points(Desired_Plane_Indicies, :);
                    
                    Surface_Fit = fit([Plane_Points_of_Interest(:, 1), Plane_Points_of_Interest(:, 2)], Plane_Points_of_Interest(:, 3), 'poly11', 'normalize', 'on');

                    [Plane_X, Plane_Y] = meshgrid((min(Plane_Points_of_Interest(:, 1))  - 5):Angle_Grid_Resolution:(max(Plane_Points_of_Interest(:, 1)) + 5), (min(Plane_Points_of_Interest(:, 2)) - 5):Angle_Grid_Resolution:(max(Plane_Points_of_Interest(:, 2)) + 5));

                    Plane_Z = Surface_Fit(Plane_X, Plane_Y);
                    
% %                     % Plot to Validate Results:
% % 
% %                         % Determine Which Points Have the Desired RHO Value for Visualization Purposes:
% % 
% %                             for Second_Index = 1:size(UVC_RHO, 1)
% % 
% %                                 Temporary_Value = UVC_RHO(Second_Index, 1);
% % 
% %                                 Wanted_Value = Temprary_CARP_UVC(2);
% % 
% %                                 if Temporary_Value > (Wanted_Value - 0.05)
% % 
% %                                     if Temporary_Value < (Wanted_Value + 0.05)
% % 
% %                                         RHO_Check(Second_Index, 1) = 1;
% % 
% %                                     else
% % 
% %                                         RHO_Check(Second_Index, 1) = 0;
% % 
% %                                     end
% % 
% %                                 else
% % 
% %                                     RHO_Check(Second_Index, 1) = 0;
% % 
% %                                 end
% % 
% %                             end
% % 
% %                             Desired_RHO_Indicies = find(RHO_Check == 1);
% % 
% %                             Cartesian_RHO_Coordiantes = Points(Desired_RHO_Indicies, :);
% % 
% %                         % Plot All Necessary Results:
% % 
% %                             figure(2);
% % 
% %                                 hold on;
% % 
% %                                     surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% % 
% %                                     pcshow(Cartesian_RHO_Coordiantes, 'w');
% % 
% %                                     scatter3(Temporary_CARP_Point(1), Temporary_CARP_Point(2), Temporary_CARP_Point(3), '*b');
% % 
% %                                     pcshow(Element_Centroid(Cylinder_Indicies_Simulation, :), 'g');
% % 
% %                                     zlabel('Z-Axis');
% %                                     ylabel('Y-Axis');
% %                                     xlabel('X-Axis');
% % 
% %                                     legend('Fitted Plane', 'RHO Plane', 'Point of Interest', 'Fiber Box');
% % 
% %                                     title('Tangent Plane Fitted to the RHO Plane of Interest');
% % 
% %                                 hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Script to Determine Information About the Plane in Order to do Necessary Calculations:

                % DTI Fiber's Location on the Calculated Plane:

                    Fiber_Distance_to_Plane = zeros(size(Plane_X, 1), size(Plane_Z, 2));

                    for Second_Index = 1:size(Plane_Z, 1)

                        for Third_Index = 1:size(Plane_Z, 2)

                            Fiber_Distance_to_Plane(Second_Index, Third_Index) = sqrt(((Temporary_DTI_Point(1) - Plane_X(Second_Index, Third_Index))^2) + ((Temporary_DTI_Point(2) - Plane_Y(Second_Index, Third_Index))^2) + ((Temporary_DTI_Point(3) - Plane_Z(Second_Index, Third_Index))^2));

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
                                
% %                             % Plot to Validate the Results:
% % 
% %                                 figure(3);
% % 
% %                                     hold on;
% % 
% %                                         surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% % 
% %                                         scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*g');
% % 
% %                                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_One_Unit(1), Plane_Vector_One_Unit(2), Plane_Vector_One_Unit(3), 'b');
% % 
% %                                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_Two_Unit(1), Plane_Vector_Two_Unit(2), Plane_Vector_Two_Unit(3), 'b');
% % 
% %                                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'b');
% % 
% %                                         title('Fitted Plane with Desired Components');
% % 
% %                                         xlabel('X-Axis');
% %                                         ylabel('Y-Axis');
% %                                         zlabel('Z-Axis');
% % 
% %                                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Script to Determine Fiber Angles:
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Imbrication Angle:

                    % Calcualte the Angle Between the Normal and the Fiber Vector:

                        Temporary_Imbrication_Angle = atan2d(norm(cross(Temporary_DTI_Vector, Plane_Normal_Unit)),dot(Temporary_DTI_Vector, Plane_Normal_Unit));

                        % Determine the Correct Orientation for the Angle with Respect to a RHO Plane and Epicardium:

                            if Temporary_Imbrication_Angle > 90

                                Imbrication_Angle(First_Index, 1) = -1 * (90 - Temporary_Imbrication_Angle);

                            elseif Temporary_Imbrication_Angle < 90

                                Imbrication_Angle(First_Index, 1) = 90 - Temporary_Imbrication_Angle;

                            end
                            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Fiber Angle:
                
                    % Project Fiber onto the Plane - Remove Imbrication Component:

                        Fiber_Projection_with_Normal = (dot(Temporary_DTI_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                        Projected_Fiber_Vector = Temporary_DTI_Vector' - Fiber_Projection_with_Normal;

                    % Project Z-Unit Vector to Preform Angle Calculation in Plane:

                        Z_Unit_Vector = [0, 0, 1];

                        Z_Projection_with_Normal = (dot(Z_Unit_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                        Projected_Z_Unit_Vector = Z_Unit_Vector - Z_Projection_with_Normal;

                    % Calculate a Vector Perpendicular to the Projected Z Unit Vector:

                        Horizontal_Plane_Vector_Option_One = cross(Projected_Z_Unit_Vector, Plane_Normal_Unit);
                        Horizontal_Plane_Vector_Option_Two = -1 * Horizontal_Plane_Vector_Option_One;

                        % Determine Orientation of the Horizontal by Choosing Component with Smaller PHI Value:

                            Horizontal_Plane_Point_Option_One = Anchor_Plane_Point + Horizontal_Plane_Vector_Option_One;
                            Horizontal_Plane_Point_Index_Option_One = dsearchn(Points, Horizontal_Plane_Point_Option_One);
                            Horizontal_Plane_UVC_Point_Option_One = UVC_Coordinates(Horizontal_Plane_Point_Index_Option_One, :);

                            Horizontal_Plane_Point_Option_Two = Anchor_Plane_Point + Horizontal_Plane_Vector_Option_Two;
                            Horizontal_Plane_Point_Index_Option_Two = dsearchn(Points, Horizontal_Plane_Point_Option_Two);
                            Horizontal_Plane_UVC_Point_Option_Two = UVC_Coordinates(Horizontal_Plane_Point_Index_Option_Two, :);

                            if Horizontal_Plane_UVC_Point_Option_One(3) < Horizontal_Plane_UVC_Point_Option_Two(3)

                                Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_One;

                            elseif Horizontal_Plane_UVC_Point_Option_One(3) > Horizontal_Plane_UVC_Point_Option_Two(3)

                                Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_Two;

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
                        
        end
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcualte the Average:

    Mean_Fiber_Angle = mean(Fiber_Angle);
    STD_Fiber_Angle = std(Fiber_Angle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    