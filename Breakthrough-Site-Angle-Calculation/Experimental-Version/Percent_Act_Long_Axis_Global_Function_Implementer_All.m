
% Script to Determine the Parameters Corresponding to the Angle of the Breakthrough Site:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input "Magic Number" Variables and Data:

    % Load in Relevant Variables:

        Grid_Resolution = 0.2;
        
        Percent_Values = (0:5:50)/100; % Go Through Percentages from 1% to 50%
        Run_Values = 36:44; % Go Through Runs
    
    % Load in Sock:

        Geometry = load('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/Geometry-Files/Registered_Cartesian_Sock.mat');
        %Geometry = load('/Users/rupp/Documents/Experiment-14-10-27/Geometry-Files/14_10_27_Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
        %Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Geometry-Files/Registered_Cartesian_Sock.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
            Points = Geometry.outSock.pts; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            Faces = Geometry.outSock.fac; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
            
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
        
                            Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat'));
                            %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat'));
                            %Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
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

                            Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Third_Index),'-cs.mat'));
                            %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Third_Index),'-cs.mat'));
                            %Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Third_Index),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                                ECG_Signal = Time_Signal.ts.potvals;

                        elseif Third_Index == Number_of_Beats_per_Run

                            Time_Signal = load(strcat('/Users/rupp/Documents/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));
                            %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));
                            %Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                                ECG_Signal = Time_Signal.ts.potvals;

                        end

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
                 
                        % Overall Activation Time:

                            Overall_Activation_Times = Activation_Time - QRS_On_Time; % Want to Find Electrodes with the Earliest/Smallest Activation Times

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Interpolate Around Bad Leads:

                        % Laplacian Interpolation:
                        
                            Bad_Leads = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat');
                            %Bad_Leads = load('/Users/rupp/Documents/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolate/Mapping Matrix Calculation/Network Data/Bad-Lead-Mask/14_10_27_Bad_Leads_Mask.mat');
                                Bad_Leads = Bad_Leads.Bad_Lead_Mask;

%                             Bad_Leads = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Bad_Leads_14_10_27.mat'); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
%                                 Bad_Leads = Bad_Leads.Bad_Leads_14_10_27; % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE VARIABLE IS STORED!!!!!!!!!!
                                    
                            Bad_Lead_Value = find(Bad_Leads == 1);

                            Mapping_Matrix = load('/Users/rupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');
                            %Mapping_Matrix = load('/Users/rupp/Documents/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolate/Mapping Matrix Calculation/Results/14_10_27_Mapping_Matrix.mat');
                            %Mapping_Matrix = load('/Users/lindsayrupp/Documents/CEG-Research/Breakthrough-Site-Angle-Calculation/Experimental-Version/Laplacian-Interpolate/SCIRun-Component/Mapping_Matrix.mat');
                                Mapping_Matrix = Mapping_Matrix.scirunmatrix;

                        % Create Vector Containing Activation Times for Only Good Leads:

                            Zeroed_Activation_Times = Overall_Activation_Times;
                            Zeroed_Activation_Times(Bad_Lead_Value) = 0;

                        % Apply Mapping Matrix Obtained from SCIRun:

                            % Note: Format: Mapping_Matrix (All X Good) * Good Leads (Good X 1) = Interpolated (All X 1).

                                Interpolated_Activation_Times = Mapping_Matrix * Zeroed_Activation_Times;
                                    Interpolated_Activation_Times = Interpolated_Activation_Times';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Up Sample Sock Using Barycentric Coordinates:

                        % Functions: Create Barycentric Coordinates and Determines their Corresponding Activation Time.

                        [Upsampled_Points, Upsampled_Interpolated_Activation_Times] = Barycentricly_Upsample_Sock_Function(Points, Faces, Interpolated_Activation_Times, Grid_Resolution);

