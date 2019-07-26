
% Script to Determine the Angle for Each Index Given:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Magic Numbers:
    
        Circle_Radius = 0.1;
        Grid_Resolution = 0.01;

    % Data:
    
        % Previous Script Results:
        
            Element_Centroid = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/Other-Script-Data-for-Intermediate-Steps/14-10-27-Element_Centroids.mat');
                Element_Centroid = Element_Centroid.Element_Centroid;
            
            Cylinder_Indicies = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/Other-Script-Data-for-Intermediate-Steps/Electrode12_Break_Radius5.mat');
                Cylinder_Indicies = Cylinder_Indicies.Cylinder_Indicies;
    
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

            Heart_Surface_Data = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/Geometry-Files/14-10-27-CARP-Epicardial-Surface-Electrodes12.mat');
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

% Calculate the Angle for Each Fiber in the Cylinder:

    Imbrication_Angle = zeros(size(Cylinder_Indicies, 1), 1);
    Fiber_Angle = zeros(size(Cylinder_Indicies, 1), 1);

    for First_Index = 1%1:size(Cylinder_Indicies, 1)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Find the Center Point for the Plane and Define Two Other Points in UVC:

            Temporary_Tail = Element_Centroid(Cylinder_Indicies(First_Index, 1), :);
            Temporary_Head = Fiber_Orientation(Cylinder_Indicies(First_Index, 1), :) + Element_Centroid(Cylinder_Indicies(First_Index, 1), :);
            Temporary_Vector = Fiber_Orientation(Cylinder_Indicies(First_Index, 1), :);

% %                 % Plot to Validate Results:
% % 
% %                     figure(1);
% % 
% %                         hold on;
% % 
% %                             quiver3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'k');
% %                             scatter3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), 'r');
% %                             scatter3(Temporary_Head(1), Temporary_Head(2), Temporary_Head(3), 'r');
% % 
% %                             title('Plot of the Current Vector of Interest');
% %                             
% %                             xlabel('X-Axis');
% %                             ylabel('Y-Axis');
% %                             zlabel('Z-Axis');
% %                             
% %                         hold off;

            % Find the UVC Coordinate the Cooresponds to the Centroid of the Desired Element:

                % Grab the Four Nodes that Make up the Desired Element:
                    
                    Node_Distance_Calculation = sqrt((Temporary_Tail(1) - Points(:, 1)).^2 + (Temporary_Tail(2) - Points(:, 2)).^2 + (Temporary_Tail(3) - Points(:, 3)).^2);
                    Node_Distance_Calculation(:, 2) = 1:size(Points, 1);

                    Node_Distance_Calculation = sortrows(Node_Distance_Calculation, 1);

                    Element_Nodes = Node_Distance_Calculation(1:4, 2);

                % Determine Cooresonding UVC Coordinate to the Four Nodes and Take the Average:
                
                    for Second_Index = 1:4
                        
                        UVC_Coordiantes_of_Interest(Second_Index, :) = UVC_Coordinates(Element_Nodes(Second_Index), :);
                        
                    end
                    
                    UVC_Coordinate_of_Interest = [mean(UVC_Coordiantes_of_Interest(:, 1)), mean(UVC_Coordiantes_of_Interest(:, 2)), mean(UVC_Coordiantes_of_Interest(:, 3)), mean(UVC_Coordiantes_of_Interest(:, 4))];

            % Create Two Additional Points on the Sides of the Predetermined Point in Order to Create Plane:

                    Point_One = UVC_Coordinate_of_Interest;
                    Point_Two = [UVC_Coordinate_of_Interest(1) + 0.1, UVC_Coordinate_of_Interest(2), (UVC_Coordinate_of_Interest(3)), UVC_Coordinate_of_Interest(4)];
                    Point_Three = [UVC_Coordinate_of_Interest(1) - 0.1, UVC_Coordinate_of_Interest(2), (UVC_Coordinate_of_Interest(3)), UVC_Coordinate_of_Interest(4)];
                  
