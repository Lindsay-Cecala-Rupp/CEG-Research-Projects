function [Imbrication_Angle, Fiber_Angle] = Calculate_Specific_Fiber_Angle(Element_Centroid, Cylinder_Indicies, Fiber_Orientation, Points, UVC_Coordinates, UVC_RHO, UVC_PHI, UVC_Z, Grid_Resolution, PHI_Range, Z_Range, RHO_Range, Long_Axis_Vector)

% Calculate the Angle for Each Fiber in the Cylinder:

    Imbrication_Angle = zeros(size(Cylinder_Indicies, 1), 1);
    Fiber_Angle = zeros(size(Cylinder_Indicies, 1), 1);

    for First_Index = 799%1:size(Cylinder_Indicies, 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Find the Center Point for the Fiber Point and Determine a Range of Values Along Side of It:

            Temporary_Anchor = Element_Centroid(Cylinder_Indicies(First_Index, 1), :);
            Temporary_Vector = Fiber_Orientation(Cylinder_Indicies(First_Index, 1), :);

% %             % Plot to Validate Results:
% % 
% %                 figure(1);
% % 
% %                     hold on;
% % 
% %                         quiver3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'k');
% %                         scatter3(Temporary_Tail(1), Temporary_Tail(2), Temporary_Tail(3), 'r');
% %                         scatter3(Temporary_Head(1), Temporary_Head(2), Temporary_Head(3), 'r');
% % 
% %                         title('Plot of the Current Vector of Interest');
% % 
% %                         xlabel('X-Axis');
% %                         ylabel('Y-Axis');
% %                         zlabel('Z-Axis');
% % 
% %                     hold off;

            % Find the UVC Coordinate the Cooresponds to the Centroid of the Desired Element:

                % Grab the Four Nodes that Make up the Desired Element:

                    Node_Distance_Calculation = sqrt((Temporary_Anchor(1) - Points(:, 1)).^2 + (Temporary_Anchor(2) - Points(:, 2)).^2 + (Temporary_Anchor(3) - Points(:, 3)).^2);
                    Node_Distance_Calculation(:, 2) = 1:size(Points, 1);

                    Node_Distance_Calculation = sortrows(Node_Distance_Calculation, 1);

                    Element_Nodes = Node_Distance_Calculation(1:4, 2);

                % Determine Cooresonding UVC Coordinate to the Four Nodes and Take the Average:

                    for Second_Index = 1:4

                        UVC_Coordiantes_of_Interest(Second_Index, :) = UVC_Coordinates(Element_Nodes(Second_Index), :);

                    end

                    UVC_Coordinate_of_Interest = [mean(UVC_Coordiantes_of_Interest(:, 1)), mean(UVC_Coordiantes_of_Interest(:, 2)), mean(UVC_Coordiantes_of_Interest(:, 3)), mean(UVC_Coordiantes_of_Interest(:, 4))];

            % Pull UVC Indicies who Fall within a Set Range of Phi and Z:

                Desired_Plane_Indicies_Storage_Vector = zeros(size(UVC_Coordinates, 1), 1);

                for Second_Index = 1:size(UVC_Coordinates, 1)

                    Temporary_RHO = UVC_RHO(Second_Index, 1);
                    Temporary_PHI = UVC_PHI(Second_Index, 1);
                    Temporary_Z = UVC_Z(Second_Index, 1);

                    if (Temporary_RHO < (UVC_Coordinate_of_Interest(2) + RHO_Range)) && (Temporary_RHO > (UVC_Coordinate_of_Interest(2) - RHO_Range))

                        if (Temporary_PHI < (UVC_Coordinate_of_Interest(3) + PHI_Range)) && (Temporary_PHI > (UVC_Coordinate_of_Interest(3) - PHI_Range))

                            if (Temporary_Z < (UVC_Coordinate_of_Interest(1) + Z_Range)) && (Temporary_Z > (UVC_Coordinate_of_Interest(1) - Z_Range))

                                Desired_Plane_Indicies_Storage_Vector(Second_Index, 1) = 1;

                            end

                        end

                    end

                end

                Desired_Plane_Indicies = find(Desired_Plane_Indicies_Storage_Vector == 1);

            % Put them Into Cartesian Space for Visualization:

                Plane_Points_of_Interest = Points(Desired_Plane_Indicies, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Fit a Plane to the Points of Interest for Angle Calculations:

            Surface_Fit = fit([Plane_Points_of_Interest(:, 1), Plane_Points_of_Interest(:, 2)], Plane_Points_of_Interest(:, 3), 'poly11', 'normalize', 'on');

            [Plane_X, Plane_Y] = meshgrid((min(Plane_Points_of_Interest(:, 1))  - 5):Grid_Resolution:(max(Plane_Points_of_Interest(:, 1)) + 5), (min(Plane_Points_of_Interest(:, 2)) - 5):Grid_Resolution:(max(Plane_Points_of_Interest(:, 2)) + 5));

            Plane_Z = Surface_Fit(Plane_X, Plane_Y);

            % Plot to Validate Results:

                % Determine Which Points Have the Desired RHO Value for Visualization Purposes:

                    for Second_Index = 1:size(UVC_RHO, 1)

                        Temporary_Value = UVC_RHO(Second_Index, 1);

                        Wanted_Value = UVC_Coordinate_of_Interest(2);

                        if Temporary_Value > (Wanted_Value - 0.05)

                            if Temporary_Value < (Wanted_Value + 0.05)

                                RHO_Check(Second_Index, 1) = 1;

                            else

                                RHO_Check(Second_Index, 1) = 0;

                            end

                        else

                            RHO_Check(Second_Index, 1) = 0;

                        end

                    end

                    Desired_RHO_Indicies = find(RHO_Check == 1);

                    Cartesian_RHO_Coordiantes = Points(Desired_RHO_Indicies, :);

% %                 % Plot All Necessary Results:
% % 
% %                     figure(2);
% % 
% %                         hold on;
% % 
% %                             surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% % 
% %                             pcshow(Cartesian_RHO_Coordiantes, 'w');
% % 
% %                             scatter3(Temporary_Anchor(1), Temporary_Anchor(2), Temporary_Anchor(3), '*b');
% % 
% %                             pcshow(Element_Centroid(Cylinder_Indicies, :), 'g');
% % 
% %                             pcshow(Heart_Surface, 'y');
% % 
% %                             zlabel('Z-Axis');
% %                             ylabel('Y-Axis');
% %                             xlabel('X-Axis');
% % 
% %                             legend('Fitted Plane', 'RHO Plane', 'Point of Interest', 'Fiber Box', 'Heart Surface');
% % 
% %                             title('Tangent Plane Fitted to the RHO Plane of Interest');
% % 
% %                         hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Determine Information About the Plane in Order to do Necessary Calculations:

            % Fiber Anchor's Location on the Calculated Plane:

                Fiber_Distance_to_Plane = zeros(size(Plane_X, 1), size(Plane_Z, 2));

                for Second_Index = 1:size(Plane_Z, 1)

                    for Third_Index = 1:size(Plane_Z, 2)

                        Fiber_Distance_to_Plane(Second_Index, Third_Index) = sqrt(((Temporary_Anchor(1) - Plane_X(Second_Index, Third_Index))^2) + ((Temporary_Anchor(2) - Plane_Y(Second_Index, Third_Index))^2) + ((Temporary_Anchor(3) - Plane_Z(Second_Index, Third_Index))^2));

                    end

                end

                Minimum_Fiber_Distance_to_Plane_Value = min(min(Fiber_Distance_to_Plane));

                Minimum_Fiber_Distance_to_Plane_Index = find(Fiber_Distance_to_Plane == Minimum_Fiber_Distance_to_Plane_Value);

                [Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index] = ind2sub(size(Fiber_Distance_to_Plane), Minimum_Fiber_Distance_to_Plane_Index);

                Anchor_Plane_Point = [Plane_X(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index), Plane_Y(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index), Plane_Z(Minimum_Fiber_Distance_to_Plane_Row_Index, Minimum_Fiber_Distance_to_Plane_Column_Index)];

            % Calcualte the Normal to the Plane:

                % Create Two Vectors on the Plane that have Anchors at the Fiber Anchor Plane Point:

                    % Plane Vector One:

                        Plane_Vector_One_Point = [Plane_X(1, 1), Plane_Y(1, 1), Plane_Z(1, 1)];
                        Plane_Vector_One = Anchor_Plane_Point - Plane_Vector_One_Point;
                        Plane_Vector_One_Unit = Plane_Vector_One/(sqrt(Plane_Vector_One(1)^2 + Plane_Vector_One(2)^2 + Plane_Vector_One(3)^2));

                    % Plane Vector Two:

                        Plane_Vector_Two_Point = [Plane_X(1, end), Plane_Y(1, end), Plane_Z(1, end)];
                        Plane_Vector_Two = Anchor_Plane_Point - Plane_Vector_Two_Point;
                        Plane_Vector_Two_Unit = Plane_Vector_Two/(sqrt(Plane_Vector_Two(1)^2 + Plane_Vector_Two(2)^2 + Plane_Vector_Two(3)^2));

                % Calculate the Normal from the Two Vectors:

                    Plane_Normal = cross(Plane_Vector_One_Unit, Plane_Vector_Two_Unit);
                    Plane_Normal_Unit = Plane_Normal/(sqrt(Plane_Normal(1)^2 + Plane_Normal(2)^2 + Plane_Normal(3)^3));

                    % Determine the Direction of the Normal Vector - Need it to be Pointing Towards the Surface of the Heart:

                        % Create Two New UVC Points - One Positive Ten Points Away and One Negative Ten Points Away:
                        
                            Positive_Plane_Normal_Point_Cartesian = Anchor_Plane_Point + (10 * Plane_Normal_Unit);
                            
                                Positive_Plane_Normal_Point_Index = dsearchn(Points, Positive_Plane_Normal_Point_Cartesian);
                                
                                Positive_Plane_Normal_Point_UVC = UVC_Coordinates(Positive_Plane_Normal_Point_Index, :);
                            
                            Negative_Plane_Normal_Point_Cartesian = Anchor_Plane_Point - (10 * Plane_Normal_Unit);
                            
                                Negative_Plane_Normal_Point_Index = dsearchn(Points, Negative_Plane_Normal_Point_Cartesian);
                                
                                Negative_Plane_Normal_Point_UVC = UVC_Coordinates(Negative_Plane_Normal_Point_Index, :);

                        % Determine which One Has the Larger RHO Value - Larger Value is Closer to the Surface of the Heart:

                            if Negative_Plane_Normal_Point_UVC(2) > Positive_Plane_Normal_Point_UVC(2)

                                Plane_Normal_Unit = -1 * Plane_Normal_Unit;

                            elseif Negative_Plane_Normal_Point_UVC(2) < Positive_Plane_Normal_Point_UVC(2)

                                Plane_Normal_Unit = 1 * Plane_Normal_Unit;

                            end

% %                             % Plot to Validate the Results:
% % 
% %                                 figure(3);
% % 
% %                                     hold on;
% % 
% %                                         surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% % 
% %                                         scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*g');
% % 
% %                                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_One_Unit(1), Plane_Vector_One_Unit(2), Plane_Vector_One_Unit(3), 'b');
% % 
% %                                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_Two_Unit(1), Plane_Vector_Two_Unit(2), Plane_Vector_Two_Unit(3), 'b');
% % 
% %                                         quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'b');
% % 
% %                                         pcshow(Heart_Surface, 'y');
% % 
% %                                         title('Fitted Plane with Desired Components');
% % 
% %                                         xlabel('X-Axis');
% %                                         ylabel('Y-Axis');
% %                                         zlabel('Z-Axis');
% % 
% %                                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Determine the Fiber Orientation Angle - Imbrication and Plane Angle:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Imbrication Angle: 

                % Calcualte the Angle Between the Normal and the Fiber Vector:

                    Temporary_Imbrication_Angle = atan2d(norm(cross(Temporary_Vector, Plane_Normal_Unit)),dot(Temporary_Vector, Plane_Normal_Unit));

                    % Determine the Correct Orientation for the Angle with Respect to a RHO Plane and Epicardium:

                        if Temporary_Imbrication_Angle > 90

                            Imbrication_Angle(First_Index, 1) = -1 * (90 - Temporary_Imbrication_Angle);

                        elseif Temporary_Imbrication_Angle < 90

                            Imbrication_Angle(First_Index, 1) = 90 - Temporary_Imbrication_Angle;

                        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

             % Fiber Angle:

                % Project Fiber onto the Plane - Remove Imbrication Component:

                    Fiber_Projection_with_Normal = (dot(Temporary_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                    Projected_Fiber_Vector = Temporary_Vector - Fiber_Projection_with_Normal;

                % Project Long-Axis Vector to Preform Angle Calculation in Plane:
                
                    Long_Axis_Vector = [Long_Axis_Vector(1), Long_Axis_Vector(2), Long_Axis_Vector(3)];
                    
                    Long_Axis_Vector = Long_Axis_Vector / norm(Long_Axis_Vector);

                    Long_Axis_Projection_with_Normal = (dot(Long_Axis_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                    Projected_Long_Axis_Unit_Vector = Long_Axis_Vector - Long_Axis_Projection_with_Normal;

                % Calculate a Vector Perpendicular to the Projected Z Unit Vector:

                    Horizontal_Plane_Vector_Option_One = cross(Projected_Long_Axis_Unit_Vector, Plane_Normal_Unit);
                    Horizontal_Plane_Vector_Option_Two = -1 * Horizontal_Plane_Vector_Option_One;

                    % Determien Orientation of the Horizontal by Choosing Component that Follows the "Right Hand Rule":

                        Cross_Product_Option_One = cross(Horizontal_Plane_Vector_Option_One, Projected_Long_Axis_Unit_Vector);
                        Cross_Product_Option_Two = cross(Horizontal_Plane_Vector_Option_Two, Projected_Long_Axis_Unit_Vector);

                        % Determine which Resulting Vector Points in the Same Direction as the Normal:

                            Plane_Normal_Unit_Sign = sign(Plane_Normal_Unit);

                            Cross_Product_Option_One_Sign = sign(Cross_Product_Option_One);
                            Cross_Product_Option_Two_Sign = sign(Cross_Product_Option_Two);

                            Cross_Product_Option_One_Sign_Summation = sum(Cross_Product_Option_One_Sign - Plane_Normal_Unit_Sign);
                            Cross_Product_Option_Two_Sign_Summation = sum(Cross_Product_Option_Two_Sign - Plane_Normal_Unit_Sign);

                            if (Cross_Product_Option_One_Sign_Summation == 0) && (Cross_Product_Option_Two_Sign_Summation ~= 0)

                                Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_One;

                            elseif (Cross_Product_Option_One_Sign_Summation ~= 0) && (Cross_Product_Option_Two_Sign_Summation == 0)

                                Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_Two;

                            elseif (Cross_Product_Option_One_Sign_Summation ~= 0) && (Cross_Product_Option_Two_Sign_Summation ~= 0)

                                 Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_One;

                            end

                % Determine which Quadrant the Vector is in with Respect to the Two Defined Z and X Vectors and Calculate the Angle:

                    Z_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Projected_Long_Axis_Unit_Vector)),dot(Projected_Fiber_Vector, Projected_Long_Axis_Unit_Vector)));
                    X_Positive_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Horizontal_Plane_Vector)),dot(Projected_Fiber_Vector, Horizontal_Plane_Vector)));
                    X_Negative_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, (-1*Horizontal_Plane_Vector))),dot(Projected_Fiber_Vector, (-1 * Horizontal_Plane_Vector))));

                    if (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value < 90)

                        Quadrant_Location = 1;

                        %Fiber_Angle(First_Index, 1) = X_Positive_Vector_Angle_Value;
                        
                        Fiber_Angle(First_Index, 1) = abs(X_Positive_Vector_Angle_Value);

                    elseif (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value > 90)

                        Quadrant_Location = 2;

                        %Fiber_Angle(First_Index, 1) = -1 * X_Negative_Vector_Angle_Value;
                        
                        Fiber_Angle(First_Index, 1) = -1 * abs(X_Negative_Vector_Angle_Value);

                    elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value < 90)

                        Quadrant_Location = 3;

                        %Fiber_Angle(First_Index, 1) = -1 * X_Positive_Vector_Angle_Value;
                        
                        Fiber_Angle(First_Index, 1) = -1 * abs(X_Positive_Vector_Angle_Value);

                    elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value > 90)

                        Quadrant_Location = 4;

                        %Fiber_Angle(First_Index, 1) = X_Negative_Vector_Angle_Value;
                        
                        Fiber_Angle(First_Index, 1) = abs(X_Negative_Vector_Angle_Value);

                    end

