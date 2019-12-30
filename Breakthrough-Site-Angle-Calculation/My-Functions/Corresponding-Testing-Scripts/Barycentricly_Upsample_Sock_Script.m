
% Script to Up Sample the Sock Using Barycentric Coordinates:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in Relevant Variables:

    Grid_Resolution = 0.2;
    
% Load in Data:

    Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
        Points = Geometry.outSock.pts; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
        Faces = Geometry.outSock.fac; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!

% %     Geometry = load('/Users/lindsayrupp/Documents/CEG Research/Breakthrough Site Angle Calculation/Stimulated Version/Data/CARP_Sock_Biomesh_Space.mat');
% %         Points = Geometry.scirunfield.node;
% %         Faces = Geometry.scirunfield.face;

    Activation = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Experimental-Version/Laplacian-Interpolate/Other-Script-Data-for-Intermediate-Steps/Interpolated_Activation_Times_Run44_Beat1.mat');
        Activation_Times = Activation.Interpolated_Activation_Times;

% %     Activation = load('/Users/lindsayrupp/Documents/CEG Research/Breakthrough Site Angle Calculation/Stimulated Version/Data/act_needle_910.txt');
% %         Activation_Times = Activation(:, 1)';
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go Through all the Faces and Up Sample:

    for First_Index = 1:size(Faces, 2)

        Temporary_Face_Point_Location = Faces(:, First_Index);
        Temporary_Face_Points = Points(:, Temporary_Face_Point_Location);

        % Create a "Local" Plane from the Triangle Points:

            Local_Origin_Point = Temporary_Face_Points(:, 1);
            Local_Horizontal_Point = Temporary_Face_Points(:, 2);
            Local_Point_for_Normal = Temporary_Face_Points(:, 3);
            
            % Determine the Magnitude of the "Local" Axes:
            
                Local_Horizontal_Magnitude = norm((Local_Origin_Point - Local_Horizontal_Point));
                Local_Point_for_Normal_Magnitude = norm((Local_Point_for_Normal - Local_Origin_Point));

            % Create Unit Vectors Along the "Local" Axes:
                
                Local_Horizontal_Unit_Vector = ((Local_Horizontal_Point - Local_Origin_Point)) / norm((Local_Horizontal_Point - Local_Origin_Point));
                Local_Point_for_Normal_Unit_Vector = ((Local_Point_for_Normal) - Local_Origin_Point) / norm((Local_Point_for_Normal - Local_Origin_Point));

            %  Create a Normal Vector from the "Original" Triangle Plane:

                Triangle_Normal = cross(Local_Horizontal_Unit_Vector, Local_Point_for_Normal_Unit_Vector);

            % Determine the Location of the Triangle X Point in the "Local" Plane we Created:

                Local_Triangle_X_Point = Local_Horizontal_Unit_Vector * Local_Horizontal_Magnitude;

                % Plot to Validate Results:
                
