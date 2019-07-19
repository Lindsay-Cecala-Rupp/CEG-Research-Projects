
% Script to Determine the Face Coordinates that are Connected to the First Activated Electrode:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Load in Data:

    Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Data/CARP_Sock_Biomesh_Space.mat');
        Points = Geometry.scirunfield.node;
        Faces = Geometry.scirunfield.face;

    Activation = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Data/act_needle_910.txt');
        Activation_Times = Activation(:, 1)';
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the First Activated Electrode:

    [First_Activated_Time, First_Activated_Electrode] = min(Activation_Times);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine Which Faces Contain the Point:
    
    Connected_Faces = find(Faces == First_Activated_Electrode);
    
    for First_Index = 1:size(Connected_Faces, 1)
        
        [Temporary_Row, Temporary_Column] = ind2sub(size(Faces), Connected_Faces(First_Index, 1));
        
        Rows(First_Index) = Temporary_Row;
        Columns(First_Index) = Temporary_Column;
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Grab Electrodes in the Faces:

    for First_Index = 1:size(Columns, 2)
        
        Temporary_Value = Columns(First_Index);
        
        Temporary_Face = Faces(:, Temporary_Value);
        
        for Second_Index = 1:size(Temporary_Face, 1)
            
            
            if First_Index == 1 && Second_Index == 1
        
                Electrodes(First_Index) = Temporary_Face(Second_Index, 1);
                
            else
                
                Electrodes(end + 1) = Temporary_Face(Second_Index, 1);
                
            end
            
        end
                
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create Unique List of Electrodes:

    Electrodes = sort(Electrodes);
    
    % Remove Duplicates:
    
        Electrodes = unique(Electrodes);
        
    % Remove First Activated
    
        Electrode_Locations = find(Electrodes ~= First_Activated_Electrode);
        
        for First_Index = 1:size(Electrode_Locations, 2)
            
            Final_Electrodes(First_Index) = Electrodes(1, Electrode_Locations(1, First_Index));
            
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Grab the Electrodes Coordinates:

    for First_Index = 1:size(Final_Electrodes, 2)
        
        Temporary_Value = Final_Electrodes(1, First_Index);
        
        Faces_X_Coordinates(First_Index, 1) = Points(1, Temporary_Value);
        Faces_Y_Coordinates(First_Index, 1) = Points(2, Temporary_Value);
        Faces_Z_Coordinates(First_Index, 1) = Points(3, Temporary_Value);
        
    end
    
    % Plot the Validate Results:
    
        figure(1)
        
            hold on;
            
                scatter3(Faces_X_Coordinates, Faces_Y_Coordinates, Faces_Z_Coordinates, 'k');
                scatter3(Points(1, First_Activated_Electrode), Points(2, First_Activated_Electrode), Points(3, First_Activated_Electrode), 'r');
                
            hold off;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add First Activated Coordinate to the List:

    Faces_X_Coordinates(end + 1) = Points(1, First_Activated_Electrode);
    Faces_Y_Coordinates(end + 1) = Points(2, First_Activated_Electrode);
    Faces_Z_Coordinates(end + 1) = Points(3, First_Activated_Electrode);

    