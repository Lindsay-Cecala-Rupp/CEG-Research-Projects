function [Ellipse_Information] = Calculate_Ellipse_Parameters_Function_V1(Ellipse_Structure, Horizontal_Line, Vertical_Line)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Calculate the Area of the Ellipse:

        Long_Axis_Radius = Ellipse_Structure.long_axis / 2;
        Short_Axis_Radius = Ellipse_Structure.short_axis / 2;

        Ellipse_Information.Area = pi * Long_Axis_Radius * Short_Axis_Radius;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine the Aspect Ratio between the Major Axis and Minor Axis:

        Ellipse_Information.Axis_Ratio = (Ellipse_Structure.short_axis) / (Ellipse_Structure.long_axis);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Determine Angle of the Long and Short Axis of the Ellipse:

        Length_of_Vertical_Line = sqrt(((Vertical_Line(1, 1) - Vertical_Line(1, 2)) ^ 2) + ((Vertical_Line(2, 1) - Vertical_Line(2, 2)) ^ 2));
        Length_of_Horizontal_Line = sqrt(((Horizontal_Line(1, 1) - Horizontal_Line(1, 2)) ^ 2) + ((Horizontal_Line(2,1)  - Horizontal_Line(2, 2)) ^ 2));
        Length_Vector = [Length_of_Vertical_Line Length_of_Horizontal_Line];
        [~, Maximum_Length_Location] = max(Length_Vector);
        [~, Minimum_Length_Location] = min(Length_Vector);

        % Long Axis:

            if Maximum_Length_Location == 1

                Slope_Long_Axis = (Vertical_Line(2, 2) - Vertical_Line(2, 1)) / (Vertical_Line(1, 2) - Vertical_Line(1, 1));

                % Plot Line Going from End Point on Fitted Line:

                    [Minimum_Y_Value_Long_Axis, ~] = min(Vertical_Line(2, :));
                    [Maximum_Y_Value_Long_Axis, ~] = max(Vertical_Line(2, :));
                    [Minimum_X_Value_Long_Axis, ~] = min(Vertical_Line(1, :));
                    [Maximum_X_Value_Long_Axis, Maximum_X_Location_Long_Axis] = max(Vertical_Line(1, :));

                    Correlating_Y_Value_to_Maximum_X_Long_Axis = Vertical_Line(2, Maximum_X_Location_Long_Axis);

                % Create Vectors Corresponding to Lines:

                    if Slope_Long_Axis < 0

                        Vector_One_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Correlating_Y_Value_to_Maximum_X_Long_Axis - Correlating_Y_Value_to_Maximum_X_Long_Axis), 0];
                        Vector_Two_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Maximum_Y_Value_Long_Axis - Minimum_Y_Value_Long_Axis), 0];

                        Ellipse_Information.Angle_for_Long_Axis = atan2d(norm(cross(Vector_One_Long_Axis, Vector_Two_Long_Axis)), dot(Vector_One_Long_Axis, Vector_Two_Long_Axis));
                            Ellipse_Information.Angle_for_Long_Axis = 180 - abs(Ellipse_Information.Angle_for_Long_Axis);
                        
                    elseif Slope_Long_Axis > 0

                        Vector_One_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Correlating_Y_Value_to_Maximum_X_Long_Axis - Correlating_Y_Value_to_Maximum_X_Long_Axis), 0];
                        Vector_Two_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Minimum_Y_Value_Long_Axis - Maximum_Y_Value_Long_Axis), 0];

                        Ellipse_Information.Angle_for_Long_Axis = atan2d(norm(cross(Vector_One_Long_Axis, Vector_Two_Long_Axis)), dot(Vector_One_Long_Axis, Vector_Two_Long_Axis));
                        
                    elseif Slope_Long_Axis == 0
                        
                        Ellipse_Information.Angle_for_Long_Axis = 0;
                        
                    end

