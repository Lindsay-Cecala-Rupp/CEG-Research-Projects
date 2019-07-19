
% Script to Fit an Ellipse to the Breakthrough Site Points:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in Relevant Variables:

    % Load in Data:
    
        Ellipse_Structure = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Other-Script-Data-for-Intermediate-Steps/Ellipse_Structure_12.mat');
            Ellipse_Structure = Ellipse_Structure.Ellipse_Structure;
            
        Horizontal_Line = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Other-Script-Data-for-Intermediate-Steps/Horizontal_Line_12.mat');
            Horizontal_Line = Horizontal_Line.Horizontal_Line;
        
        Vertical_Line = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Stimulated-Version/Other-Script-Data-for-Intermediate-Steps/Vertical_Line_12.mat');
            Vertical_Line = Vertical_Line.Vertical_Line;

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

    % Determine which Axis is Larger:

        Length_of_Vertical_Line = sqrt(((Vertical_Line(1, 1) - Vertical_Line(1, 2)) ^ 2) + ((Vertical_Line(2, 1) - Vertical_Line(2, 2)) ^ 2));
        Length_of_Horizontal_Line = sqrt(((Horizontal_Line(1, 1) - Horizontal_Line(1, 2)) ^ 2) + ((Horizontal_Line(2,1)  - Horizontal_Line(2, 2)) ^ 2));
        Length_Vector = [Length_of_Vertical_Line Length_of_Horizontal_Line];
        [Maximum_Length, Maximum_Length_Location] = max(Length_Vector);
        [Minimum_Length, Minimum_Length_Location] = min(Length_Vector);
    
    % Center the Ellipse at the Origin:
    
        Ellipse_Centroid = [Ellipse_Structure.X0_in; Ellipse_Structure.Y0_in];
    
        Centered_Vertical_Line = Vertical_Line - Ellipse_Centroid;
        Centered_Horizontal_Line = Horizontal_Line - Ellipse_Centroid;
        
    % Pick the Coordinates with a Positive Y-Value for Long Axis Calculation:
    
        Positive_Y_Vertical_Line_Coordinate = find(Centered_Vertical_Line(2, :) > 0);
        Positive_Y_Horizontal_Line_Coordinate = find(Centered_Horizontal_Line(2, :) > 0);
        
    % Pick the Coordinates with a Positive X-Value for Short Axis Calculation:
    
        Positive_X_Vertical_Line_Coordinate = find(Centered_Vertical_Line(1, :) > 0);
        Positive_X_Horizontal_Line_Coordinate = find(Centered_Horizontal_Line(1, :) > 0);
        
        % Plot to Validate Results:
            
            figure(1);
            
                hold on;
                
                    plot(Centered_Vertical_Line(1, :), Centered_Vertical_Line(2, :), 'k');
                    plot(Centered_Horizontal_Line(1, :), Centered_Horizontal_Line(2, :), 'k');
                    
                    xlabel('X-Axis');
                    ylabel('Y-Axis');
                    
                    title('Centered Ellipse Axis System');
                    
                hold off;
                    
    % Long Axis:

        if Maximum_Length_Location == 1
            
            Long_Axis_Point_of_Interest = Centered_Vertical_Line(:, Positive_Y_Vertical_Line_Coordinate);
                Long_Axis_Point_of_Interest = [Long_Axis_Point_of_Interest; 0];
            
            Long_Axis_Comparison_Vector = [1; 0; 0];
            
            Ellipse_Information.Angle_for_Long_Axis = atan2d(norm(cross(Long_Axis_Point_of_Interest, Long_Axis_Comparison_Vector)), dot(Long_Axis_Point_of_Interest, Long_Axis_Comparison_Vector));

                % Plot Results to Validate:
                
                    figure(2)
                    
                        hold on;
                        
                            quiver(0, 0, Long_Axis_Point_of_Interest(1, 1), Long_Axis_Point_of_Interest(2, 1), 'r');
                            quiver(0, 0, Long_Axis_Comparison_Vector(1, 1), Long_Axis_Comparison_Vector(2, 1), 'b')
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            
                            title('Long Axis Angle');
                            
                        hold off;

        elseif Maximum_Length_Location == 2
            
            Long_Axis_Point_of_Interest = Centered_Horizontal_Line(:, Positive_Y_Horizontal_Line_Coordinate);
                Long_Axis_Point_of_Interest = [Long_Axis_Point_of_Interest; 0];
            
            Long_Axis_Comparison_Vector = [1; 0; 0];
            
            Ellipse_Information.Angle_for_Long_Axis = atan2d(norm(cross(Long_Axis_Point_of_Interest, Long_Axis_Comparison_Vector)), dot(Long_Axis_Point_of_Interest, Long_Axis_Comparison_Vector));

                % Plot Results to Validate:
                
                    figure(2)
                    
                        hold on;
                        
                            quiver(0, 0, Long_Axis_Point_of_Interest(1, 1), Long_Axis_Point_of_Interest(2, 1), 'r');
                            quiver(0, 0, Long_Axis_Comparison_Vector(1, 1), Long_Axis_Comparison_Vector(2, 1), 'b')
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            
                            title('Long Axis Angle');
                            
                        hold off;

        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Short Axis:

        if Minimum_Length_Location == 1
            
            Short_Axis_Point_of_Interest = Centered_Vertical_Line(:, Positive_X_Vertical_Line_Coordinate);
                Short_Axis_Point_of_Interest = [Short_Axis_Point_of_Interest; 0];
            
            Short_Axis_Comparison_Vector = [0; 1; 0];
            
            Ellipse_Information.Angle_for_Short_Axis = atan2d(norm(cross(Short_Axis_Point_of_Interest, Short_Axis_Comparison_Vector)), dot(Short_Axis_Point_of_Interest, Short_Axis_Comparison_Vector));

                % Plot Results to Validate:
                
                    figure(3)
                    
                        hold on;
                        
                            quiver(0, 0, Short_Axis_Point_of_Interest(1, 1), Short_Axis_Point_of_Interest(2, 1), 'r');
                            quiver(0, 0, Short_Axis_Comparison_Vector(1, 1), Short_Axis_Comparison_Vector(2, 1), 'b')
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            
                            title('Short Axis Angle');
                            
                        hold off;
            
        elseif Minimum_Length_Location == 2
            
            Short_Axis_Point_of_Interest = Centered_Horizontal_Line(:, Positive_X_Horizontal_Line_Coordinate);
                Short_Axis_Point_of_Interest = [Short_Axis_Point_of_Interest; 0];
            
            Short_Axis_Comparison_Vector = [0; 1; 0];
            
            Ellipse_Information.Angle_for_Short_Axis = atan2d(norm(cross(Short_Axis_Point_of_Interest, Short_Axis_Comparison_Vector)), dot(Short_Axis_Point_of_Interest, Short_Axis_Comparison_Vector));

                % Plot Results to Validate:
                
                    figure(3)
                    
                        hold on;
                        
                            quiver(0, 0, Short_Axis_Point_of_Interest(1, 1), Short_Axis_Point_of_Interest(2, 1), 'r');
                            quiver(0, 0, Short_Axis_Comparison_Vector(1, 1), Short_Axis_Comparison_Vector(2, 1), 'b')
                            
                            xlabel('X-Axis');
                            ylabel('Y-Axis');
                            
                            title('Short Axis Angle');
                            
                        hold off;

        end