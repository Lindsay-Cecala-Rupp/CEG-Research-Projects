
% Script to Determine the Parameters Corresponding to the Angle of the Assymetrical Maxima:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.2;
        
        Electrode_of_Interest = 91;
        
        Run_Values = 36:44; % Go Through Runs
    
    % Load in Sock:

        % Geometry = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
        Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
            
            Points = Geometry.outSock.pts; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            Faces = Geometry.outSock.fac; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcualte Results for All Runs and Beats:
            
    for First_Index = 1:size(Run_Values, 2) % Go Through All Percentages

        Run_Number = Run_Values(1, First_Index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Determine How Many Beats Are Present for Each Run:

            % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
            
                if Run_Number > 0 && Run_Number <= 9

                    Number_of_Zeros = '000';

                elseif Run_Number > 9 && Run_Number <= 99 

                    Number_of_Zeros = '00';

                else

                    Number_of_Zeros = '0';

                end

            % Use Try-Catch to See What Files MATLAB Can/Can't Find:
            
                Determine_Number_of_Beats_Matrix = zeros(25,1);

                for Second_Index = 1:25

                    try

                        %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat'));
                        Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                        
                        Determine_Number_of_Beats_Matrix(Second_Index,1) = 1;

                    catch

                        Determine_Number_of_Beats_Matrix(Second_Index,1) = 0;

                    end

                end

            % Determine Number of Beats per Run:
            
                Number_of_Beats_per_Run = sum(Determine_Number_of_Beats_Matrix) + 1; % The Additionally One is for the Beat I Fiducialized in PFEIFER - It has a Different File Format than the Others

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            for Third_Index = 1:Number_of_Beats_per_Run

                % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:

                    if Run_Number > 0 && Run_Number <= 9

                        Number_of_Zeros = '000';

                    elseif Run_Number > 9 && Run_Number <= 99 

                        Number_of_Zeros = '00';

                    else

                        Number_of_Zeros = '0';

                    end

                % Load in Time Signal Again:
                
                    if Third_Index < Number_of_Beats_per_Run

                        %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Third_Index),'-cs.mat'));
                        Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Third_Index),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                            ECG_Signal = Time_Signal.ts.potvals;

                    elseif Third_Index == Number_of_Beats_per_Run

                        %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));
                        Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                            ECG_Signal = Time_Signal.ts.potvals;

                    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Script to Determine what Time Point I want to look at Based off of the Activation Time of the Set Electrode:

                    % From File Obtain the Fiducials:

                        Fiducial_Structure = Time_Signal.ts.fids; % Load the Fiducials
                        Fiducial_Types = [Fiducial_Structure.type]; 

                        % QRS On:

                            QRS_On_Fiducial = find(Fiducial_Types == 2); % 2 is QRS on 
                            QRS_On_Time = Fiducial_Structure(QRS_On_Fiducial);
                            QRS_On_Time = getfield(QRS_On_Time, 'value'); % Get QRS On Value

                        % QRS Off:

                            QRS_Off_Fiducial = find(Fiducial_Types == 4); % 4 is QRS off
                            QRS_Off_Time = Fiducial_Structure(QRS_Off_Fiducial);
                            QRS_Off_Time = getfield(QRS_Off_Time, 'value'); % Get QRS Off Values

                        % Implement Function from PEFIER Pull Out:

                            try

                                Activation_Time = Calculate_Activation_Time_PFEIFER_Pullout(ECG_Signal, round(QRS_On_Time), round((QRS_Off_Time + 5)));

                            catch 

                                try

                                    Activation_Time = Calculate_Activation_Time_PFEIFER_Pullout(ECG_Signal, ceil(QRS_On_Time), ceil((QRS_Off_Time + 5)));

                                catch

                                    Activation_Time = Calculate_Activation_Time_PFEIFER_Pullout(ECG_Signal, floor(QRS_On_Time), floor((QRS_Off_Time + 5)));

                                end

                            end

                    % Time Point of Interest:

                        Time_Point = round(Activation_Time(Electrode_of_Interest)) - 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Script to Interpolate Around Bad Leads:

                    % Laplacian Interpolation:

                        % Bad_Leads = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
                            % Bad_Leads = Bad_Leads.Bad_Lead_Mask;

                        Bad_Leads = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
                            Bad_Leads = Bad_Leads.Bad_Lead_Mask;

                        Bad_Lead_Value = find(Bad_Leads == 1);

                       % Mapping_Matrix = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');

                       Mapping_Matrix = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');

                            Mapping_Matrix = Mapping_Matrix.scirunmatrix;

                    % Create Matrix Containing Potentials for Only Good Leads:

                        Zeroed_ECG_Signal = ECG_Signal;
                        Zeroed_ECG_Signal(Bad_Lead_Value, :) = 0;

                    % Apply Mapping Matrix Obtained from SCIRun:

                        % Note: Format: Mapping_Matrix (All X Good) * Good Leads (Good X 1) = Interpolated (All X 1).

                            Interpolated_ECG_Signal = Mapping_Matrix * Zeroed_ECG_Signal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Script to Up Sample Sock Using Barycentric Coordinates:

                    % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.

                    Interpolated_ECG_Signal_of_Interest = Interpolated_ECG_Signal(:, Time_Point);

                    [Upsampled_Points, Upsampled_Interpolated_ECG_Signal_of_Interest] = Barycentricly_Upsample_Sock_Function(Points, Faces, Interpolated_ECG_Signal_of_Interest', Grid_Resolution);

% %                     % Plot to Validate the Results:
% %                     
% %                         figure(1);
% %                         
% %                             hold on;
% %                             
% %                                 pcshow(Upsampled_Points);
% %                                 
% %                                 xlabel('X-Axis');
% %                                 ylabel('Y-Axis');
% %                                 zlabel('Z-Axis');
% %                                 
% %                                 title('Upsampled Sock');
% %                                 
% %                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Script to Determine the Location of the Assymetrical Maxima and Breakthorugh Site:

                    % Asymmetrical Maxima:

                        All_Possible_Asymmetrical_Indicies = find(Upsampled_Interpolated_ECG_Signal_of_Interest > max(Upsampled_Interpolated_ECG_Signal_of_Interest) - 1);
                        All_Possible_Asymmetrical_Points = Upsampled_Points(All_Possible_Asymmetrical_Indicies, :);

% %                             % Plot to Validate the Results:
% %                             
% %                                 figure(2);
% %                                 
% %                                     hold on;
% %                                     
% %                                         pcshow(All_Possible_Asymmetrical_Points);
% %                                         
% %                                         xlabel('X-Axis');
% %                                         ylabel('Y-Axis');
% %                                         zlabel('Z-Axis');
% %                                         
% %                                         title('All Possible Asymmetrical Points');
% %                                         
% %                                     hold off;

                        % Cluster to Get Two Points:

                            Cluster_Indices = kmeans(All_Possible_Asymmetrical_Points, 2);

                            Number_of_Clusters = 2;

                            if Number_of_Clusters ~= 2

                                Asymmetrical_Angle.Run(First_Index).Beat(Third_Index) = NaN;

                            else

                                % Find the Latest Activating Point in Each Respective Cluster:

                                    All_Possible_Asymmetrical_Potentials = Upsampled_Interpolated_ECG_Signal_of_Interest(1, All_Possible_Asymmetrical_Indicies);

                                    % Asymmetrical Maxima One:

                                        Cluster_One_Indicies = find(Cluster_Indices == 1);

                                        if size(Cluster_One_Indicies, 1) <= 1
                            
                                                Asymmetrical_Angle.Run(First_Index).Beat(Third_Index) = NaN;

                                        else

                                            Section_One_of_All_Possible_Asymmetrical_Potentials = All_Possible_Asymmetrical_Potentials(1, Cluster_One_Indicies);
                                            Section_One_of_All_Possible_Asymmetrical_Points = All_Possible_Asymmetrical_Points(Cluster_One_Indicies, :);

                                            % Find the Maximum Point:

                                                Asymmetrical_Maxima_One_Point = [mean(Section_One_of_All_Possible_Asymmetrical_Points)];

                                        % Asymmetrical Maxima Two:

                                            Cluster_Two_Indicies = find(Cluster_Indices == 2);

                                            if size(Cluster_Two_Indicies, 1) <= 1

                                                Asymmetrical_Angle.Run(First_Index).Beat(Third_Index) = NaN;

                                            else

                                                Section_Two_of_All_Possible_Asymmetrical_Potentials = All_Possible_Asymmetrical_Potentials(1, Cluster_Two_Indicies);
                                                Section_Two_of_All_Possible_Asymmetrical_Points = All_Possible_Asymmetrical_Points(Cluster_Two_Indicies, :);

                                                % Find the Maximum Point:

                                                    Asymmetrical_Maxima_Two_Point = [mean(Section_Two_of_All_Possible_Asymmetrical_Points)];

                                                % Breakthrough Site:

                                                    [Minimum_Potential_Value, Minimum_Potential_Location] = min(Upsampled_Interpolated_ECG_Signal_of_Interest);

                                                    Breakthrough_Site_Point = Upsampled_Points(Minimum_Potential_Location, :);

% %                                                 % Plot to Validate the Results:
% %                                                 
% %                                                     figure(3);
% %                                                     
% %                                                         hold on;
% %                                                         
% %                                                             pcshow(Section_Two_of_All_Possible_Asymmetrical_Points, 'b');
% %                                                             pcshow(Section_One_of_All_Possible_Asymmetrical_Points, 'r');
% %                                                         
% %                                                             xlabel('X-Axis');
% %                                                             ylabel('Y-Axis');
% %                                                             zlabel('Z-Axis');
% %                                                         
% %                                                             title('Clustered Maxima');
% %                                                         
% %                                                         hold off;
% %                             
% %                                                 % Plot to Validate the Results:
% %                             
% %                                                     figure(4);
% %                             
% %                                                         hold on;
% %                             
% %                                                             scatter3(Breakthrough_Site_Point(1), Breakthrough_Site_Point(2), Breakthrough_Site_Point(3), 'ok');
% %                                                             scatter3(Asymmetrical_Maxima_One_Point(1), Asymmetrical_Maxima_One_Point(2), Asymmetrical_Maxima_One_Point(3), 'or');
% %                                                             scatter3(Asymmetrical_Maxima_Two_Point(1), Asymmetrical_Maxima_Two_Point(2), Asymmetrical_Maxima_Two_Point(3), 'ob');
% %                             
% %                                                             xlabel('X-Axis');
% %                                                             ylabel('Y-Axis');
% %                                                             zlabel('Z-Axis');
% %                             
% %                                                             legend('Breakthrough Site Point', 'Asymmetrical Maxima One', 'Asymmetrical Maxima Two');
% %                             
% %                                                             title('Asymmetrical Maxima Angle Points');
% %                             
% %                                                         hold off;
% % 
% %                                                     % Plot to Validate the Results:
% % 
% %                                                         figure(10); 
% % 
% %                                                             hold on; 
% % 
% %                                                                 pcshow(Section_Two_of_All_Possible_Asymmetrical_Points, 'b'); 
% %                                                                 pcshow(Section_One_of_All_Possible_Asymmetrical_Points, 'r'); 
% % 
% %                                                                 scatter3(Asymmetrical_Maxima_One_Point(1), Asymmetrical_Maxima_One_Point(2), Asymmetrical_Maxima_One_Point(3), 'ow'); 
% %                                                                 scatter3(Asymmetrical_Maxima_Two_Point(1), Asymmetrical_Maxima_Two_Point(2), Asymmetrical_Maxima_Two_Point(3), 'ow'); 
% %                                                                 scatter3(Breakthrough_Site_Point(1), Breakthrough_Site_Point(2), Breakthrough_Site_Point(3), 'ow');
% % 
% %                                                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                                % Script to Determine the Long Axis of the Heart:

                                                    [Ellipsoid_Center, Ellipsoid_Radii, Ellipsoid_Vectors, Ellipsoid_Equation, Ellipsoid_Error] = Fit_Ellipsoid_to_Points([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)], '');

                                                    % Determine the Point on the Long Axis Closest to the Breakthrough Site Point:

                                                        % Create a Line Along the Vector with 1000 Points Along it:

                                                            Long_Axis_Variable = linspace((min(min(Upsampled_Points)) - 50), (max(max(Upsampled_Points)) + 50), 10000);

                                                            Long_Axis_Vector_X = Ellipsoid_Center(1) + Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
                                                            Long_Axis_Vector_Y = Ellipsoid_Center(2) + Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
                                                            Long_Axis_Vector_Z = Ellipsoid_Center(3) + Long_Axis_Variable * Ellipsoid_Vectors(3, 1);

                                                            Long_Axis_Components = [Long_Axis_Vector_X; Long_Axis_Vector_Y; Long_Axis_Vector_Z];

                                                        % Determine the Closest Point to the Breakthrough Site Point:

                                                            Long_Axis_Closest_Index = dsearchn(Long_Axis_Components', Breakthrough_Site_Point);

                                                            % For Future Calculations - I Want this Points to be at the Origin:

                                                                Centered_Breakthrough_Site_Point = Breakthrough_Site_Point - Long_Axis_Components(:, Long_Axis_Closest_Index)';

                                                                Centered_Asymmetrical_Maxima_One_Point = Asymmetrical_Maxima_One_Point - Long_Axis_Components(:, Long_Axis_Closest_Index)';

                                                                Centered_Asymmetrical_Maxima_Two_Point = Asymmetrical_Maxima_Two_Point - Long_Axis_Components(:, Long_Axis_Closest_Index)';

                                                                Centered_Upsampled_Points = Upsampled_Points - Long_Axis_Components(:, Long_Axis_Closest_Index)';

                                                                Centered_Ellipsoid_Center = Ellipsoid_Center - Long_Axis_Components(:, Long_Axis_Closest_Index);

% %                                                                     % Plot the Results to Validate:
% %                                 
% %                                                                         Minimum_Sock_Value = min([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)]);
% %                                                                         Maximum_Sock_Value = max([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)]);
% %                                 
% %                                                                         Number_of_Plotting_Steps = 50;
% %                                                                         Step_Size = (Maximum_Sock_Value - Minimum_Sock_Value) / Number_of_Plotting_Steps;
% %                                                                         [Ellipsoid_X, Ellipsoid_Y, Ellipsoid_Z] = meshgrid(linspace(Minimum_Sock_Value(1) - Step_Size(1), Maximum_Sock_Value(1) + Step_Size(1), Number_of_Plotting_Steps), linspace(Minimum_Sock_Value(2) - Step_Size(2), Maximum_Sock_Value(2) + Step_Size(2), Number_of_Plotting_Steps), linspace(Minimum_Sock_Value(3) - Step_Size(3), Maximum_Sock_Value(3) + Step_Size(3), Number_of_Plotting_Steps));
% %                                 
% %                                                                         Ellipsoid_Points = Ellipsoid_Equation(1) * Ellipsoid_X .* Ellipsoid_X + Ellipsoid_Equation(2) * Ellipsoid_Y .* Ellipsoid_Y + Ellipsoid_Equation(3) * Ellipsoid_Z .* Ellipsoid_Z + 2 * Ellipsoid_Equation(4) * Ellipsoid_X .* Ellipsoid_Y + 2 * Ellipsoid_Equation(5) * Ellipsoid_X .* Ellipsoid_Z + 2 * Ellipsoid_Equation(6) * Ellipsoid_Y .* Ellipsoid_Z + 2 * Ellipsoid_Equation(7) * Ellipsoid_X + 2 * Ellipsoid_Equation(8) * Ellipsoid_Y + 2 * Ellipsoid_Equation(9) * Ellipsoid_Z;
% %                                 
% %                                                                         figure(5);
% %                                 
% %                                                                             hold on;
% %                                 
% %                                                                                 plot3(Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3), '.r' );
% %                                 
% %                                                                                 Patched_Ellipsoid_Points = patch(isosurface(Ellipsoid_X, Ellipsoid_Y, Ellipsoid_Z, Ellipsoid_Points, -Ellipsoid_Equation(10)));
% %                                 
% %                                                                                     set(Patched_Ellipsoid_Points, 'FaceColor', 'g', 'EdgeColor', 'none' );
% %                                 
% %                                                                                 quiver3(Ellipsoid_Center(1), Ellipsoid_Center(2), Ellipsoid_Center(3), Ellipsoid_Vectors(1, 1)*100, Ellipsoid_Vectors(2, 1)*100, Ellipsoid_Vectors(3, 1)*100, 'k');
% %                                 
% %                                                                                 plot3(Long_Axis_Vector_X, Long_Axis_Vector_Y, Long_Axis_Vector_Z, 'b');
% %                                 
% %                                                                                 scatter3(Long_Axis_Vector_X(Long_Axis_Closest_Index), Long_Axis_Vector_Y(Long_Axis_Closest_Index), Long_Axis_Vector_Z(Long_Axis_Closest_Index), 'ob');
% %                                 
% %                                                                                 xlabel('X-Axis');
% %                                                                                 ylabel('Y-Axis');
% %                                                                                 zlabel('Z-Axis');
% %                                 
% %                                                                                 title('Fitted Ellipsoid');
% %                                 
% %                                                                                 axis vis3d equal;
% %                                                                                 camlight;
% %                                                                                 lighting phong;
% %                                 
% %                                                                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                                % Script to "Fit" A Global Plane to the Breakthrough Site:

                                                    % Determine which Direction the Apex of the Heart is Located Corresponding to the Ellipsoid Vectors:

                                                        Direction_Counter = 1;

                                                        while Direction_Counter < 50

                                                                % Increase Size of the Line Until Reached A Desirable Distance Away from a Point:

                                                                    Direction_Counter_Long_Axis_Variable = linspace((min(min(Centered_Upsampled_Points)) - Direction_Counter), (max(max(Centered_Upsampled_Points)) + Direction_Counter), 100);

                                                                    Direction_Counter_Long_Axis_Vector_X = Centered_Ellipsoid_Center(1) + Direction_Counter_Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
                                                                    Direction_Counter_Long_Axis_Vector_Y = Centered_Ellipsoid_Center(2) + Direction_Counter_Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
                                                                    Direction_Counter_Long_Axis_Vector_Z = Centered_Ellipsoid_Center(3) + Direction_Counter_Long_Axis_Variable * Ellipsoid_Vectors(3, 1);

                                                                    Direction_Counter_Long_Axis_Vector = [Direction_Counter_Long_Axis_Vector_X; Direction_Counter_Long_Axis_Vector_Y; Direction_Counter_Long_Axis_Vector_Z];

                                                                % Determine the Smallest Distance and See if Okay:

                                                                    Direction_Distance = pdist2(Direction_Counter_Long_Axis_Vector', Centered_Upsampled_Points);

                                                                    Minimum_Distance = min(min(Direction_Distance));

                                                                    if Minimum_Distance < 5

                                                                        Direction_Info = 1;

                                                                        Direction_Counter = 100;

                                                                    else

                                                                        Direction_Counter = Direction_Counter + 1;

                                                                    end

                                                        end

                                                        % Evaluate Which Direction it is Facing and Orientate to be Towards the Base of the Heart:

                                                            % Long Axis Vector:

                                                                Exists_Check = exist('Direction_Info');

                                                                if Exists_Check == 1

                                                                    Desired_Vector_One = -1 * [Ellipsoid_Vectors(1, 1), Ellipsoid_Vectors(2, 1), Ellipsoid_Vectors(3, 1)];

                                                                else

                                                                    Desired_Vector_One = [Ellipsoid_Vectors(1, 1), Ellipsoid_Vectors(2, 1), Ellipsoid_Vectors(3, 1)];

                                                                end

                                                            % Breakthrough Site Vector:

                                                                Desired_Vector_Two = [Centered_Breakthrough_Site_Point(1); Centered_Breakthrough_Site_Point(2); Centered_Breakthrough_Site_Point(3)];

                                                            % Original Axis Vectors (X, Y and Z):

                                                                Origin_X_Vector = [1; 0; 0]; 
                                                                Origin_Y_Vector = [0; 1; 0]; 
                                                                Origin_Z_Vector = [0; 0; -1]; 

                                                        % Apply Rotation:

                                                            % Project Long Axis Vector to Z-Axis:

                                                                Rotate_to_Z_Axis_Values = vrrotvec(Desired_Vector_One, Origin_Z_Vector);

                                                                Rotate_to_Z_Axis_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

                                                                Rotated_Once_Centered_Breakthrough_Site_Point = Centered_Breakthrough_Site_Point * Rotate_to_Z_Axis_Matrix';

                                                                Rotated_Once_Centered_Asymmetrical_Maxima_One_Point = Centered_Asymmetrical_Maxima_One_Point * Rotate_to_Z_Axis_Matrix';

                                                                Rotated_Once_Centered_Asymmetrical_Maxima_Two_Point = Centered_Asymmetrical_Maxima_Two_Point * Rotate_to_Z_Axis_Matrix';

                                                                Rotated_Desired_Vector_Two = Desired_Vector_Two' * Rotate_to_Z_Axis_Matrix';

                                                            % Project Breakthrough Site Vector to X-Axis:

                                                                Rotate_to_X_Axis_Values = vrrotvec(Rotated_Desired_Vector_Two, Origin_X_Vector);

                                                                Rotate_to_X_Axis_Matrix = vrrotvec2mat(Rotate_to_X_Axis_Values);

                                                                Rotated_Twice_Centered_Breakthrough_Site_Point = Rotated_Once_Centered_Breakthrough_Site_Point * Rotate_to_X_Axis_Matrix;

                                                                Rotated_Twice_Centered_Asymmetrical_Maxima_One_Point = Rotated_Once_Centered_Asymmetrical_Maxima_One_Point * Rotate_to_X_Axis_Matrix;

                                                                Rotated_Twice_Centered_Asymmetrical_Maxima_Two_Point = Rotated_Once_Centered_Asymmetrical_Maxima_Two_Point * Rotate_to_X_Axis_Matrix;

                                                            % Remove Coordinate that was Not Rotated About:

                                                                Projected_Breakthrough_Site_Point = Rotated_Twice_Centered_Breakthrough_Site_Point(1, 2:3);

                                                                Projected_Asymmetrical_Maxima_One_Point = Rotated_Twice_Centered_Asymmetrical_Maxima_One_Point(1, 2:3);

                                                                Projected_Asymmetrical_Maxima_Two_Point = Rotated_Twice_Centered_Asymmetrical_Maxima_Two_Point(1, 2:3);

% %                                                                 % Plot to Validate the Results:
% % 
% %                                                                     figure(6);
% % 
% %                                                                         hold on;
% % 
% %                                                                             scatter(Projected_Breakthrough_Site_Point(1), Projected_Breakthrough_Site_Point(2), 'ok');
% %                                                                             scatter(Projected_Asymmetrical_Maxima_One_Point(1), Projected_Asymmetrical_Maxima_One_Point(2), 'or');
% %                                                                             scatter(Projected_Asymmetrical_Maxima_Two_Point(1), Projected_Asymmetrical_Maxima_Two_Point(2), 'ob');
% % 
% %                                                                             legend('Breakthrough Site Point', 'Asymmetrical Maxima One', 'Asymmetrical Maxima Two');
% % 
% %                                                                             xlabel('X-Axis');
% %                                                                             ylabel('Y-Axis');
% %                                                                             zlabel('Z-Axis');
% % 
% %                                                                             title('Projected Points');
% % 
% %                                                                         hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                                % Script to Fit a Line to the Points and Calculate the Angle:

                                                    Line_Input_X = [Projected_Breakthrough_Site_Point(1), Projected_Asymmetrical_Maxima_One_Point(1), Projected_Asymmetrical_Maxima_Two_Point(1)];
                                                    Line_Input_Y = [Projected_Breakthrough_Site_Point(2), Projected_Asymmetrical_Maxima_One_Point(2), Projected_Asymmetrical_Maxima_Two_Point(2)];

                                                    Polyfit_Results = polyfit(Line_Input_X, Line_Input_Y, 1);

                                                    Line_Result_Y = polyval(Polyfit_Results, Line_Input_X);

% %                                                     figure(6);
% % 
% %                                                         hold on;
% % 
% %                                                             plot(Line_Input_X, Line_Result_Y, '--k')
% % 
% %                                                         hold off;

                                                    Asymmetrical_Angle.Run(First_Index).Beat(Third_Index) = atand(Polyfit_Results(1));

                                            end
                                            
                                        end
                                        
                            end
                            
                    clearvars -except Asymmetrical_Angle Third_Index Number_of_Beats_per_Run Run_Number Run_Values First_Index Points Faces Grid_Resolution Electrode_of_Interest Run_Values
                      
            end
            
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
