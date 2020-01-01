     
% Script to "Cluster" the Points Together and Remove Second Breakthrough Sites:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in Relevant Variables:

    % Load in Data:
    
        Activated_Electrode_X_Location = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Experimental-Version/Laplacian-Interpolate/Other-Script-Data-for-Intermediate-Steps/Activated_Electrode_X_Location_Run36_Beat1_QRS25.mat');
            Activated_Electrode_X_Location = Activated_Electrode_X_Location.Activated_Electrode_X_Location;
            
        Activated_Electrode_Y_Location = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Experimental-Version/Laplacian-Interpolate/Other-Script-Data-for-Intermediate-Steps/Activated_Electrode_Y_Location_Run36_Beat1_QRS25.mat');
            Activated_Electrode_Y_Location = Activated_Electrode_Y_Location.Activated_Electrode_Y_Location;
            
        Activated_Electrode_Z_Location = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Experimental-Version/Laplacian-Interpolate/Other-Script-Data-for-Intermediate-Steps/Activated_Electrode_Z_Location_Run36_Beat1_QRS25.mat');
            Activated_Electrode_Z_Location = Activated_Electrode_Z_Location.Activated_Electrode_Z_Location;
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
% Implement Clustering:
    
            Coordinates = [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location]; % Combine Coordinates into One Variable
                Point_Cloud_Coordinates = pointCloud(Coordinates); % Create Point Cloud from Coordinates

            Minimum_Distance = 0.5; % NOTE: CAN CHANGE THIS VALUE TO BE ANYTHING !!!!!!!!!!

            [Cluster_Labels, Number_of_Clusters] = pcsegdist(Point_Cloud_Coordinates, Minimum_Distance);
        
            % Plot Results to Validate:

                figure(1)

                    hold on;

                        pcshow(Point_Cloud_Coordinates);

                        title('Unclustered Breakthrough Site');
                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');

                    hold off;

                figure(2)

                    hold on;

                        pcshow(Point_Cloud_Coordinates.Location, Cluster_Labels);

                        colormap(hsv(Number_of_Clusters));

                        title('Clustered Breakthrough Site');
                        xlabel('X-Axis');
                        ylabel('Y-Axis');
                        zlabel('Z-Axis');

                    hold off;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
% Pull Out Cluster with Most Points

    if Number_of_Clusters == 1

        Clustered_Activated_Electrode_X_Location = Activated_Electrode_X_Location;
        Clustered_Activated_Electrode_Y_Location = Activated_Electrode_Y_Location;
        Clustered_Activated_Electrode_Z_Location = Activated_Electrode_Z_Location;

    else

        for First_Index = 1:Number_of_Clusters
            
            Amount_Storage_Vector(First_Index, 1) = size(find(Cluster_Labels == First_Index), 1);
            
        end
        
        [Maximum_Value, Maximum_Location] = max(Amount_Storage_Vector);
        
        Implemented_Point_Locations = find(Cluster_Labels == Maximum_Location);
        
        Clustered_Activated_Electrode_X_Location = Activated_Electrode_X_Location(Implemented_Point_Locations);
        Clustered_Activated_Electrode_Y_Location = Activated_Electrode_Y_Location(Implemented_Point_Locations);
        Clustered_Activated_Electrode_Z_Location = Activated_Electrode_Z_Location(Implemented_Point_Locations);

    end
    
    