
% Script to Determine the Angle for Each Index Given:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Magic Numbers:
    
        Circle_Radius = 0.1;

    % Data:
    
        % Previous Script Results:
        
            Element_Centroid = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/Other-Script-Data-for-Intermediate-Steps/Element_Centroid_Electrode12.mat');
                Element_Centroid = Element_Centroid.Element_Centroid;
            
            Cylinder_Indicies = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/Other-Script-Data-for-Intermediate-Steps/Fiber_Index_Electrode12.mat');
                Cylinder_Indicies = Cylinder_Indicies.Cylinder_Indicies;
    
        % Cartesian Model:

            Fiber_Orientation = readmatrix('/Users/lindsayrupp/Desktop/Weekend-Project/14-10-27_Carp_mesh.biv.lon.txt');
            % Fiber_Orientation = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.lon.txt');
                Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

            Points = readmatrix('/Users/lindsayrupp/Desktop/Weekend-Project/14-10-27_Carp_mesh.biv.pts.txt');
            % Points = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.pts.txt');
                Points = Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            Elements = readmatrix('/Users/lindsayrupp/Desktop/Weekend-Project/14-10-27_Carp_mesh.biv.elem.txt');
            % Elements = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.elem.txt');
                Elements = Elements + 1; % To Make One Based Nodes that Make up "Face"

            Heart_Surface = load('/Users/lindsayrupp/Desktop/Weekend-Project/14-10-27-CARP-Heart-Surface.mat');
            % Heart_Surface = load('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/14-10-27-CARP-Heart-Surface.mat');
                Heart_Surface = Heart_Surface.scirunfield.node' .* (10^4); % Scaling is Different 
                
        % UVC Model:
                
            UVC_RHO = load('/Users/lindsayrupp//Downloads/14-10-27/UVC/COORDS_RHO.pts');
                UVC_RHO = UVC_RHO(2:end, 1); % Ignore First Element
                
            UVC_PHI = load('/Users/lindsayrupp//Downloads/14-10-27/UVC/COORDS_PHI.pts');
                UVC_PHI = UVC_PHI(2:end, 1); % Ignore First Element
                
            UVC_V = load('/Users/lindsayrupp//Downloads/14-10-27/UVC/COORDS_V.pts');
                UVC_V = UVC_V(2:end, 1); % Ignore First Element
                
            UVC_Z = load('/Users/lindsayrupp//Downloads/14-10-27/UVC/COORDS_Z.pts');
                UVC_Z = UVC_Z(2:end, 1); % Ignore First Element
                
            % Combine the Coordinates:
            
                UVC_Coordinates = [UVC_Z, UVC_RHO, UVC_PHI, UVC_V];
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Angle for Each Fiber in the Cylinder:

    for First_Index = 1%:size(Cylinder_Indicies, 1)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Find the Center Point for the Plane and Define Two Other Points in UVC:

            Temporary_Tail = Element_Centroid(Cylinder_Indicies(First_Index, 1), :);
            Temporary_Head = Fiber_Orientation(Cylinder_Indicies(First_Index, 1), :) + Element_Centroid(Cylinder_Indicies(First_Index, 1), :);
            Temporary_Vector = Fiber_Orientation(Cylinder_Indicies(First_Index, 1), :);

                % Plot to Validate Results:

                    figure(1);

                        hold on;

                            quiver3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'k');
                            scatter3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), 'r');
                            scatter3(Temporary_Head(1), Temporary_Head(2), Temporary_Head(3), 'r');

                        hold off;

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
                    Point_Two = [UVC_Coordinate_of_Interest(1), UVC_Coordinate_of_Interest(2), (UVC_Coordinate_of_Interest(3) + 0.01), UVC_Coordinate_of_Interest(4)];
                    Point_Three = [UVC_Coordinate_of_Interest(1), UVC_Coordinate_of_Interest(2), (UVC_Coordinate_of_Interest(3) - 0.01), UVC_Coordinate_of_Interest(4)];
                  
                    % Plot to Validate Results:

                        figure(2); 

                            hold on; 

                                scatter3(UVC_Coordinate_of_Interest(1), UVC_Coordinate_of_Interest(2), UVC_Coordinate_of_Interest(3), '.k');

                                scatter3(Point_One(1), Point_One(2), Point_One(3), 'r'); 
                                scatter3(Point_Two(1), Point_Two(2), Point_Two(3), 'r'); 
                                scatter3(Point_Three(1), Point_Three(2), Point_Three(3), 'r'); 

                                xlabel('UVC Z');
                                ylabel('UVC RHO');
                                zlabel('UVC PHI');

                            hold off;
                            
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
                
                for Third_Index = 1:size(Circle_Indicies, 1)
                    
                    Circle_Cartesian_Points(Third_Index, :) = Points(Circle_Indicies(Third_Index, 1), :);
                    
                end
                
                if Second_Index == 1
                    
                    Cartesian_Point_Two = [mean(Circle_Cartesian_Points(:, 1)), mean(Circle_Cartesian_Points(:, 2)), mean(Circle_Cartesian_Points(:, 3))];
                    
                elseif Second_Index == 2
                    
                    Cartesian_Point_Three = [mean(Circle_Cartesian_Points(:, 1)), mean(Circle_Cartesian_Points(:, 2)), mean(Circle_Cartesian_Points(:, 3))];
                    
                end
                
                clear Temporary_Point Circle_Distance Circle_Indicies Circle_Cartesian_Points
                
            end
            
            % Plot to Validate the Results:
            
                figure(3); 

                    hold on; 

                        scatter3(Cartesian_Point_One(1), Cartesian_Point_One(2), Cartesian_Point_One(3), 'r'); 
                        scatter3(Cartesian_Point_Two(1), Cartesian_Point_Two(2), Cartesian_Point_Two(3), 'r'); 
                        scatter3(Cartesian_Point_Three(1), Cartesian_Point_Three(2), Cartesian_Point_Three(3), 'r'); 

                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('X-Axis');

                    hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Fit a Plane to the Three Cartesian Points:

            % Determine the Normal for the Plane:

                Normal_Vector = cross(Cartesian_Point_Two - Cartesian_Point_One, Cartesian_Point_Three - Cartesian_Point_One);

            % Define the Plane:

                [X, Y] = meshgrid((Cartesian_Point_One(1, 1) - 0.5):0.1:(Cartesian_Point_One(1, 1) + 0.5));

                Z = -((Normal_Vector(1, 1) * X) + (Normal_Vector(1, 2) * Y) - ((Normal_Vector(1, 1) * Point_One(1, 1)) + (Normal_Vector(1, 2) * Point_One(1, 2)) + (Normal_Vector(1, 3) * Point_One(1, 3))))/(Normal_Vector(1, 3));

                % Plot to Validate the Results:

                    figure(4);

                        hold on;

                            surf(X, Y, Z)%, 'FaceColor', 'k');
                            scatter3(Cartesian_Point_One(1), Cartesian_Point_One(2), Cartesian_Point_One(3), 'r');
                            scatter3(Cartesian_Point_Two(1), Cartesian_Point_Two(2), Cartesian_Point_Two(3), 'r');
                            scatter3(Cartesian_Point_Three(1), Cartesian_Point_Three(2), Cartesian_Point_Three(3), 'r');


                        hold off;
                        

                            
                            
    end