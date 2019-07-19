function [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Time_Breakthrough_Site_Electrode_Determination_Function(Upsampled_Points, Upsampled_Activation_Times, Time_Into_QRS_Peak)

    % Determine Which "Electrodes" Have an Activation Time Less than the Set Time Point:

        % Note: Since Stimulated Data the QRS is Equal to Zero
        
        % Note: For Experimental Data - Subtracted the QRS On from Points so Should Be Equivalent to Saying QRS On Equals Zero.

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

end