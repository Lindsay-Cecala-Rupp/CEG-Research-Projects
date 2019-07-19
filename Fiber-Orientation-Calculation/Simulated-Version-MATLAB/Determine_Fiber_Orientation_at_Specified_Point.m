
% Script to Determine the Fiber Orientation at a Specific Heart Coordinate:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Point of Interest:
    
        Coordinate_of_Interest = [78.8103, 50.8320, 33.0586];
        
        Number_of_Centroid_Points = 5;

    % Data:

        Fiber_Orientation = readmatrix('/Users/lindsayrupp/Desktop/Weekend-Project/Simulation-Data-13-11-05/13-11-05_Carp_Mesh.biv.lon.txt');
        %Fiber_Orientation = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/14-10-27_Carp_mesh.biv.lon.txt');
        %Fiber_Orientation = readmatrix('/Users/rupp/Documents/Fiber-Orientation-Calculation/Simulated-Version/13-11-05-Data/13-11-05_Carp_Mesh.biv.lon.txt');
            Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

        Points = readmatrix('/Users/lindsayrupp/Desktop/Weekend-Project/Simulation-Data-13-11-05/13-11-05_Carp_Mesh.biv.pts.txt');
        %Points = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/14-10-27_Carp_mesh.biv.pts.txt');
        %Points = readmatrix('/Users/rupp/Documents/Fiber-Orientation-Calculation/Simulated-Version/13-11-05-Data/13-11-05_Carp_Mesh.biv.pts.txt');
            Points = Points/1000; % Scale Factor for CARP Node Locations of Ventricles

        Elements = readmatrix('/Users/lindsayrupp/Desktop/Weekend-Project/Simulation-Data-13-11-05/13-11-05_Carp_Mesh.biv.elem.txt');
        %Elements = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/14-10-27_Carp_mesh.biv.elem.txt');
        %Elements = readmatrix('/Users/rupp/Documents/Fiber-Orientation-Calculation/Simulated-Version/13-11-05-Data/13-11-05_Carp_Mesh.biv.elem.txt');
            Elements = Elements + 1; % To Make One Based Nodes that Make up "Face"
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Centroid of Each Element:

    Element_Centroid = zeros(size(Elements, 1), 3);

    for First_Index = 1:size(Elements, 1)
        
        Temporary_Element_Points = Elements(First_Index, 2:5);
        
        Temporary_Points = Points(Temporary_Element_Points, :);
        
        Element_Centroid(First_Index, 1) = mean(Temporary_Points(:, 1));
        Element_Centroid(First_Index, 2) = mean(Temporary_Points(:, 2));
        Element_Centroid(First_Index, 3) = mean(Temporary_Points(:, 3));
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the Designated Number of Centroid Points Near the Point of Interest:

    Desired_Index = zeros(Number_of_Centroid_Points, 1);

    Adjusted_Element_Centroid = Element_Centroid;

    for First_Index = 1:Number_of_Centroid_Points
        
        Closest_Position_Index = dsearchn(Adjusted_Element_Centroid, Coordinate_of_Interest);
        
        Adjusted_Element_Centroid(Closest_Position_Index, :) = Adjusted_Element_Centroid(Closest_Position_Index, :) * 5;
        
        Desired_Index(First_Index, 1) = Closest_Position_Index;
          
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Average Fiber Orientation at the Desired Centroid Points:

    Desired_Fiber_Orientation = zeros(Number_of_Centroid_Points, 3);

    for First_Index = 1:Number_of_Centroid_Points
        
        Temporary_Index_Number = Desired_Index(First_Index, 1);
        
        Temporary_Fiber_Orientation(1, :) = Fiber_Orientation(Temporary_Index_Number, :);
        
        Desired_Fiber_Orientation(First_Index, 1) = Temporary_Fiber_Orientation(1, 1);
        Desired_Fiber_Orientation(First_Index, 2) = Temporary_Fiber_Orientation(1, 2);
        Desired_Fiber_Orientation(First_Index, 3) = Temporary_Fiber_Orientation(1, 3);
        
    end
    
    Mean_Fiber_Orientation = [mean(Desired_Fiber_Orientation(:, 1)), mean(Desired_Fiber_Orientation(:, 2)), mean(Desired_Fiber_Orientation(:, 3))];
    STD_Fiber_Orientation = [std(Desired_Fiber_Orientation(:, 1)), std(Desired_Fiber_Orientation(:, 2)), std(Desired_Fiber_Orientation(:, 3))];
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