% %                         % Plot to Validate Results:
% %                 
% %                             figure(1);
% %                 
% %                                 hold on;
% %                 
% %                                     plot3(Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3), '.k')
% %                 
% %                                     xlabel('X-Axis');
% %                                     ylabel('Y-Axis');
% %                                     zlabel('Z-Axis');
% %                 
% %                                     title('Barycentricly UpSampled Sock');
% %                 
% %                                 hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    for Fourth_Index = 1:size(Percent_Values, 2)
                        
                        Percent_into_QRS_Peak = Percent_Values(1, Fourth_Index);

                    % Script to Determine Coordinates in the Breakthrough Site:

                        % Functions: Determine Which Electrodes Have a Activation Time Less than the Set QRS Time.

                        [Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location] = Percent_Act_Breakthrough_Site_Electrode_Determination_Function(Upsampled_Points, Upsampled_Interpolated_Activation_Times, Percent_into_QRS_Peak);

                        if size(Activated_Electrode_X_Location, 1) == 0

                            Ellipse_Information.Area.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;
                            Ellipse_Information.Axis_Ratio.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;
                            Ellipse_Information.Angle_for_Long_Axis.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;
                            %Ellipse_Information.Angle_for_Short_Axis.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;

                        else

% %                             % Plot to Validate Results:
% %                 
% %                                 figure(2);
% %                 
% %                                     hold on;
% %                 
% %                                         scatter3(Activated_Electrode_X_Location, Activated_Electrode_Y_Location, Activated_Electrode_Z_Location, 'k');
% %                 
% %                                         xlabel('X-Axis');
% %                                         ylabel('Y-Axis');
% %                                         zlabel('Z-Axis');
% %                 
% %                                         title('Original Breakthrough Site Coordinates');
% %                 
% %                                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Script to Determine the Long Axis of the Heart:

                            [Ellipsoid_Center, Ellipsoid_Radii, Ellipsoid_Vectors, Ellipsoid_Equation, Ellipsoid_Error] = Fit_Ellipsoid_to_Points([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)], '');

                            % Determine the Point on the Long Axis Closest to the Centroid of the Breakthrough Site:

                                % Create a Line Along the Vector with 1000 Points Along it:

                                    Long_Axis_Variable = linspace((min(min(Upsampled_Points)) - 50), (max(max(Upsampled_Points)) + 50), 10000);

                                    Long_Axis_Vector_X = Ellipsoid_Center(1) + Long_Axis_Variable * Ellipsoid_Vectors(1, 1);
                                    Long_Axis_Vector_Y = Ellipsoid_Center(2) + Long_Axis_Variable * Ellipsoid_Vectors(2, 1);
                                    Long_Axis_Vector_Z = Ellipsoid_Center(3) + Long_Axis_Variable * Ellipsoid_Vectors(3, 1);

                                    Long_Axis_Components = [Long_Axis_Vector_X; Long_Axis_Vector_Y; Long_Axis_Vector_Z];

                                % Determine the Closest Point to the Breakthrough Cite Centroid:

                                    Breakthrough_Site_Centroid = [mean(Activated_Electrode_X_Location); mean(Activated_Electrode_Y_Location); mean(Activated_Electrode_Z_Location)];

                                    Long_Axis_Closest_Index = dsearchn(Long_Axis_Components', Breakthrough_Site_Centroid');

                                    % For Future Calculations - I Want this Points to be at the Origin:

                                        Centered_Activated_Electrode_X_Location = Activated_Electrode_X_Location - Long_Axis_Vector_X(Long_Axis_Closest_Index);
                                        Centered_Activated_Electrode_Y_Location = Activated_Electrode_Y_Location - Long_Axis_Vector_Y(Long_Axis_Closest_Index);
                                        Centered_Activated_Electrode_Z_Location = Activated_Electrode_Z_Location - Long_Axis_Vector_Z(Long_Axis_Closest_Index);

                                        Centered_Breakthrough_Site_Centroid = Breakthrough_Site_Centroid - Long_Axis_Components(:, Long_Axis_Closest_Index);

