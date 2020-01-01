function [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Percent_Act_Breakthrough_Site_Electrode_Determination_Function(Upsampled_Points, Upsampled_Activation_Times, Percent_into_QRS_Peak)

    % Determine Which "Electrodes" Have an Activation Time Within a Certain Percentage of the QRS Peak:

        % Determine Range of Activation Times:

            Activation_Time_Range = max(Upsampled_Activation_Times) - min(Upsampled_Activation_Times);

            Percent_Value = Percent_into_QRS_Peak*Activation_Time_Range + min(Upsampled_Activation_Times); 

        % Find Electrodes Less than the Percent Value:

            Activated_Electrodes_Storage_Vector = zeros(1, size(Upsampled_Activation_Times, 2)); % One if Activated in Time and Zero if Not Activated

            for First_Index = 1:size(Upsampled_Activation_Times, 2)

                Temporary_Activation_Time = Upsampled_Activation_Times(1, First_Index);

                if Temporary_Activation_Time < Percent_Value

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

% %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     
% %     % Plot the Electrodes to Visualize Breakthrough Site:
% %     
% %         figure(1)
% %         
% %             hold on;
% %             
% %                 scatter3(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location, 'k')
% %                 
% %                 xlabel('X-Axis');
% %                 ylabel('Y-Axis');
% %                 zlabel('Z-Axis');
% %                 
% %                 title('Breakthrough Site Electrodes');
% %                 
% %             hold off;
% %             
% %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end