% %                     % Plot to Validate Results:
% % 
% %                         figure(2); 
% % 
% %                             hold on; 
% % 
% %                                 scatter3(UVC_Coordinate_of_Interest(1), UVC_Coordinate_of_Interest(2), UVC_Coordinate_of_Interest(3), '.k');
% % 
% %                                 scatter3(Point_One(1), Point_One(2), Point_One(3), 'r'); 
% %                                 scatter3(Point_Two(1), Point_Two(2), Point_Two(3), 'r'); 
% %                                 scatter3(Point_Three(1), Point_Three(2), Point_Three(3), 'r'); 
% % 
% %                                 xlabel('UVC Z');
% %                                 ylabel('UVC RHO');
% %                                 zlabel('UVC PHI');
% %                                 
% %                                 title('Three Plane Points in UVC Space');
% % 
% %                             hold off;
                            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Determine the Defined Points Location in Cartesian Space:
        
            Cartesian_Point_One = Temporary_Tail;
        
            for Second_Index = 1:2
                
                if Second_Index == 1
                    
                    Temporary_Point = Point_Two;
                    
                elseif Second_Index == 2
                    
                    Temporary_Point = Point_Three;
                    
                end
                
                Circle_Distance = sqrt((Temporary_Point(1) - UVC_Coordinates(:, 1)).^2 + (Temporary_Point(2) - UVC_Coordinates(:, 2)).^2 + (Temporary_Point(3) - UVC_Coordinates(:, 3)).^2 + (Temporary_Point(4) - UVC_Coordinates(:, 4)).^2);
                
                Circle_Indicies = find(Circle_Distance <= Circle_Radius);
                
% %                 % Plot to Validate the Results:
% %                 
% %                     if Second_Index == 1
% %                     
% %                         figure(3);
% % 
% %                     elseif Second_Index == 2
% %                     
% %                         figure(4);
% %                     
% %                     end
% %                     
% %                     hold on; 
% %                     
% %                         scatter3(UVC_Z(Circle_Indicies), UVC_RHO(Circle_Indicies), UVC_PHI(Circle_Indicies), '.k'); 
% %                         scatter3(Temporary_Point(1), Temporary_Point(2), Temporary_Point(3), 'r'); 
% %                         scatter3(mean(UVC_Z(Circle_Indicies)), mean(UVC_RHO(Circle_Indicies)), mean(UVC_PHI(Circle_Indicies)), 'b')
% % 
% %                         legend('Sphere Points', 'True Point of Interest', 'Average of the Sphere Points');
% % 
% %                         title('UVC Sphere Around Point of Interest');
% % 
% %                         xlabel('UVC Z');
% %                         ylabel('UVC RHO');
% %                         zlabel('UVC PHI');
% %                     
% %                     hold off;
                    
                for Third_Index = 1:size(Circle_Indicies, 1)
                    
                    Circle_Cartesian_Points(Third_Index, :) = Points(Circle_Indicies(Third_Index, 1), :);
                    
                end
                
                if Second_Index == 1
                    
                    Cartesian_Point_Two = [mean(Circle_Cartesian_Points(:, 1)), mean(Circle_Cartesian_Points(:, 2)), mean(Circle_Cartesian_Points(:, 3))];
                    
                elseif Second_Index == 2
                    
                    Cartesian_Point_Three = [mean(Circle_Cartesian_Points(:, 1)), mean(Circle_Cartesian_Points(:, 2)), mean(Circle_Cartesian_Points(:, 3))];
                    
                end
                