% %                             % Plot the Results to Validate:
% % 
% %                                 Minimum_Sock_Value = min([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)]);
% %                                 Maximum_Sock_Value = max([Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3)]);
% % 
% %                                 Number_of_Plotting_Steps = 50;
% %                                 Step_Size = (Maximum_Sock_Value - Minimum_Sock_Value) / Number_of_Plotting_Steps;
% %                                 [Ellipsoid_X, Ellipsoid_Y, Ellipsoid_Z] = meshgrid(linspace(Minimum_Sock_Value(1) - Step_Size(1), Maximum_Sock_Value(1) + Step_Size(1), Number_of_Plotting_Steps), linspace(Minimum_Sock_Value(2) - Step_Size(2), Maximum_Sock_Value(2) + Step_Size(2), Number_of_Plotting_Steps), linspace(Minimum_Sock_Value(3) - Step_Size(3), Maximum_Sock_Value(3) + Step_Size(3), Number_of_Plotting_Steps));
% % 
% %                                 Ellipsoid_Points = Ellipsoid_Equation(1) * Ellipsoid_X .* Ellipsoid_X + Ellipsoid_Equation(2) * Ellipsoid_Y .* Ellipsoid_Y + Ellipsoid_Equation(3) * Ellipsoid_Z .* Ellipsoid_Z + 2 * Ellipsoid_Equation(4) * Ellipsoid_X .* Ellipsoid_Y + 2 * Ellipsoid_Equation(5) * Ellipsoid_X .* Ellipsoid_Z + 2 * Ellipsoid_Equation(6) * Ellipsoid_Y .* Ellipsoid_Z + 2 * Ellipsoid_Equation(7) * Ellipsoid_X + 2 * Ellipsoid_Equation(8) * Ellipsoid_Y + 2 * Ellipsoid_Equation(9) * Ellipsoid_Z;
% % 
% %                                 figure(3);
% % 
% %                                     hold on;
% % 
% %                                         plot3(Upsampled_Points(:, 1), Upsampled_Points(:, 2), Upsampled_Points(:, 3), '.r' );
% % 
% %                                         Patched_Ellipsoid_Points = patch(isosurface(Ellipsoid_X, Ellipsoid_Y, Ellipsoid_Z, Ellipsoid_Points, -Ellipsoid_Equation(10)));
% % 
% %                                             set(Patched_Ellipsoid_Points, 'FaceColor', 'g', 'EdgeColor', 'none' );
% % 
% %                                         quiver3(Ellipsoid_Center(1), Ellipsoid_Center(2), Ellipsoid_Center(3), Ellipsoid_Vectors(1, 1)*100, Ellipsoid_Vectors(2, 1)*100, Ellipsoid_Vectors(3, 1)*100, 'k');
% % 
% %                                         plot3(Long_Axis_Vector_X, Long_Axis_Vector_Y, Long_Axis_Vector_Z, 'b');
% % 
% %                                         scatter3(Long_Axis_Vector_X(Long_Axis_Closest_Index), Long_Axis_Vector_Y(Long_Axis_Closest_Index), Long_Axis_Vector_Z(Long_Axis_Closest_Index), 'ob');
% % 
% %                                         xlabel('X-Axis');
% %                                         ylabel('Y-Axis');
% %                                         zlabel('Z-Axis');
% % 
% %                                         title('Fitted Ellipsoid');
% % 
% %                                         axis vis3d equal;
% %                                         camlight;
% %                                         lighting phong;
% % 
% %                                     hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Script to "Cluster" the Points Together and Remove Second Breakthrough Sites:

                            % Functions: Create Clusters and Chooses Cluster with the Most Points.

                            [Clustered_Centered_Activated_Electrode_X_Location, Clustered_Centered_Activated_Electrode_Y_Location, Clustered_Centered_Activated_Electrode_Z_Location] = Clustering_Function(Centered_Activated_Electrode_X_Location, Centered_Activated_Electrode_Y_Location, Centered_Activated_Electrode_Z_Location);

% %                             % Plot the Results to Validate:
% %             
% %                                 figure(3);
% %             
% %                                     hold on;
% %             
% %                                         scatter3(Clustered_Activated_Electrode_X_Location, Clustered_Activated_Electrode_Y_Location, Clustered_Activated_Electrode_Z_Location, 'k');
% %             
% %                                         xlabel('X-Axis');
% %                                         ylabel('Y-Axis');
% %                                         zlabel('Z-Axis');
% %             
% %                                         title('Clustered Breakthrough Site Coordiantes');
% %             
% %                                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Script to "Fit" A Global Plane to Breakthrough Site:

                            % Functions: Fits a Vector from the Sock Centroid to the Breakthrough Site Centroid and Rotates to the Nearest Axis.

                            [Global_Projected_Points, Implemented_Points] = Global_Plane_Fitting_Function_Long_Axis(Centered_Breakthrough_Site_Centroid, Clustered_Centered_Activated_Electrode_X_Location, Clustered_Centered_Activated_Electrode_Y_Location, Clustered_Centered_Activated_Electrode_Z_Location);