% %                     % Plot to Validate the Results:
% % 
% %                         figure(10);
% % 
% %                             hold on;
% % 
% %                                 pcshow(Anchor_Plane_Point, 'k');
% % 
% %                                 surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'y');
% % 
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Z_Unit_Vector(1), Projected_Z_Unit_Vector(2), Projected_Z_Unit_Vector(3), 'r');
% % 
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Fiber_Vector(1), Projected_Fiber_Vector(2), Projected_Fiber_Vector(3), 'b');
% % 
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Horizontal_Plane_Vector(1), Horizontal_Plane_Vector(2), Horizontal_Plane_Vector(3), 'g');
% % 
% %                             hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %         % Plot to Validate the Results:
% % 
% %             figure(5);
% % 
% %                 hold on;
% % 
% %                     surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'y');
% % 
% %                     scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*b');
% % 
% %                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Temporary_Vector(1), Temporary_Vector(2), Temporary_Vector(3), 'r');
% % 
% %                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Fiber_Vector(1), Projected_Fiber_Vector(2), Projected_Fiber_Vector(3), 'b');
% % 
% %                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Z_Unit_Vector(1), Projected_Z_Unit_Vector(2), Projected_Z_Unit_Vector(3), 'g');
% % 
% %                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'm');
% % 
% %                     quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Horizontal_Plane_Vector(1), Horizontal_Plane_Vector(2), Horizontal_Plane_Vector(3), 'c');
% % 
% %                     legend('Fitted Plane', 'Point of Interest', 'Original Fiber Vector', 'Projected Fiber Vector', 'Projected Unit Z', 'Plane Normal', 'Projected Horizontal');
% % 
% %                     xlabel('X-Axis');
% %                     ylabel('Y-Axis');
% %                     zlabel('Z-Axis');
% % 
% %                 hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    
end