% %                 % Plot to Validate the Results:
% %                 
% %                     if Second_Index == 1
% %                     
% %                         figure(5);
% %                         
% %                             hold on;
% %                             
% %                                 scatter3(Cartesian_Point_Two(1), Cartesian_Point_Two(2), Cartesian_Point_Two(3), 'r');
% %                         
% %                     elseif Second_Index == 2
% %                     
% %                         figure(6);
% %                         
% %                             hold on;
% %                             
% %                                 scatter3(Cartesian_Point_Three(1), Cartesian_Point_Three(2), Cartesian_Point_Three(3), 'r');
% %                         
% %                     end
% %                     
% %                                 scatter3(Circle_Cartesian_Points(:, 1), Circle_Cartesian_Points(:, 2), Circle_Cartesian_Points(:, 3), '.k');
% %                 
% %                                 xlabel('X-Axis');
% %                                 ylabel('Y-Axis');
% %                                 zlabel('Z-Axis');
% %                                 
% %                                 title('Cartesian Sphere Around Point on Interest');
% %                         
% %                             hold off;
                        
                clear Circle_Cartesian_Points
                
            end
            
% %             % Plot to Validate the Results:
% %             
% %                 figure(7); 
% % 
% %                     hold on; 
% % 
% %                         scatter3(Cartesian_Point_One(1), Cartesian_Point_One(2), Cartesian_Point_One(3), 'r'); 
% %                         scatter3(Cartesian_Point_Two(1), Cartesian_Point_Two(2), Cartesian_Point_Two(3), 'r'); 
% %                         scatter3(Cartesian_Point_Three(1), Cartesian_Point_Three(2), Cartesian_Point_Three(3), 'r'); 
% % 
% %                         xlabel('X-Axis');
% %                         ylabel('Y-Axis');
% %                         zlabel('X-Axis');
% %                         
% %                         title('Three Plane Points in Cartesian Space');
% % 
% %                     hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Fit a Plane to the Three Cartesian Points:
        
            % Define the Normal Vector:

                Three_Plane_Points = [Cartesian_Point_One; Cartesian_Point_Two; Cartesian_Point_Three];

                Plane_Centroid = [mean(Three_Plane_Points(:, 1)), mean(Three_Plane_Points(:, 2)), mean(Three_Plane_Points(:, 3))];

                Normal_Vector = cross(Cartesian_Point_Two - Cartesian_Point_One, Cartesian_Point_Three - Cartesian_Point_One);
                    
                Unit_Normal_Vector = Normal_Vector/(sqrt(Normal_Vector(1)^2 + Normal_Vector(2)^2 + Normal_Vector(3)^2));
                                
        % Define the Plane:
        
            Orthonormal_Vector = null(Unit_Normal_Vector);
            
            [Meshed_X, Meshed_Y] = meshgrid((min(Three_Plane_Points(:, 1)) - Plane_Centroid(1) - 5):Grid_Resolution:(max(Three_Plane_Points(:, 1)) - Plane_Centroid(1) + 5), (min(Three_Plane_Points(:, 2)) - Plane_Centroid(2) - 5):Grid_Resolution:(max(Three_Plane_Points(:, 2)) - Plane_Centroid(2) + 5));
            %[Meshed_X, Meshed_Y] = meshgrid(-50:Grid_Resolution:50);
            
            Plane_X = Plane_Centroid(1) + Orthonormal_Vector(1, 1) * Meshed_X + Orthonormal_Vector(1, 2) * Meshed_Y;
            Plane_Y = Plane_Centroid(2) + Orthonormal_Vector(2, 1) * Meshed_X + Orthonormal_Vector(2, 2) * Meshed_Y;
            Plane_Z = Plane_Centroid(3) + Orthonormal_Vector(3, 1) * Meshed_X + Orthonormal_Vector(3, 2) * Meshed_Y;
            
            % Plot to Validate the Results:
            
                figure(8);
                
                    hold on;
                    
                        surf(Plane_X, Plane_Y, Plane_Z);
                        
                        quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Unit_Normal_Vector(1), Unit_Normal_Vector(2), Unit_Normal_Vector(3), 'b');

                        scatter3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), 'b');
                        
                        quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'g');
                        
                        scatter3(Cartesian_Point_One(1), Cartesian_Point_One(2), Cartesian_Point_One(3), 'r');
                        scatter3(Cartesian_Point_Two(1), Cartesian_Point_Two(2), Cartesian_Point_Two(3), 'r');
                        scatter3(Cartesian_Point_Three(1), Cartesian_Point_Three(2), Cartesian_Point_Three(3), 'r');

                        legend('Fitted Plane', 'Normal Vector', 'Plane Centroid', 'Fiber Orientation', 'Three Plane Points');
                        
                    hold off;                 

% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % 
% % % % %         % Determine the Fiber Orientation Angle - Imbrication and Plane Angle:
% % % % %         
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % %         
% % % % %             % Imbrication Angle:
% % % % %             
% % % % %                 % Find Point on the Plane that is Closest to the Fiber Vector Head:
% % % % %                 
% % % % %                     % Calcualte the Distance from the Points of Interest to All Points on the Plane:
% % % % %                     
% % % % %                         Fiber_Head_from_Centroid = Temporary_Vector + Plane_Centroid;
% % % % %                 
% % % % %                         Plane_Distance_Calculation_Imbrication = zeros(size(Plane_X, 1), size(Plane_X, 2));
% % % % % 
% % % % %                         for Second_Index = 1:size(Plane_X, 1)
% % % % % 
% % % % %                             for Third_Index = 1:size(Plane_X, 2)
% % % % % 
% % % % %                                 Plane_Distance_Calculation_Imbrication(Second_Index, Third_Index) = sqrt((Fiber_Head_from_Centroid(1) - Plane_X(Second_Index, Third_Index))^2 + (Fiber_Head_from_Centroid(2) - Plane_Y(Second_Index, Third_Index))^2 + (Fiber_Head_from_Centroid(3) - Plane_Z(Second_Index, Third_Index))^2);
% % % % % 
% % % % %                             end
% % % % % 
% % % % %                         end
% % % % %                         
% % % % %                     % Find the Minimum Distance and Corresponding X, Y, and Z Values:
% % % % %                     
% % % % %                         Minimum_Matrix_Index_Value_Imbrication = find(Plane_Distance_Calculation_Imbrication == min(min(Plane_Distance_Calculation_Imbrication)));
% % % % %                         
% % % % %                         [Matrix_Row_Value_Imbrication, Matrix_Column_Value_Imbrication] = ind2sub(size(Plane_X), Minimum_Matrix_Index_Value_Imbrication);
% % % % %                         
% % % % %                         Plane_Coordinate_Value_of_Interest_Imbrication = [Plane_X(Matrix_Row_Value_Imbrication, Matrix_Column_Value_Imbrication), Plane_Y(Matrix_Row_Value_Imbrication, Matrix_Column_Value_Imbrication), Plane_Z(Matrix_Row_Value_Imbrication, Matrix_Column_Value_Imbrication)];
% % % % %                         
% % % % %                 % Create Two Vectors - The Fiber Orientation Vector and the Determined Plane Point Vector and Determine the Angle Between the Two:
% % % % %                 
% % % % %                     Vector_One_Imbrication = Fiber_Head_from_Centroid - Plane_Centroid;
% % % % %                     Vector_Two_Imbrication = Plane_Coordinate_Value_of_Interest_Imbrication - Plane_Centroid;
% % % % %                     
% % % % %                     Imbrication_Angle(First_Index, 1) = atan2d(norm(cross(Vector_One_Imbrication, Vector_Two_Imbrication)), dot(Vector_One_Imbrication, Vector_Two_Imbrication));
% % % % %                     
% % % % %                 % Determine Orientation, Positive or Negative, of the Angle:
% % % % %                 
% % % % %                     % Find Point on Surface Closest to Values:
% % % % %                 
% % % % %                         Centroid_Surface_Point = dsearchn(Heart_Surface, Plane_Centroid);
% % % % %                         Vector_Surface_Pont = dsearchn(Heart_Surface, Fiber_Head_from_Centroid);
% % % % %                         
% % % % %                     % Determine Distances Between the Points:
% % % % %                     
% % % % %                         Centroid_Surface_Distance = sqrt((Plane_Centroid(1) - Heart_Surface(Centroid_Surface_Point, 1))^2 + (Plane_Centroid(2) - Heart_Surface(Centroid_Surface_Point, 2))^2 + (Plane_Centroid(3) - Heart_Surface(Centroid_Surface_Point, 3))^2);
% % % % %                         Vector_Surface_Distance = sqrt((Fiber_Head_from_Centroid(1) - Heart_Surface(Centroid_Surface_Point, 1))^2 + (Fiber_Head_from_Centroid(2) - Heart_Surface(Centroid_Surface_Point, 2))^2 + (Fiber_Head_from_Centroid(3) - Heart_Surface(Centroid_Surface_Point, 3))^2);
% % % % %                     
% % % % %                     % Determine Which One Has the Smaller Distance:
% % % % %                     
% % % % %                         if Centroid_Surface_Distance < Vector_Surface_Distance
% % % % %                             
% % % % %                             Imbrication_Angle(First_Index, 1) = -1 * Imbrication_Angle(First_Index, 1);
% % % % %                             
% % % % %                         elseif Centroid_Surface_Distance > Vector_Surface_Distance
% % % % %                             
% % % % %                             Imbrication_Angle(First_Index, 1) = Imbrication_Angle(First_Index, 1);
% % % % %                             
% % % % %                         end
% % % % % 
% % % % % % %                     % Plot to Validate Results:
% % % % % % %                     
% % % % % % %                         figure(9);
% % % % % % %                         
% % % % % % %                             hold on;
% % % % % % %                     
% % % % % % %                                 quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Vector_One_Imbrication(1), Vector_One_Imbrication(2), Vector_One_Imbrication(3), 'b');
% % % % % % %                                 quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Vector_Two_Imbrication(1), Vector_Two_Imbrication(2), Vector_Two_Imbrication(3), 'r');
% % % % % % %                                 
% % % % % % %                                 scatter3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), 'k');
% % % % % % %                                 
% % % % % % %                                 xlabel('X-Axis');
% % % % % % %                                 ylabel('Y-Axis');
% % % % % % %                                 zlabel('Z-Axis');
% % % % % % %                                 
% % % % % % %                                 title('Imbrication Angle Calculation');
% % % % % % %                                 
% % % % % % %                                 legend('Fiber', 'Plane');
% % % % % % %                                 
% % % % % % %                             hold off;
% % % % % 
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % %                             
% % % % %             % Fiber Angle:
% % % % %               
% % % % %                 % Create Two Vectors - Projected Fiber on Plane and "X-Axis" Vector:
% % % % %                 
% % % % %                     Vector_One_Plane = Vector_Two_Imbrication;
% % % % %                     Vector_Two_Plane = Orthonormal_Vector(:, 1)';
% % % % %                     
% % % % %                     Fiber_Angle(First_Index, 1) = atan2d(norm(cross(Vector_One_Plane, Vector_Two_Plane)), dot(Vector_One_Plane, Vector_Two_Plane));
% % % % %                         
% % % % %                 % Determine Orientation, Positive or Negative, of the Angle:
% % % % %                 
% % % % %                     % Comparison of Z Points:
% % % % %                     
% % % % %                         if Plane_Centroid(3) > Plane_Coordinate_Value_of_Interest_Imbrication(3)
% % % % %                             
% % % % %                             Fiber_Angle(First_Index, 1) = 180 + (180 - Fiber_Angle(First_Index, 1));
% % % % %                             
% % % % %                         elseif Plane_Centroid(3) < Plane_Coordinate_Value_of_Interest_Imbrication(3)
% % % % %                             
% % % % %                             Fiber_Angle(First_Index, 1) = Fiber_Angle(First_Index, 1);
% % % % %                             
% % % % %                         end
% % % % %                     
% % % % % % %                     % Plot to Validate Results:
% % % % % % % 
% % % % % % %                         figure(10);
% % % % % % % 
% % % % % % %                             hold on;
% % % % % % % 
% % % % % % %                                 quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Vector_One_Plane(1), Vector_One_Plane(2), Vector_One_Plane(3), 'b');
% % % % % % %                                 quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Vector_Two_Plane(1), Vector_Two_Plane(2), Vector_Two_Plane(3), 'r');
% % % % % % % 
% % % % % % %                                 scatter3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), 'k');
% % % % % % % 
% % % % % % %                                 xlabel('X-Axis');
% % % % % % %                                 ylabel('Y-Axis');
% % % % % % %                                 zlabel('Z-Axis');
% % % % % % % 
% % % % % % %                                 title('Fiber Angle Calculation');
% % % % % % %                                 
% % % % % % %                                 legend('Fiber', 'X-Axis');
% % % % % % % 
% % % % % % %                             hold off;
% % % % % 
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % 
% % % % %         % Plot to Validate Results:
% % % % % 
% % % % %             figure(11);
% % % % % 
% % % % %                 hold on;
% % % % % 
% % % % %                     surf(Plane_X, Plane_Y, Plane_Z, 'FaceColor', 'y', 'EdgeColor', 'none'); 
% % % % % 
% % % % %                     quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'g'); 
% % % % %                     quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Vector_Two_Imbrication(1), Vector_Two_Imbrication(2), Vector_Two_Imbrication(3), 'b'); 
% % % % %                     quiver3(Plane_Centroid(1), Plane_Centroid(2), Plane_Centroid(3), Vector_Two_Plane(1), Vector_Two_Plane(2), Vector_Two_Plane(3), 'k');
% % % % % 
% % % % %                     legend('Plane', 'Fiber', 'Imbrication Angle Comparison', 'Plane Angle Comparison');
% % % % % 
% % % % %                     title('Check Results of Angle Calculation');
% % % % % 
% % % % %                     xlabel('X-Axis');
% % % % %                     ylabel('Y-Axis');
% % % % %                     zlabel('Z-Axis');
% % % % % 
% % % % %                 hold off;
% % % % %                 
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Check to See if Tangential to RHO Plane:

            % Find All Points with Desired RHO Value:

                for Second_Index = 1:size(UVC_RHO, 1)

                    Temporary_Value = UVC_RHO(Second_Index, 1);

                    Wanted_Value = UVC_Coordinate_of_Interest(2);

                    if Temporary_Value > (Wanted_Value - 0.05)

                        if Temporary_Value < (Wanted_Value + 0.05)

                            RHO_Check(Second_Index, 1) = 1;

                        else

                            RHO_Check(Second_Index, 1) = 0;

                        end

                    else

                        RHO_Check(Second_Index, 1) = 0;

                    end

                end

                Desired_Indicies = find(RHO_Check == 1);

            % Plot to Validate Results:

                Cartesian_Coordiantes = Points(Desired_Indicies, :);

                figure(12);

                    hold on;

                        pcshow(Cartesian_Coordiantes, 'w');
                        surf(Plane_X, Plane_Y, Plane_Z, 'FaceColor', 'r', 'EdgeColor', 'none'); 

                        scatter3(Cartesian_Point_One(1), Cartesian_Point_One(2), Cartesian_Point_One(3), 'b');
                        scatter3(Cartesian_Point_Two(1), Cartesian_Point_Two(2), Cartesian_Point_Two(3), 'b');
                        scatter3(Cartesian_Point_Three(1), Cartesian_Point_Three(2), Cartesian_Point_Three(3), 'b');

                    hold off;
     
    end