% %                 % Plot the Results to Validate:
% % 
% %                     figure(1)
% % 
% %                         hold on;
% % 
% %                             plot([Minimum_X_Value_Long_Axis, Maximum_X_Value_Long_Axis], [Correlating_Y_Value_to_Maximum_X_Long_Axis, Correlating_Y_Value_to_Maximum_X_Long_Axis], 'b', 'LineWidth', 3);
% %                             plot(Vertical_Line(1,:), Vertical_Line(2,:), 'r' , 'LineWidth', 3);
% % 
% %                             quiver(Maximum_X_Value_Long_Axis, Correlating_Y_Value_to_Maximum_X_Long_Axis, Vector_One_Long_Axis(1, 1), Vector_One_Long_Axis(1, 2), 'k');
% %                             quiver(Maximum_X_Value_Long_Axis, Correlating_Y_Value_to_Maximum_X_Long_Axis, Vector_Two_Long_Axis(1, 1), Vector_Two_Long_Axis(1, 2), 'k');
% % 
% %                             xlabel('Horizontal Axis');
% %                             ylabel('Vertical Axis');
% %                             title('Long Axis Visual');
% % 
% %                         hold off;

            elseif Maximum_Length_Location == 2

                Slope_Long_Axis = (Horizontal_Line(2, 2) - Horizontal_Line(2, 1)) / (Horizontal_Line(1, 2) - Horizontal_Line(1, 1));

                % Plot Line Going from End Point on Fitted Line:

                    [Minimum_Y_Value_Long_Axis, ~] = min(Horizontal_Line(2, :));
                    [Maximum_Y_Value_Long_Axis, ~] = max(Horizontal_Line(2, :));
                    [Minimum_X_Value_Long_Axis, ~] = min(Horizontal_Line(1, :));
                    [Maximum_X_Value_Long_Axis, Maximum_X_Location_Long_Axis] = max(Horizontal_Line(1, :));

                    Correlating_Y_Value_to_Maximum_X_Long_Axis = Horizontal_Line(2, Maximum_X_Location_Long_Axis);

                % Create Vectors Corresponding to Lines:

                    if Slope_Long_Axis < 0

                        Vector_One_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Correlating_Y_Value_to_Maximum_X_Long_Axis - Correlating_Y_Value_to_Maximum_X_Long_Axis), 0];
                        Vector_Two_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Maximum_Y_Value_Long_Axis - Minimum_Y_Value_Long_Axis), 0];

                        Ellipse_Information.Angle_for_Long_Axis = atan2d(norm(cross(Vector_One_Long_Axis, Vector_Two_Long_Axis)), dot(Vector_One_Long_Axis, Vector_Two_Long_Axis));
                            Ellipse_Information.Angle_for_Long_Axis = 180 - abs(Ellipse_Information.Angle_for_Long_Axis); 
                        
                    elseif Slope_Long_Axis > 0

                        Vector_One_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Correlating_Y_Value_to_Maximum_X_Long_Axis - Correlating_Y_Value_to_Maximum_X_Long_Axis), 0];
                        Vector_Two_Long_Axis = [(Minimum_X_Value_Long_Axis - Maximum_X_Value_Long_Axis), (Minimum_Y_Value_Long_Axis - Maximum_Y_Value_Long_Axis), 0];

                        Ellipse_Information.Angle_for_Long_Axis = atan2d(norm(cross(Vector_One_Long_Axis, Vector_Two_Long_Axis)), dot(Vector_One_Long_Axis, Vector_Two_Long_Axis));
                        
                    elseif Slope_Long_Axis == 0
                        
                        Ellipse_Information.Angle_for_Long_Axis = 0;
                        
                    end


