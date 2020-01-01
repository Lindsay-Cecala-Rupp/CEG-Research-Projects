function [Global_Projected_Points, Implemented_Points, Rotate_to_Axis_Matrix] = Global_Plane_Fitting_Function(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location)

    % Determine the Center of the Breakthrough Site:

        Breakthrough_Site_Points = [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location]';

        Breakthrough_Site_Centroid = [mean(Activated_Electrode_X_Location); mean(Activated_Electrode_Y_Location); mean(Activated_Electrode_Z_Location)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create a Vector from the Sock Centroid (Origin) to the Breakthrough Site Centroid:

        % Sock Centroid Vectors (X, Y and Z):

            Origin_X_Vector = [1; 0; 0]; 
            Origin_Y_Vector = [0; 1; 0]; 
            Origin_Z_Vector = [0; 0; 1]; 

        % Breakthrough Site Vector:

            Breakthrough_Site_Vector = [Breakthrough_Site_Centroid(1); Breakthrough_Site_Centroid(2); Breakthrough_Site_Centroid(3)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Determine Which Axis Has the Smallest Rotation to the Breakthrough Site Vector:

        Rotate_to_X_Axis_Values = vrrotvec(Breakthrough_Site_Vector, Origin_X_Vector);
        Rotate_to_Y_Axis_Values = vrrotvec(Breakthrough_Site_Vector, Origin_Y_Vector);
        Rotate_to_Z_Axis_Values = vrrotvec(Breakthrough_Site_Vector, Origin_Z_Vector);

        Combined_Rotation_Values = [Rotate_to_X_Axis_Values(1, 4), Rotate_to_Y_Axis_Values(1, 4), Rotate_to_Z_Axis_Values(1, 4)];

        [~, Minimum_Rotation_Location] = min(Combined_Rotation_Values);

        % Create Rotation Matrix Depending on Minimum Angle Value:

            if Minimum_Rotation_Location == 1

                Rotate_to_Axis_Matrix = vrrotvec2mat(Rotate_to_X_Axis_Values);

            elseif Minimum_Rotation_Location == 2

                Rotate_to_Axis_Matrix = vrrotvec2mat(Rotate_to_Y_Axis_Values);

            elseif Minimum_Rotation_Location == 3

                Rotate_to_Axis_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Apply Rotation to Points:

        All_Global_Projected_Points = Breakthrough_Site_Points' * Rotate_to_Axis_Matrix';

        % Remove Points in Set that is Equivalent to the Rotated Axis:

            if Minimum_Rotation_Location == 1

                Global_Projected_Points = [All_Global_Projected_Points(:, 2), All_Global_Projected_Points(:, 3)];
                Implemented_Points = [2, 3];

            elseif Minimum_Rotation_Location == 2

                Global_Projected_Points = [All_Global_Projected_Points(:, 1), All_Global_Projected_Points(:, 3)];
                Implemented_Points = [1, 3];

            elseif Minimum_Rotation_Location == 3

                Global_Projected_Points = [All_Global_Projected_Points(:, 1), All_Global_Projected_Points(:, 2)];
                Implemented_Points = [1, 2];

            end

end