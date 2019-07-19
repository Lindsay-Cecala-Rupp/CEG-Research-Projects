
% Script to Determine the Location of the Needle Electrode the Stimulation Occured at for CARP:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    Needle_Locations = load('/usr/sci/cibc/Maprodxn/InSitu/TestingData/Multi_D_CV_Project/14-10-27/14-10-27_Carp_Needles.mat');
        Needle_Locations = Needle_Locations.scirunfield.node;
    
    Needle_of_Interest = 9;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine where the Electrodes are Located on the Needle:

    if Needle_of_Interest == 1
        
        Points_of_Interest = Needle_Locations(:, 1:10);
        
    else
        
        Points_of_Interest = Needle_Locations(:, (((Needle_of_Interest-1)*10+1):((Needle_of_Interest-1)*10+10)));
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Break Apart the Points into Pacing Groups:

    for First_Index = 1:9 % For Nine Pacing Sites
        
        Pacing_Groups(First_Index, 1:3) = Points_of_Interest(:, First_Index);
        Pacing_Groups(First_Index, 4:6) = Points_of_Interest(:, First_Index + 1);
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcualte Average of the Two Points:

    for First_Index = 1:9 % For Nine Pacing Sites
        
        Temporary_X_Values = [Pacing_Groups(First_Index, 1), Pacing_Groups(First_Index, 4)];
        Temporary_Y_Values = [Pacing_Groups(First_Index, 2), Pacing_Groups(First_Index, 5)];
        Temporary_Z_Values = [Pacing_Groups(First_Index, 3), Pacing_Groups(First_Index, 6)];
        
        Pacing_Site(First_Index, 1) = mean(Temporary_X_Values);
        Pacing_Site(First_Index, 2) = mean(Temporary_Y_Values);
        Pacing_Site(First_Index, 3) = mean(Temporary_Z_Values);
        
    end
    
    Pacing_Site = Pacing_Site * 1000; % Times by 1000 for CARP Scaling Factor
    
    