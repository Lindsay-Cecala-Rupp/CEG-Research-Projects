
% Script to Determine the First Activated Electrodes Based on Bruno's Time into QRS Peak:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in Relevant Variables:

    Time_Into_QRS_Peak = 20;
    
% Load in Data:

    Upsampled_Points = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Up-Sampled-Data/Points_910.pts');

    Activation = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Up-Sampled-Data/Activation_Times_910.mat');
        Upsampled_Activation_Times = Activation.Whole_Whole_Sock_Activation_Times;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine Which "Electrodes" Have an Activation Time Less than the Set Time Point:

    % Note: Since Stimulated Data the QRS is Equal to Zero
    
    % Find Electrodes Less than the QRS Time Set:
    
        Activated_Electrodes_Storage_Vector = zeros(1, size(Upsampled_Activation_Times, 2)); % One if Activated in Time and Zero if Not Activated

        for First_Index = 1:size(Upsampled_Activation_Times, 2)

            Temporary_Activation_Time = Upsampled_Activation_Times(1, First_Index);

            if Temporary_Activation_Time < Time_Into_QRS_Peak

                Activated_Electrodes_Storage_Vector(1, First_Index) = 1;

            end

        end
        
        Activated_Electrode_Locations = find(Activated_Electrodes_Storage_Vector == 1);
        
        % Create Variables:
        
            Activated_Electrode_X_Location = zeros(size(Activated_Electrode_Locations, 2), 1);
            Activated_Electrode_Y_Location = zeros(size(Activated_Electrode_Locations, 2), 1);
            Activated_Electrode_Z_Location = zeros(size(Activated_Electrode_Locations, 2), 1);
        
        for First_Index = 1:size(Activated_Electrode_Locations, 2)
            
            Temporary_Electrode_Value = Activated_Electrode_Locations(1, First_Index);
            
            % Grab Coordinates:
            
                Activated_Electrode_X_Location(First_Index, 1) = Upsampled_Points(Temporary_Electrode_Value, 1);
                Activated_Electrode_Y_Location(First_Index, 1) = Upsampled_Points(Temporary_Electrode_Value, 2);
                Activated_Electrode_Z_Location(First_Index, 1) = Upsampled_Points(Temporary_Electrode_Value, 3);
            
        end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the Electrodes to Visualize Breakthrough Site:

    figure(1)
    
        hold on;
        
            scatter3(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location, 'k')
            
            xlabel('X-Axis');
            ylabel('Y-Axis');
            zlabel('Z-Axis');
            
            title('Breakthrough Site Electrodes');
            
        hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               