%                     figure(1);
%                     
%                         hold on;
%                         
%                             plot3(Temporary_Face_Points(1, :), Temporary_Face_Points(2, :), Temporary_Face_Points(3, :), 'ro');
%                             quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Local_Horizontal_Unit_Vector(1), Local_Horizontal_Unit_Vector(2), Local_Horizontal_Unit_Vector(3));
%                             quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Local_Point_for_Normal_Unit_Vector(1), Local_Point_for_Normal_Unit_Vector(2), Local_Point_for_Normal_Unit_Vector(3));
%                             quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Triangle_Normal(1), Triangle_Normal(2), Triangle_Normal(3));
%                             
%                         hold off;


            % Determine Which Direction the Normal Vector Should Point:
            
                % Determine the Two Possible Directions for the Vectors:
                
                    Normal_Rotation_Degrees = 90;
                    Normal_Rotation_Radians = (pi/180) * Normal_Rotation_Degrees;

                    Normal_Direction_One = makehgtform('axisrotate',Triangle_Normal,Normal_Rotation_Radians) ;
                    Normal_Direction_Two = makehgtform('axisrotate',Triangle_Normal,-Normal_Rotation_Radians) ;

                % Create Horizontal Unit Vector with Fourth Dimension:
                
                    Local_Horizontal_Unit_Vector_Four_Dimensions = [Local_Horizontal_Unit_Vector; 0];

                % Create the Vectors:
                
                    Local_Vertical_Point_One = (Local_Horizontal_Unit_Vector_Four_Dimensions' * Normal_Direction_One);
                    Local_Vertical_Point_Two = (Local_Horizontal_Unit_Vector_Four_Dimensions' * Normal_Direction_Two);

                % Determine the Angle Between the Horixontal Unit Vector and the Two Normals:
                
                    Angle_One = atan2d(norm(cross(Local_Vertical_Point_One(1:3)', Local_Point_for_Normal_Unit_Vector)), dot(Local_Vertical_Point_One(1:3)', Local_Point_for_Normal_Unit_Vector));
                    Angle_Two = atan2d(norm(cross(Local_Vertical_Point_Two(1:3)' ,Local_Point_for_Normal_Unit_Vector)), dot(Local_Vertical_Point_Two(1:3)', Local_Point_for_Normal_Unit_Vector));

                % Use the Normal with the Smaller Angle:
                
                    if Angle_One < Angle_Two

                        Angle_Value = Angle_One;
                        Local_Vertical_Unit_Vector = Local_Vertical_Point_One(1:3)';

                    else

                        Angle_Value = Angle_Two;
                        Local_Vertical_Unit_Vector = Local_Vertical_Point_Two(1:3)';

                    end
                    
                    % Plot to Validate Results:
                    
%                       figure(2);
%                     
%                           hold on;
%                         
%                               plot3(Temporary_Face_Points(1, :), Temporary_Face_Points(2, :), Temporary_Face_Points(3, :), 'ro');
%                               quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Local_Horizontal_Unit_Vector(1), Local_Horizontal_Unit_Vector(2), Local_Horizontal_Unit_Vector(3));
%                               quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Local_Point_for_Normal_Unit_Vector(1), Local_Point_for_Normal_Unit_Vector(2), Local_Point_for_Normal_Unit_Vector(3));
%                               quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Triangle_Normal(1), Triangle_Normal(2), Triangle_Normal(3));
%                               quiver3(Local_Origin_Point(1), Local_Origin_Point(2), Local_Origin_Point(3), Local_Vertical_Unit_Vector(1), Local_Vertical_Unit_Vector(2), Local_Vertical_Unit_Vector(3));
%
%                           hold off;

            % Project Points into "Local" Plane:

                Vertical_Magnitude = Local_Point_for_Normal_Magnitude * cosd(atan2d(norm(cross(Local_Vertical_Unit_Vector, Local_Point_for_Normal_Unit_Vector)), dot(Local_Vertical_Unit_Vector, Local_Point_for_Normal_Unit_Vector)));
                Horizontal_Magnitude = Local_Point_for_Normal_Magnitude * cosd(atan2d(norm(cross(Local_Horizontal_Unit_Vector, Local_Point_for_Normal_Unit_Vector)), dot(Local_Horizontal_Unit_Vector, Local_Point_for_Normal_Unit_Vector)));

                Local_Triangle_Origin = [0, 0];
                Local_Triangle_Horizontal = [Local_Horizontal_Magnitude, 0];
                Local_Triangle_Normal_Point = [Horizontal_Magnitude, Vertical_Magnitude];

                Local_Triangle = [Local_Triangle_Origin; Local_Triangle_Horizontal; Local_Triangle_Normal_Point];
                
                    % Plot the Validate Results:
                    
%                         figure(3);
%                         
%                             hold on;
%                             
%                                 plot(Local_Triangle(:, 1), Local_Triangle(:, 2), 'ro');
%                                 
%                             hold off;
                
            % Implement Activation Times:

                Temporary_Activation_Time = Activation_Times(Temporary_Face_Point_Location);
                
                % Create a Grid:
                
                    [Grid_X, Grid_Y] = meshgrid(min(Local_Triangle(:, 1)) : Grid_Resolution : max(Local_Triangle(:, 1)) + 1, min(Local_Triangle(:, 2)) : Grid_Resolution : max(Local_Triangle(:, 2)) +1);
                    
                    Grid_V = griddata(Local_Triangle(:, 1), Local_Triangle(:, 2), Temporary_Activation_Time, Grid_X, Grid_Y, 'cubic');

                        % Plot to Validate Results:
                        
%                             figure(4);
%                             
%                                 hold on;
%                                 
%                                     mesh(Grid_X, Grid_Y, Grid_V);
%                                     
%                                 hold off;

                    [Gradient_X, Gradient_Y] = gradient(Grid_V);
                        
                        % Plot to Validate Results:
                        
%                             figure(5);
%                             
%                                 hold on;
%                                 
%                                     contour(Grid_X, Grid_Y, Grid_V, 'Linewidth', 3);
%                                     quiver(Grid_X, Grid_Y, Gradient_X, Gradient_Y, 0.2);
%                                     
%                                 hold off;

            % Determine Which Grid Points Are Inside the Triangle:
                
                Vector_Anchor_Logic_One = isfinite(Gradient_X);
                Vector_Anchor_Logic_Two = isfinite(Gradient_Y);
                
                Vector_Anchor_Logic = Vector_Anchor_Logic_One + Vector_Anchor_Logic_Two;
                
                Logic_Counter = 1;
                
                for Second_Index = 1:size(Vector_Anchor_Logic, 1)
                    
                    for Third_Index = 1:size(Vector_Anchor_Logic, 2)
                        
                        if Vector_Anchor_Logic(Second_Index, Third_Index) == 2

                            L_Anchor_Points(Logic_Counter, 1) = Grid_X(Second_Index, Third_Index);
                            L_Anchor_Points(Logic_Counter, 2) = Grid_Y(Second_Index, Third_Index);
                            
                            L_Head_Points(Logic_Counter, 1) = Grid_X(Second_Index, Third_Index) + Gradient_X(Second_Index, Third_Index);
                            L_Head_Points(Logic_Counter, 2) = Grid_Y(Second_Index, Third_Index) + Gradient_Y(Second_Index, Third_Index);
                            
                            Logic_Counter = Logic_Counter + 1;
                            
                        end

                    end
                    
                end
                
            % Create If Statement Incase Not Points are Found in the Triangle:
            
                % See if Variable Exists:
                    
                    Exists_Check = exist('L_Anchor_Points', 'var');
            
                    if Exists_Check == 0
                        
                        continue
                        
                    else
                
                        % Apply Barycentric Coordinates:

                            Value_One = Local_Triangle(1, :);
                            Value_Two = Local_Triangle(2, :);
                            Value_Three = Local_Triangle(3, :);

                            Activation_Time_One = Temporary_Activation_Time(1, 1);
                            Activation_Time_Two = Temporary_Activation_Time(1, 2);
                            Activation_Time_Three = Temporary_Activation_Time(1, 3);

                            for Second_Index = 1:size(L_Anchor_Points, 1)

                                Barycentric_Value_One(Second_Index) = (((Value_Two(2) - Value_Three(2)) * (L_Anchor_Points(Second_Index, 1) - Value_Three(1))) + ((Value_Three(1) - Value_Two(1)) * (L_Anchor_Points(Second_Index, 2) - Value_Three(2)))) / (((Value_Two(2) - Value_Three(2)) * (Value_One(1) - Value_Three(1))) + ((Value_Three(1) - Value_Two(1)) * (Value_One(2) - Value_Three(2))));

                                Barycentric_Value_Two(Second_Index) = (((Value_Three(2) - Value_One(2)) * (L_Anchor_Points(Second_Index, 1) - Value_Three(1))) + ((Value_One(1) - Value_Three(1)) * (L_Anchor_Points(Second_Index, 2) - Value_Three(2)))) / (((Value_Two(2) - Value_Three(2)) * (Value_One(1) - Value_Three(1))) + ((Value_Three(1) - Value_Two(1)) * (Value_One(2) - Value_Three(2))));

                                Barycentric_Value_Three(Second_Index) = 1 - Barycentric_Value_One(Second_Index) - Barycentric_Value_Two(Second_Index);

                                Sampled_Activation_Times(Second_Index) = (Activation_Time_One * Barycentric_Value_One(Second_Index)) + (Activation_Time_Two * Barycentric_Value_Two(Second_Index)) + (Activation_Time_Three * Barycentric_Value_Three(Second_Index));

                            end

                        % Project Back Into Original Sock Space:

                            for Second_Index = 1:size(L_Anchor_Points, 1)
                                Temporary_Sock_Space_Anchors(Second_Index, :) = (Local_Horizontal_Unit_Vector * L_Anchor_Points(Second_Index, 1)) + Local_Origin_Point;
                                Sock_Space_Anchors(Second_Index, :) = Temporary_Sock_Space_Anchors(Second_Index, :);
                                Sock_Space_Anchors(Second_Index, :) = Temporary_Sock_Space_Anchors(Second_Index, :) + (Local_Vertical_Unit_Vector * L_Anchor_Points(Second_Index, 2))';

                                Temporary_Sock_Space_Heads(Second_Index, :) = (Local_Horizontal_Unit_Vector * L_Head_Points(Second_Index, 1)) + Local_Origin_Point;
                                Sock_Space_Heads(Second_Index, :) = Temporary_Sock_Space_Heads(Second_Index, :);
                                Sock_Space_Heads(Second_Index, :) = Temporary_Sock_Space_Heads(Second_Index, :) + (Local_Vertical_Unit_Vector * L_Head_Points(Second_Index, 2))';

                            end

                            Sock_Space_Heads = Sock_Space_Heads - Sock_Space_Anchors;

                                % Plot to Validate Results:

        %                             figure(6);
        %                             
        %                                 hold on;
        %                                 
        %                                     plot3(Temporary_Face_Points(1, :), Temporary_Face_Points(2, :), Temporary_Face_Points(3, :), 'ro');
        %                                     plot3(Sock_Space_Anchors(:, 1), Sock_Space_Anchors(:, 2), Sock_Space_Anchors(:, 3), 'ko');
        %                                     quiver3(Sock_Space_Anchors(:, 1), Sock_Space_Anchors(:, 2), Sock_Space_Anchors(:, 3), Sock_Space_Heads(:, 1), Sock_Space_Heads(:, 2), Sock_Space_Heads(:, 3));
        %                                     
        %                                 hold off;

                        % Save Out Results:

                            if First_Index == 1

                                Whole_Sock_Anchors(1 : size(Sock_Space_Anchors, 1), :) = Sock_Space_Anchors;
                                Whole_Sock_Heads(1 : size(Sock_Space_Heads, 1), :) = Sock_Space_Heads;
                                Whole_Sock_Activation_Times(:, 1 : size(Sampled_Activation_Times, 2)) = Sampled_Activation_Times;

                            else

                                Whole_Sock_Anchors((size(Whole_Sock_Anchors, 1) +1) : (size(Whole_Sock_Anchors, 1) + size(Sock_Space_Anchors, 1)), :) = Sock_Space_Anchors;
                                Whole_Sock_Heads((size(Whole_Sock_Heads, 1) + 1) : (size(Whole_Sock_Heads, 1) + size(Sock_Space_Heads, 1)), :) = Sock_Space_Heads;
                                Whole_Sock_Activation_Times(:, (size(Whole_Sock_Activation_Times, 2) + 1) : (size(Whole_Sock_Activation_Times, 2) + size(Sampled_Activation_Times, 2))) = Sampled_Activation_Times;

                            end
                    
                    end
                    
            clearvars -except Whole_Sock_Anchors Whole_Sock_Heads Whole_Sock_Activation_Times First_Index Grid_Resolution Points Faces Activation_Times Geometry
      
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Plot the Results to Validate:

   figure(7);
    
       %hold on;
        
            quiver3(Whole_Sock_Anchors(:, 1), Whole_Sock_Anchors(:, 2), Whole_Sock_Anchors(:, 3), Whole_Sock_Heads(:, 1), Whole_Sock_Heads(:, 2), Whole_Sock_Heads(:, 3), 6);
            
            xlabel('X-Axis');
            ylabel('Y-Axis');
            zlabel('Z-Axis');
            
        %hold off;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add the Origianl Points and Activation Times to the Output:

    Whole_Whole_Sock_Anchors = [Whole_Sock_Anchors; Points'];
    Whole_Whole_Sock_Activation_Times = [Whole_Sock_Activation_Times, Activation_Times];
    
    % Plot the Results to Validate:
    
        figure(8);
        
            hold on;
            
                scatter3(Whole_Whole_Sock_Anchors(:, 1), Whole_Whole_Sock_Anchors(:, 2), Whole_Whole_Sock_Anchors(:, 3), '.k');
                
            hold off;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save Data:

%     save('Activation_Times.mat', 'Whole_Sock_Activation_Times');
%     save('Points.pts', 'Whole_Sock_Anchors', '-ascii');
        