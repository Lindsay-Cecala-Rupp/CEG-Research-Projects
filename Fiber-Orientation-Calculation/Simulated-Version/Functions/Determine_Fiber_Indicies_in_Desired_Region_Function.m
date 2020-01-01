function [Cylinder_Indicies, Element_Centroid, Stimulation_Site, Heart_Surface_Point] = Determine_Fiber_Indicies_in_Desired_Region_Function(Coordinate_of_Interest, Number_of_Centroid_Points, Number_of_Surface_Points, Cylinder_Radius, Points, Elements, Heart_Surface, Activation_Times)

        % Script to Determine the Fiber Orientation Indicies in a Desired Region:

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

            Stimulation_Site_Index_Values = zeros(Number_of_Centroid_Points, 1);

            Adjusted_Element_Centroid = Element_Centroid;

            for First_Index = 1:Number_of_Centroid_Points

                Closest_Position_Index = dsearchn(Adjusted_Element_Centroid, Coordinate_of_Interest);

                Adjusted_Element_Centroid(Closest_Position_Index, :) = Adjusted_Element_Centroid(Closest_Position_Index, :) * 5000;

                Stimulation_Site_Index_Values(First_Index, 1) = Closest_Position_Index;

            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Take the Average of the Determined Points and Use as Stimulation Site:

            Stimulation_Site(1, 1) = mean(Element_Centroid(Stimulation_Site_Index_Values, 1));
            Stimulation_Site(1, 2) = mean(Element_Centroid(Stimulation_Site_Index_Values, 2));
            Stimulation_Site(1, 3) = mean(Element_Centroid(Stimulation_Site_Index_Values, 3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Determine Points on Surface with the Earliest Activation Time:

            Activation_Times(2, :) = 1:size(Activation_Times, 2);
            Activation_Times = sortrows(Activation_Times', 1);

            Heart_Surface_Index_Values = Activation_Times(1:Number_of_Surface_Points, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Take the Average of the Determined Points and Use as Heart Surface Points:

            Heart_Surface_Point(1, 1) = mean(Heart_Surface(Heart_Surface_Index_Values, 1));
            Heart_Surface_Point(1, 2) = mean(Heart_Surface(Heart_Surface_Index_Values, 2));
            Heart_Surface_Point(1, 3) = mean(Heart_Surface(Heart_Surface_Index_Values, 3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Rotate the Heart so that the Two Points Correspond to the Z-Axis:

            % Center the Sock around the Stimulation_Site:

                Centered_Element_Centroid = Element_Centroid - Stimulation_Site;
                Centered_Heart_Surface_Point = Heart_Surface_Point - Stimulation_Site;

            % Create a Vector to the Two Points:

                Cylinder_Vector = Centered_Heart_Surface_Point';
                Z_Axis_Vector = [0; 0; 1];

            % Rotate the Vector to be at the Z - Axis:

                Rotate_to_Z_Axis_Values = vrrotvec(Cylinder_Vector, Z_Axis_Vector);
                Rotation_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

                Rotated_Centered_Element_Centroid = Centered_Element_Centroid * Rotation_Matrix';
                Rotated_Centered_Heart_Surface_Point = Centered_Heart_Surface_Point * Rotation_Matrix';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Create Cylinder and Include Desired Points:

            % Cylinder Creation:

                Cylinder_Height = Rotated_Centered_Heart_Surface_Point(1, 3);

% %                 [Cylinder_X, Cylinder_Y, Cylinder_Z] = cylinder(Cylinder_Radius/2);
% % 
% %                 Cylinder_Z = Cylinder_Z * Cylinder_Height;
% % 
% %                 % Plot to Validate Results:
% %                 
% %                     figure(3);
% %                     
% %                         hold on;
% %                         
% %                             scatter3(Rotated_Centered_Element_Centroid(Stimulation_Site_Index_Values, 1), Rotated_Centered_Element_Centroid(Stimulation_Site_Index_Values, 2), Rotated_Centered_Element_Centroid(Stimulation_Site_Index_Values, 3), 'ok'); 
% %                             scatter3(0, 0, Rotated_Centered_Heart_Surface_Point(1, 3), 'ro'); 
% %                             surf(Cylinder_X, Cylinder_Y, Cylinder_Z)
% %                             
% %                             title('Cylinder Implemented');
% %                             
% %                         hold off;

            % Point Inclusion:

                Region_of_Interest = [(-Cylinder_Radius/2), (Cylinder_Radius/2), (-Cylinder_Radius/2), (Cylinder_Radius/2), 0, Cylinder_Height];

                Rotated_Centered_Element_Centroid_Point_Cloud = pointCloud(Rotated_Centered_Element_Centroid);

                Cylinder_Indicies = findPointsInROI(Rotated_Centered_Element_Centroid_Point_Cloud, Region_of_Interest);

% %                 Desired_Cylinder_Point_Cloud = select(Rotated_Centered_Element_Centroid_Point_Cloud, Cylinder_Indicies);
% % 
% %                 % Plot to Validate Results:
% %                 
% %                     figure(4);
% %                     
% %                         hold on;
% %                         
% %                             pcshow(Rotated_Centered_Element_Centroid_Point_Cloud.Location, [0.5, 0.5, 0.5]);
% %                             pcshow(Desired_Cylinder_Point_Cloud.Location, 'r');
% %                             
% %                             title('Selected Cylinder Points');
% %                             
% %                         hold off;

end