% %                             Plot to Validate Results:
% % 
% %                                 figure(4);
% %             
% %                                     hold on;
% %             
% %                                         scatter(Global_Projected_Points(:, 1), Global_Projected_Points(:, 2), 'k');
% %             
% %                                         If Statements to Determine Axis System:
% %             
% %                                             Horizontal Axis:
% %             
% %                                                 if Implemented_Points(1, 1) == 1
% %             
% %                                                     xlabel('X-Axis');
% %             
% %                                                 elseif Implemented_Points(1, 1) == 2
% %             
% %                                                     xlabel('Y-Axis');
% %             
% %                                                 elseif Implemented_Points(1, 1) == 3
% %             
% %                                                     xlabel('Z-Axis');
% %             
% %                                                 end
% %             
% %                                             Vertical Axis:
% %             
% %                                                 if Implemented_Points(1, 2) == 1
% %             
% %                                                     ylabel('X-Axis');
% %             
% %                                                 elseif Implemented_Points(1, 2) == 2
% %             
% %                                                     ylabel('Y-Axis');
% %             
% %                                                 elseif Implemented_Points(1, 2) == 3
% %             
% %                                                     ylabel('Z-Axis');
% %             
% %                                                 end
% %             
% %                                     hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Script to Fit an Ellipse to the Data Points:

                            % Functions: Fits an Ellipse to the Data Points Using Conics.

                            [Ellipse_Structure, Vertical_Line, Horizontal_Line, Rotated_Ellipse] = Fit_an_Ellipse_Function(Global_Projected_Points);

% %                                 % Plot to Validate the Results:
% % 
% %                                     % If Statement to Check if Structure is Empty:
% % 
% %                                         if size(Ellipse_Structure.a, 1) == 0
% % 
% %                                         else
% % 
% %                                             figure(5)
% %             
% %                                                 hold on;
% %             
% %                                                     scatter(Global_Projected_Points(:, 1), Global_Projected_Points(:, 2), 'k');
% %             
% %                                                     plot(Vertical_Line(1,:),Vertical_Line(2,:),'r');
% %                                                     plot(Horizontal_Line(1,:),Horizontal_Line(2,:),'r');
% %                                                     plot(Rotated_Ellipse(1,:),Rotated_Ellipse(2,:),'r');
% %             
% %                                                 hold off;
% % 
% %                                         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Script to Calculate the Parameters of the Fitted Ellipse:

                            % Functions: Calculate the Area, Axis Ratio, Long Axis Angle and Short Axis Angle.

                            % Check to See if an Ellipse was Fitted in Order to Decide Whether or Not Parameters can be Calculated:

                                if size(Ellipse_Structure.a, 1) == 0

                                    Ellipse_Information.Area.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;
                                    Ellipse_Information.Axis_Ratio.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;
                                    Ellipse_Information.Angle_for_Long_Axis.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;
                                    %Ellipse_Information.Angle_for_Short_Axis.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = NaN;

                                else

                                    [Temporary_Ellipse_Information] = Calculate_Ellipse_Parameters_Function_V3(Ellipse_Structure, Horizontal_Line, Vertical_Line);
                                
                                        Ellipse_Information.Area.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = Temporary_Ellipse_Information.Area;
                                        Ellipse_Information.Axis_Ratio.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = Temporary_Ellipse_Information.Axis_Ratio;
                                        Ellipse_Information.Angle_for_Long_Axis.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = Temporary_Ellipse_Information.Angle_for_Long_Axis;
                                        %Ellipse_Information.Angle_for_Short_Axis.Percent(Fourth_Index, 1).Run(First_Index, 1).Beat(Third_Index, 1) = Temporary_Ellipse_Information.Angle_for_Short_Axis;
                                    
                                end
                                
                        end
                        
                    end
                    
                end
                
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc