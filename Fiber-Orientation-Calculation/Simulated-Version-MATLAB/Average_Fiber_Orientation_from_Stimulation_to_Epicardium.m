
% Script to Determine the Average Fiber Orientation from a Stimulation Site to the Surface of the Heart:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

% Magic Numbers::
    
        Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Epicardial Site
        % Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Endocardial Site
        
        Number_of_Centroid_Points = 1;
        Number_of_Surface_Points = 1;
        
        Cylinder_Radius = 2;

    % Data:
    
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

% Script to Determine the Fiber Indicies of Interest:

    [Cylinder_Indicies, Element_Centroid] = Determine_Fiber_Indicies_in_Desired_Region_Function(Coordinate_of_Interest, Number_of_Centroid_Points, Number_of_Surface_Points, Cylinder_Radius, Points, Elements, Heart_Surface);
    
    % Plot to Validate the Results:
    
        Element_Centroid_Point_Cloud = pointCloud(Element_Centroid);
        Desired_Cylinder_Point_Cloud = select(Element_Centroid_Point_Cloud, Cylinder_Indicies);

        figure(1);

            hold on;

                pcshow(Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
                pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');

                title('Selected Cylinder Points');

            hold off;
