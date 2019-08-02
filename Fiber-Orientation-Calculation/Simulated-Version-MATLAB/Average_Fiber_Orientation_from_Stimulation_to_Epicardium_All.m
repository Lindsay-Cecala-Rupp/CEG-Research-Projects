
% Script to Determine the Average Fiber Orientation from a Stimulation Site to the Surface of the Heart:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

% Magic Numbers::
    
        Coordinates_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863; 61896.3454585364, 46546.3782928587, 60263.0462579774; 63141.0142492862, 46578.0963352562, 61156.7382754684; 64385.683040036, 46609.8143776537, 62050.4302929595; 65630.3518307859, 46641.5324200512, 62944.1223104505; 66875.0206215357, 46673.2504624487, 63837.8143279415; 68119.6894122856, 46704.9685048461, 64731.5063454326; 69364.3582030354, 46736.6865472436, 65625.1983629236; 70609.0269937853, 46768.4045896411, 66518.8903804147];
            Coordinates_of_Interest = Coordinates_of_Interest/1000;
        
        %Coordinate_of_Interest = [70609.0269937853, 46768.4045896411, 66518.8903804147]/1000; % Epicardial Site
        %Coordinate_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863]/1000; % Endocardial Site
        
        Number_of_Centroid_Points = 5;
        Number_of_Surface_Points = 5;
        
        Cylinder_Radius = 5;
        
        Division_Value = 0.25;
        
        Electrode_Locations = [12, 23, 34, 45, 56, 67, 78, 89, 910];

    % Data:
    
        % Cartesian Model:

            %Fiber_Orientation = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
            Fiber_Orientation = readmatrix('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.lon.txt');
                Fiber_Orientation = Fiber_Orientation(:, 1:3); % NOTE: First Three Columns Correspond to Longitudinal Vectors, i.e., the Fiber Orientation.

            %Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
            Points = readmatrix('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
                Points = Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            %Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
            Elements = readmatrix('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
                Elements = Elements + 1; % To Make One Based Nodes that Make up "Face"
                
        % UVC Model:
                
            %UVC_RHO = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_RHO.pts');
            UVC_RHO = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_RHO.pts');
                UVC_RHO = UVC_RHO(2:end, 1); % Ignore First Element
                
            %UVC_PHI = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_PHI.pts');
            UVC_PHI = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_PHI.pts');
                UVC_PHI = UVC_PHI(2:end, 1); % Ignore First Element
                
            %UVC_V = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_V.pts');
            UVC_V = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_V.pts');
                UVC_V = UVC_V(2:end, 1); % Ignore First Element
                
            %UVC_Z = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_Z.pts');
            UVC_Z = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_Z.pts');
                UVC_Z = UVC_Z(2:end, 1); % Ignore First Element
                
            % Combine the Coordinates:
            
                UVC_Coordinates = [UVC_Z, UVC_RHO, UVC_PHI, UVC_V];
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go through All of the Given Stimulation Sites:

    for First_Index = 1:size(Coordinates_of_Interest, 1)
        
        % Load in Data that is Stimulation Site Specific:
        
            % Stimulation Data:
            
                %Heart_Surface_Data = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Heart-Surface/14-10-27-Electrodes', num2str(Electrode_Locations(First_Index)), '-Data-on-Surface.mat'));
                Heart_Surface_Data = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Simulated-Data/LVFW-Depth-Protocol/CARP-Data-on-Heart-Surface/14-10-27-Electrodes', num2str(Electrode_Locations(First_Index)), '-Data-on-Surface.mat'));
                        Heart_Surface = Heart_Surface_Data.scirunfield.node'; % Scaling is Different 
                        Activation_Times = Heart_Surface_Data.scirunfield.field;

            % Grab Correct Coordinate:
            
                Coordinate_of_Interest = Coordinates_of_Interest(First_Index, :);
                        
        % Script to Determine the Fiber Indicies of Interest:

            [Cylinder_Indicies, Element_Centroid, Stimulation_Site, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Coordinate_of_Interest, Number_of_Centroid_Points, Number_of_Surface_Points, Cylinder_Radius, Points, Elements, Heart_Surface, Activation_Times);

% %             % Plot to Validate the Results:
% % 
% %                 Element_Centroid_Point_Cloud = pointCloud(Element_Centroid);
% %                 Desired_Cylinder_Point_Cloud = select(Element_Centroid_Point_Cloud, Cylinder_Indicies);
% % 
% %                 figure(1);
% % 
% %                     hold on;
% % 
% %                         pcshow(Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
% %                         pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');
% % 
% %                         title('Selected Cylinder Points');
% % 
% %                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Determine the Angle of Fiber Indicies of Interest:

            [Imbrication_Angle, Fiber_Angle] = Fiber_Angle_for_Given_Fiber_Vector_Surface_Fitting_Function(Element_Centroid, Cylinder_Indicies, Fiber_Orientation, Points, UVC_Coordinates, UVC_RHO, UVC_PHI, UVC_Z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Calcualte the Average Results:

            Element_Centroids_of_Interest = Element_Centroid(Cylinder_Indicies, :);

            [Mean_Fiber_Angle, STD_Fiber_Angle] = Calculate_Average_of_Fiber_Angles_Function(Fiber_Angle, Element_Centroids_of_Interest, Stimulation_Site, Heart_Surface_Point, Division_Value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Save Out the Data:
        
            % Results:
        
                Mean_Angle(First_Index, 1) = Mean_Fiber_Angle;
                STD_Angle(First_Index, 1) = STD_Fiber_Angle;
                
            % Intermediate Steps:
            
                File_Name_One = sprintf('14-10-27-Electrodes%d-Element_Points.pts', Electrode_Locations(First_Index));
                File_Name_Two = sprintf('14-10-27-Electrodes%d-Element_Points.mat', Electrode_Locations(First_Index));
                File_Name_Three = sprintf('14-10-27-Electrodes%d-Fiber_Angles.pts', Electrode_Locations(First_Index));
                File_Name_Four = sprintf('14-10-27-Electrodes%d-Imbrication_Angles.pts', Electrode_Locations(First_Index));
                
                save(File_Name_One, 'Element_Centroids_of_Interest', '-ascii');
                save(File_Name_Two, 'Element_Centroids_of_Interest');
                save(File_Name_Three, 'Fiber_Angle');
                save(File_Name_Four, 'Imbrication_Angle');
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Clear Variables that aren't Necessary:
        
            clearvars -except Mean_Angle STD_Angle First_Index UVC_Coordinates UVC_RHO UVC_PHI UVC_Z UVC_V Elements Points Fiber_Orientation Electrode_Locations Division_Value Cylinder_Radius Number_of_Surface_Points Number_of_Centroid_Points Coordinates_of_Interest

    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('14-10-27-Average-Angle-Results_Mean.mat', 'Mean_Angle');
save('14-10-27-Average_Anlge_Results_STD.mat', 'STD_Angle');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