% %                 % Plot the Results to Validate:
% % 
% %                     figure(1)
% % 
% %                         hold on;
% % 
% %                             plot([Minimum_X_Value_Long_Axis, Maximum_X_Value_Long_Axis], [Correlating_Y_Value_to_Maximum_X_Long_Axis, Correlating_Y_Value_to_Maximum_X_Long_Axis], 'b', 'LineWidth', 3);
% %                             plot(Horizontal_Line(1,:), Horizontal_Line(2,:), 'r' , 'LineWidth', 3);
% % 
% %                             quiver(Maximum_X_Value_Long_Axis, Correlating_Y_Value_to_Maximum_X_Long_Axis, Vector_One_Long_Axis(1, 1), Vector_One_Long_Axis(1, 2), 'k');
% %                             quiver(Maximum_X_Value_Long_Axis, Correlating_Y_Value_to_Maximum_X_Long_Axis, Vector_Two_Long_Axis(1, 1), Vector_Two_Long_Axis(1, 2), 'k');
% % 
% %                             xlabel('Horizontal Axis');
% %                             ylabel('Vertical Axis');
% %                             title('Long Axis Visual');
% % 
% %                         hold off;

            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Short Axis:

            if Minimum_Length_Location == 1

                Slope_Short_Axis = (Vertical_Line(2, 2) - Vertical_Line(2, 1)) / (Vertical_Line(1, 2) - Vertical_Line(1, 1));

                % Plot Line Going from End Point on Fitted Line:

                    [Minimum_Y_Value_Short_Axis, Minimum_Y_Location_Short_Axis] = min(Vertical_Line(2, :));
                    [Maximum_Y_Value_Short_Axis, ~] = max(Vertical_Line(2, :));
                    [Minimum_X_Value_Short_Axis, ~] = min(Vertical_Line(1, :));
                    [Maximum_X_Value_Short_Axis, ~] = max(Vertical_Line(1, :));

                    Correlating_X_Value_to_Minimum_Y_Short_Axis = Vertical_Line(1, Minimum_Y_Location_Short_Axis);

                % Create Vectors Corresponding to Lines:

                    if Slope_Short_Axis < 0

                        Vector_One_Short_Axis = [(Correlating_X_Value_to_Minimum_Y_Short_Axis - Correlating_X_Value_to_Minimum_Y_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];
                        Vector_Two_Short_Axis = [(Minimum_X_Value_Short_Axis - Maximum_X_Value_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];

                        Ellipse_Information.Angle_for_Short_Axis = atan2d(norm(cross(Vector_One_Short_Axis, Vector_Two_Short_Axis)), dot(Vector_One_Short_Axis, Vector_Two_Short_Axis));
                        
                    elseif Slope_Short_Axis > 0

                        Vector_One_Short_Axis = [(Correlating_X_Value_to_Minimum_Y_Short_Axis - Correlating_X_Value_to_Minimum_Y_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];
                        Vector_Two_Short_Axis = [(Maximum_X_Value_Short_Axis - Minimum_X_Value_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];

                        Ellipse_Information.Angle_for_Short_Axis = atan2d(norm(cross(Vector_One_Short_Axis, Vector_Two_Short_Axis)), dot(Vector_One_Short_Axis, Vector_Two_Short_Axis));
                            Ellipse_Information.Angle_for_Short_Axis = 180 - abs(Ellipse_Information.Angle_for_Short_Axis);
                         
                    elseif Slope_Short_Axis == 0
                        
                        Ellipse_Information.Angle_for_Short_Axis = 0;
                        
                    end


% %                 % Plot the Results to Validate:
% % 
% %                     figure(2)
% % 
% %                         hold on;
% % 
% %                             plot([Correlating_X_Value_to_Minimum_Y_Short_Axis, Correlating_X_Value_to_Minimum_Y_Short_Axis], [Minimum_Y_Value_Short_Axis, Maximum_Y_Value_Short_Axis], 'b', 'LineWidth', 3);
% %                             plot(Vertical_Line(1,:), Vertical_Line(2,:),'r' , 'LineWidth', 3);
% % 
% %                             quiver(Correlating_X_Value_to_Minimum_Y_Short_Axis, Minimum_Y_Value_Short_Axis, Vector_One_Short_Axis(1, 1), Vector_One_Short_Axis(1, 2), 'k');
% %                             quiver(Correlating_X_Value_to_Minimum_Y_Short_Axis, Minimum_Y_Value_Short_Axis, Vector_Two_Short_Axis(1, 1), Vector_Two_Short_Axis(1, 2), 'k');
% % 
% %                             xlabel('Horizontal Axis');
% %                             ylabel('Vertical Axis');
% %                             title('Short Axis Visual');
% % 
% %                         hold off;

            elseif Minimum_Length_Location == 2

                Slope_Short_Axis = (Horizontal_Line(2, 2) - Horizontal_Line(2, 1)) / (Horizontal_Line(1, 2) - Horizontal_Line(1, 1));

                % Plot Line Going from End Point on Fitted Line:

                    [Minimum_Y_Value_Short_Axis, Minimum_Y_Location_Short_Axis] = min(Horizontal_Line(2, :));
                    [Maximum_Y_Value_Short_Axis, ~] = max(Horizontal_Line(2, :));
                    [Minimum_X_Value_Short_Axis, ~] = min(Horizontal_Line(1, :));
                    [Maximum_X_Value_Short_Axis, ~] = max(Horizontal_Line(1, :));

                    Correlating_X_Value_to_Minimum_Y_Short_Axis = Horizontal_Line(1, Minimum_Y_Location_Short_Axis);

                % Create Vectors Corresponding to Lines:

                    if Slope_Short_Axis < 0

                        Vector_One_Short_Axis = [(Correlating_X_Value_to_Minimum_Y_Short_Axis - Correlating_X_Value_to_Minimum_Y_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];
                        Vector_Two_Short_Axis = [(Minimum_X_Value_Short_Axis - Maximum_X_Value_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];

                        Ellipse_Information.Angle_for_Short_Axis = atan2d(norm(cross(Vector_One_Short_Axis, Vector_Two_Short_Axis)), dot(Vector_One_Short_Axis, Vector_Two_Short_Axis));
                        
                    elseif Slope_Short_Axis > 0

                        Vector_One_Short_Axis = [(Correlating_X_Value_to_Minimum_Y_Short_Axis - Correlating_X_Value_to_Minimum_Y_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];
                        Vector_Two_Short_Axis = [(Maximum_X_Value_Short_Axis - Minimum_X_Value_Short_Axis), (Maximum_Y_Value_Short_Axis - Minimum_Y_Value_Short_Axis), 0];

                        Ellipse_Information.Angle_for_Short_Axis = atan2d(norm(cross(Vector_One_Short_Axis, Vector_Two_Short_Axis)), dot(Vector_One_Short_Axis, Vector_Two_Short_Axis));
                            Ellipse_Information.Angle_for_Short_Axis = 180 - abs(Ellipse_Information.Angle_for_Short_Axis);
 
                    elseif Slope_Short_Axis == 0
                        
                        Ellipse_Information.Angle_for_Short_Axis = 0;
                        
                    end

% %                 % Plot the Results to Validate:
% % 
% %                     figure(2)
% % 
% %                         hold on;
% % 
% %                             plot([Correlating_X_Value_to_Minimum_Y_Short_Axis, Correlating_X_Value_to_Minimum_Y_Short_Axis], [Minimum_Y_Value_Short_Axis, Maximum_Y_Value_Short_Axis], 'b', 'LineWidth', 3);
% %                             plot( Horizontal_Line(1,:),Horizontal_Line(2,:),'r' , 'LineWidth', 3);
% % 
% %                             quiver(Correlating_X_Value_to_Minimum_Y_Short_Axis, Minimum_Y_Value_Short_Axis, Vector_One_Short_Axis(1, 1), Vector_One_Short_Axis(1, 2), 'k');
% %                             quiver(Correlating_X_Value_to_Minimum_Y_Short_Axis, Minimum_Y_Value_Short_Axis, Vector_Two_Short_Axis(1, 1), Vector_Two_Short_Axis(1, 2), 'k');
% % 
% %                             xlabel('Horizontal Axis');
% %                             ylabel('Vertical Axis');
% %                             title('Short Axis Visual');
% % 
% %                         hold off;

            end


end