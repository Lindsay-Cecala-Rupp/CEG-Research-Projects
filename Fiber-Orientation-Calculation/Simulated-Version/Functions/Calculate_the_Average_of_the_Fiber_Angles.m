
% Script to Determine the Fiber Orientation Indicies in a Desired Region:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Magic Numbers:
    
        Division_Value = 0.25; 

    % Data:
    
        Fiber_Angle = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/14-10-27-Electrodes12-R2-Fiber_Angle.mat');
            Fiber_Angle = Fiber_Angle.Fiber_Angle;
            
        Element_Centroids_of_Interest = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/14-10-27-Electrodes12-R2-Element_Centroid_of_Interest.pts');
        
        Stimulation_Site = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/14-10-27-Electrodes12-R2-Stimulation_Site.mat');
            Stimulation_Site = Stimulation_Site.Stimulation_Site;
        
        Heart_Surface_Point = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Fiber-Orientation-Calculation/Simulated-Version-MATLAB/14-10-27-Electrodes12-R2-Heart_Surface_Point.mat');
            Heart_Surface_Point = Heart_Surface_Point.Heart_Surface_Point;
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rotate the Points so the Stimulation Site and Heart Surface Point are Along the Z-Axis:

    % Make the Stimulation Site the Origin:
    
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
            
        end
        
    % Calculate the Final Average Value:
    
        % Remove NaN from Data incase No Value is Present:
        
            Average = rmmissing(Average);
    
            Mean_Fiber_Angle = mean(Average);
            STD_Fiber_Angle = std(Average);
        
    % Plot to Validate the Results:
    
        Number_of_Points = 1:size(Average, 1);
        
        figure(1);
            
            hold on;
            
                plot(Number_of_Points, Average, '-ko')
                
            hold off;


