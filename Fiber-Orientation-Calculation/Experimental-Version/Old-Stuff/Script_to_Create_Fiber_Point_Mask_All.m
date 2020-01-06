
% Script to Create Cylinder to Crop DTI-MRI Fiber Field with in SCIRun:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Input Variables and Data:

    % Manually Input Data:
    
        % Stimulation Site:
        
            Coordinates_of_Interest = [60651.6766677865, 46514.6602504612, 59369.3542404863; 61896.3454585364, 46546.3782928587, 60263.0462579774; 63141.0142492862, 46578.0963352562, 61156.7382754684; 64385.683040036, 46609.8143776537, 62050.4302929595; 65630.3518307859, 46641.5324200512, 62944.1223104505; 66875.0206215357, 46673.2504624487, 63837.8143279415; 68119.6894122856, 46704.9685048461, 64731.5063454326; 69364.3582030354, 46736.6865472436, 65625.1983629236; 70609.0269937853, 46768.4045896411, 66518.8903804147];
                Coordinates_of_Interest = Coordinates_of_Interest/1000;
        
        % Time Signals:
                
            Run_Numbers = [36, 37, 38, 39, 40, 41, 42, 43, 44]; 

    % Magic Numbers for Code to Function:
        
        Number_of_Centroid_Points = 5;
        
        Cylinder_Radius = 5;
        
        Division_Value = 0.25;
        
        Barycentric_Grid_Resolution = 0.2;
        Angle_Grid_Resolution = 0.1;
        
        PHI_Range = 0.25;
        Z_Range = 0.05;
        RHO_Range = 0.05;

    % Data:
    
        % Cartesian CARP Model:
        
            Points = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.pts.txt');
            % Points = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.pts.txt');
                Points = Points/1000; % Scale Factor for CARP Node Locations of Ventricles

            Elements = readmatrix('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/model/Text-File-Version-biv/14-10-27_Carp_mesh.biv.elem.txt');
            % Elements = readmatrix('/Users/rupp/Documents/Experiment-14-10-27/Simulation-Data/Simulation-Model-Information/model/Adjusted-Files-for-Me/14-10-27_Carp_mesh.biv.elem.txt');
                Elements = Elements + 1; % To Make One Based Nodes that Make up "Face"
                
        % UVC CARP Model:
                
            UVC_RHO = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_RHO.pts');
                UVC_RHO = UVC_RHO(2:end, 1); % Ignore First Element
                
            UVC_PHI = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_PHI.pts');
                UVC_PHI = UVC_PHI(2:end, 1); % Ignore First Element
                
            UVC_V = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_V.pts');
                UVC_V = UVC_V(2:end, 1); % Ignore First Element
                
            UVC_Z = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/14-10-27-CARP-Model/UVC/COORDS_Z.pts');
                UVC_Z = UVC_Z(2:end, 1); % Ignore First Element
                
            % Combine the Coordinates:
            
                UVC_Coordinates = [UVC_Z, UVC_RHO, UVC_PHI, UVC_V];
                
        % Experimental Sock:

            Geometry = load('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Simulated-Data/Geometry-Files/14-10-27_Carp_sock_Snapped.mat');
                Sock_Points = Geometry.Sock_US.node;
                Sock_Faces = Geometry.Sock_US.face;
            
        % Laplacian Interpolation Files:
        
            Bad_Leads = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Bad-Lead-Mask/14_10_27_Sock_Bad_Leads_Mask.mat'); 
                Bad_Leads = Bad_Leads.Bad_Lead_Mask; 
                
            Mapping_Matrix = load('/Users/lindsayrupp/Documents/GitHub/CEG-Research-Projects/Breakthrough-Site-Angle-Calculation/Laplacian-Interpolation/Results/14-10-27-Sock-Mapping-Matrix.mat');
                Mapping_Matrix = Mapping_Matrix.scirunmatrix;
                
        % DTI-MRI Fiber Field:
        
            DTI_Fiber_Orientation_Data = load('/Users/lindsayrupp/Downloads/DDTIFieldClipped.mat');
                DTI_Fiber_Points = DTI_Fiber_Orientation_Data.scirunfield.node;
                DTI_Fiber_Vectors = DTI_Fiber_Orientation_Data.scirunfield.field;
                DTI_Fiber_Elements = DTI_Fiber_Orientation_Data.scirunfield.cell;
                
                % Apply Translation Due to Offset:
                
                    DTI_Fiber_Points = DTI_Fiber_Points + [39.677, 40.8222, 47.3222]'; % Find in the Seg3D Text File
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script to Determine the Centroids of the MRI-Mesh:

    DTI_Element_Centroid = zeros(size(DTI_Fiber_Elements, 2), 3);

        for First_Index = 1:size(DTI_Fiber_Elements, 2)

            Temporary_Element_Points = DTI_Fiber_Elements(:, First_Index);

            Temporary_Points = DTI_Fiber_Points(:, Temporary_Element_Points);

            DTI_Element_Centroid(First_Index, 1) = mean(Temporary_Points(1, :));
            DTI_Element_Centroid(First_Index, 2) = mean(Temporary_Points(2, :));
            DTI_Element_Centroid(First_Index, 3) = mean(Temporary_Points(3, :));

        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the Following Information for Each Run Individually:

    for First_Index = 1:size(Run_Numbers, 2)
        
        Run_Number = Run_Numbers(First_Index);
        
        % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
        
            if Run_Number > 0 && Run_Number <= 9

                Number_of_Zeros = '000';

            elseif Run_Number > 9 && Run_Number <= 99 

                Number_of_Zeros = '00';

            else

                Number_of_Zeros = '0';

            end

        Coordinate_of_Interest = Coordinates_of_Interest(First_Index, :);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Determine the Earliest Breakthrough Site Point for All Beats in One Run and Take Average:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Determine How Many Beats are Present for the Given Run:

                % Use Try-Catch to See What Files MATLAB Can/Can't Find:

                    Determine_Number_of_Beats_Matrix = zeros(25,1);

                    for Second_Index = 1:25

                        try

                            Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat'));

                            Determine_Number_of_Beats_Matrix(Second_Index,1) = 1;

                        catch

                            Determine_Number_of_Beats_Matrix(Second_Index,1) = 0;

                        end

                    end

                % Determine Number of Beats per Run:

                    Number_of_Beats_per_Run = sum(Determine_Number_of_Beats_Matrix) + 1; % The Additionally One is for the Beat I Fiducialized in PFEIFER - It has a Different File Format than the Others

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Go Through All of the Beats and Determine the Breakthrough Site Centroid for Each:

                for Second_Index = 1:Number_of_Beats_per_Run

                    % Load in Time Signal Again:

                        if Second_Index < Number_of_Beats_per_Run

                            Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Second_Index),'-cs.mat'));

                                ECG_Signal = Time_Signal.ts.potvals;

                        elseif Second_Index == Number_of_Beats_per_Run

                            Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/PFEIFER-Processed-Data/Run', Number_of_Zeros, num2str(Run_Number), '-cs.mat'));

                                ECG_Signal = Time_Signal.ts.potvals;

                        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Calculate the Activation Times:

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

                            Activation_Time = Calculate_Activation_Time_PFEIFER_Pullout(ECG_Signal, QRS_On_Time, (QRS_Off_Time + 5));

                        % Overall Activation Time:

                            Overall_Activation_Times = Activation_Time - QRS_On_Time;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Laplacian Interpolate Over Bad Leads:

                        Bad_Lead_Value = find(Bad_Leads == 1);

                        % Create Vector Containing Activation Times for Only Good Leads:

                            Zeroed_Activation_Times = Overall_Activation_Times;
                            Zeroed_Activation_Times(Bad_Lead_Value) = 0;

                        % Apply Mapping Matrix Obtained from SCIRun:

                            % Note: Format: Mapping_Matrix (All X Good) * Good Leads (Good X 1) = Interpolated (All X 1).

                                Interpolated_Activation_Times = Mapping_Matrix * Zeroed_Activation_Times;
                                    Interpolated_Activation_Times = Interpolated_Activation_Times';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                     % Script to Up Sample Sock Using Barycentric Coordinates:

                        [Upsampled_Points, Upsampled_Interpolated_Activation_Times] = Barycentricly_Upsample_Sock_Function(Sock_Points, Sock_Faces, Interpolated_Activation_Times, Barycentric_Grid_Resolution);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Determine Point with the Earliest Activation:

                        Breakthrough_Site_Points_of_Interest(Second_Index, :) = Upsampled_Points(find(Upsampled_Interpolated_Activation_Times == min(Upsampled_Interpolated_Activation_Times)), :);

                        clear Upsampled_Points Upsampled_Interpolated_Activation_Times Interpolated_Activation_Times Zeroed_Activation_Times Bad_Lead_Value Overall_Activation_Times Activation_Time QRS_Off_Time QRS_Off_Fiducial QRS_On_Time QRS_On_Fiducial Fiducial_Types Fiducial_Structure ECG_Signal Time_Signal

                end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Calculate the Average of the Breakthrough Site Points:

            Average_Breakthrough_Site_Points_of_Interest = [mean(Breakthrough_Site_Points_of_Interest(:, 1)); mean(Breakthrough_Site_Points_of_Interest(:, 2)); mean(Breakthrough_Site_Points_of_Interest(:, 3))];
            STD_Breakthrough_Site_Points_of_Interest = [std(Breakthrough_Site_Points_of_Interest(:, 1)); std(Breakthrough_Site_Points_of_Interest(:, 2)); std(Breakthrough_Site_Points_of_Interest(:, 3))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Create the Fiber Mask and Pull Desired Indicies:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Calculate the Centroid of Each CARP Element:

                Element_Centroid = zeros(size(Elements, 1), 3);

                    for Second_Index = 1:size(Elements, 1)

                        Temporary_Element_Points = Elements(Second_Index, 2:5);

                        Temporary_Points = Points(Temporary_Element_Points, :);

                        Element_Centroid(Second_Index, 1) = mean(Temporary_Points(:, 1));
                        Element_Centroid(Second_Index, 2) = mean(Temporary_Points(:, 2));
                        Element_Centroid(Second_Index, 3) = mean(Temporary_Points(:, 3));

                    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Find the Designated Number of Centroid Points Near the Point of Interest:

                Stimulation_Site_Index_Values = zeros(Number_of_Centroid_Points, 1);

                Adjusted_Element_Centroid = Element_Centroid;

                for Second_Index = 1:Number_of_Centroid_Points

                    Closest_Position_Index = dsearchn(Adjusted_Element_Centroid, Coordinate_of_Interest);

                    Adjusted_Element_Centroid(Closest_Position_Index, :) = Adjusted_Element_Centroid(Closest_Position_Index, :) * 5000;

                    Stimulation_Site_Index_Values(Second_Index, 1) = Closest_Position_Index;

                end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Take the Average of the Determined Points and Use as Stimulation Site:

                Stimulation_Site(1, 1) = mean(Element_Centroid(Stimulation_Site_Index_Values, 1));
                Stimulation_Site(1, 2) = mean(Element_Centroid(Stimulation_Site_Index_Values, 2));
                Stimulation_Site(1, 3) = mean(Element_Centroid(Stimulation_Site_Index_Values, 3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Rotate the Heart so that the Two Points - Breakthrough Site and Simulationg Site - Correspond to the Z-Axis:

                % Center the Sock around the Stimulation_Site:

                    Centered_Element_Centroid = Element_Centroid - Stimulation_Site;
                    Centered_Average_Breakthrough_Site_Points_of_Interest = Average_Breakthrough_Site_Points_of_Interest' - Stimulation_Site;
                    Centered_DTI_Element_Centroid = DTI_Element_Centroid - Stimulation_Site;

                % Create a Vector to the Two Points:

                    Cylinder_Vector = Centered_Average_Breakthrough_Site_Points_of_Interest';
                    Z_Axis_Vector = [0; 0; 1];

                % Rotate the Vector to be at the Z - Axis:

                    Rotate_to_Z_Axis_Values = vrrotvec(Cylinder_Vector, Z_Axis_Vector);
                    Rotation_Matrix = vrrotvec2mat(Rotate_to_Z_Axis_Values);

                    Rotated_Centered_Element_Centroid = Centered_Element_Centroid * Rotation_Matrix';
                    Rotated_Centered_Heart_Surface_Point = Centered_Average_Breakthrough_Site_Points_of_Interest * Rotation_Matrix';
                    Rotated_Centered_DTI_Fiber_Points = Centered_DTI_Element_Centroid * Rotation_Matrix';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Create Cylinder and Include Desired Points:

                % Cylinder Creation:

                    Cylinder_Height = Rotated_Centered_Heart_Surface_Point(1, 3);

                % Point Inclusion:

                    Region_of_Interest = [(-Cylinder_Radius/2), (Cylinder_Radius/2), (-Cylinder_Radius/2), (Cylinder_Radius/2), 0, Cylinder_Height];

                    Rotated_Centered_Element_Centroid_Point_Cloud = pointCloud(Rotated_Centered_Element_Centroid);
                    Rotated_Centered_DTI_Fiber_Points_Point_Cloud = pointCloud(Rotated_Centered_DTI_Fiber_Points);

                    Cylinder_Indicies_Simulation = findPointsInROI(Rotated_Centered_Element_Centroid_Point_Cloud, Region_of_Interest);
                    Cylinder_Indicies_Experimental = findPointsInROI(Rotated_Centered_DTI_Fiber_Points_Point_Cloud, Region_of_Interest);

                    Element_Points_of_Interest_Simulation = Element_Centroid(Cylinder_Indicies_Simulation, :);
                    Element_Points_of_Interest_Experimental = DTI_Element_Centroid(Cylinder_Indicies_Experimental, :);

% %                 % Plot to Validate the Results:
% % 
% %                     figure(1);
% % 
% %                         hold on;
% % 
% %                             pcshow(Element_Centroid, 'w');
% % 
% %                             pcshow(Element_Points_of_Interest_Simulation, 'r');
% %                             pcshow(Element_Points_of_Interest_Experimental, 'b');
% % 
% %                         hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Calcualte the Fiber Angle for Each of the Determined Vectors:

            Imbrication_Angle = zeros(size(Cylinder_Indicies_Experimental, 1), 1);
            Fiber_Angle = zeros(size(Cylinder_Indicies_Experimental, 1), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Go Through Each Fiber Individually:

                for Second_Index = 1:size(Element_Points_of_Interest_Experimental, 1)

                    Temporary_Index = Cylinder_Indicies_Experimental(Second_Index, 1);

                    Temporary_DTI_Point = Element_Points_of_Interest_Experimental(Second_Index, :);

                    Temporary_DTI_Vector = DTI_Fiber_Vectors(:, Temporary_Index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Find the Closest CARP Mesh Point in Cartesian and UVC to the DTI Fiber Location:

                        Temporary_CARP_Index = dsearchn(Points, Temporary_DTI_Point);

                        Temporary_CARP_Point = Points(Temporary_CARP_Index, :);

                        Temprary_CARP_UVC = UVC_Coordinates(Temporary_CARP_Index, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Create a Plane Corresponding to RHO:

                        % Pull UVC Indicies who Fall within a Set Range of PHI and Z:

                            Desired_Plane_Indicies_Storage_Vector = zeros(size(UVC_Coordinates, 1), 1);

                            for Third_Index = 1:size(UVC_Coordinates, 1)

                                Temporary_RHO = UVC_RHO(Third_Index, 1);
                                Temporary_PHI = UVC_PHI(Third_Index, 1);
                                Temporary_Z = UVC_Z(Third_Index, 1);

                                if (Temporary_RHO < (Temprary_CARP_UVC(2) + RHO_Range)) && (Temporary_RHO > (Temprary_CARP_UVC(2) - RHO_Range))

                                    if (Temporary_PHI < (Temprary_CARP_UVC(3) + PHI_Range)) && (Temporary_PHI > (Temprary_CARP_UVC(3) - PHI_Range))

                                        if (Temporary_Z < (Temprary_CARP_UVC(1) + Z_Range)) && (Temporary_Z > (Temprary_CARP_UVC(1) - Z_Range))

                                            Desired_Plane_Indicies_Storage_Vector(Third_Index, 1) = 1;

                                        end

                                    end

                                end

                            end

                            Desired_Plane_Indicies = find(Desired_Plane_Indicies_Storage_Vector == 1);

                        % Fit a Plane to the Points:

                            Plane_Points_of_Interest = Points(Desired_Plane_Indicies, :);

                            Surface_Fit = fit([Plane_Points_of_Interest(:, 1), Plane_Points_of_Interest(:, 2)], Plane_Points_of_Interest(:, 3), 'poly11', 'normalize', 'on');

                            [Plane_X, Plane_Y] = meshgrid((min(Plane_Points_of_Interest(:, 1))  - 5):Angle_Grid_Resolution:(max(Plane_Points_of_Interest(:, 1)) + 5), (min(Plane_Points_of_Interest(:, 2)) - 5):Angle_Grid_Resolution:(max(Plane_Points_of_Interest(:, 2)) + 5));

                            Plane_Z = Surface_Fit(Plane_X, Plane_Y);

% %                             % Plot to Validate Results:
% %         
% %                                 % Determine Which Points Have the Desired RHO Value for Visualization Purposes:
% %         
% %                                     for Second_Index = 1:size(UVC_RHO, 1)
% %         
% %                                         Temporary_Value = UVC_RHO(Second_Index, 1);
% %         
% %                                         Wanted_Value = Temprary_CARP_UVC(2);
% %         
% %                                         if Temporary_Value > (Wanted_Value - 0.05)
% %         
% %                                             if Temporary_Value < (Wanted_Value + 0.05)
% %         
% %                                                 RHO_Check(Second_Index, 1) = 1;
% %         
% %                                             else
% %         
% %                                                 RHO_Check(Second_Index, 1) = 0;
% %         
% %                                             end
% %         
% %                                         else
% %         
% %                                             RHO_Check(Second_Index, 1) = 0;
% %         
% %                                         end
% %         
% %                                     end
% %         
% %                                     Desired_RHO_Indicies = find(RHO_Check == 1);
% %         
% %                                     Cartesian_RHO_Coordiantes = Points(Desired_RHO_Indicies, :);
% %         
% %                                 % Plot All Necessary Results:
% %         
% %                                     figure(2);
% %         
% %                                         hold on;
% %         
% %                                             surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% %         
% %                                             pcshow(Cartesian_RHO_Coordiantes, 'w');
% %         
% %                                             scatter3(Temporary_CARP_Point(1), Temporary_CARP_Point(2), Temporary_CARP_Point(3), '*b');
% %         
% %                                             pcshow(Element_Centroid(Cylinder_Indicies_Simulation, :), 'g');
% %         
% %                                             zlabel('Z-Axis');
% %                                             ylabel('Y-Axis');
% %                                             xlabel('X-Axis');
% %         
% %                                             legend('Fitted Plane', 'RHO Plane', 'Point of Interest', 'Fiber Box');
% %         
% %                                             title('Tangent Plane Fitted to the RHO Plane of Interest');
% %         
% %                                         hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Determine Information About the Plane in Order to do Necessary Calculations:

                        % DTI Fiber's Location on the Calculated Plane:

                            Fiber_Distance_to_Plane = zeros(size(Plane_X, 1), size(Plane_Z, 2));

                            for Third_Index = 1:size(Plane_Z, 1)

                                for Fourth_Index = 1:size(Plane_Z, 2)

                                    Fiber_Distance_to_Plane(Third_Index, Fourth_Index) = sqrt(((Temporary_DTI_Point(1) - Plane_X(Third_Index, Fourth_Index))^2) + ((Temporary_DTI_Point(2) - Plane_Y(Third_Index, Fourth_Index))^2) + ((Temporary_DTI_Point(3) - Plane_Z(Third_Index, Fourth_Index))^2));

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

                                    % Convert Plane Anchor Point into UVC Coordinates:

                                        Plane_Anchor_Point_UVC_Index = dsearchn(Points, Anchor_Plane_Point);

                                        Plane_Anchor_Point_UVC = UVC_Coordinates(Plane_Anchor_Point_UVC_Index, :);

                                    % Convert Normal Vector Point into UVC Coordinates:

                                        Plane_Normal_Point = Anchor_Plane_Point + Plane_Normal_Unit;

                                        Plane_Normal_Point_UVC_Index = dsearchn(Points, Plane_Normal_Point);

                                        Plane_Normal_Point_UVC = UVC_Coordinates(Plane_Normal_Point_UVC_Index, :);

                                    % Determine which One Has the Larger RHO Value - Larger Value is Closer to the Surface of the Heart:

                                        if Plane_Anchor_Point_UVC(2) > Plane_Normal_Point_UVC(2)

                                            Plane_Normal_Unit = -1 * Plane_Normal_Unit;

                                        elseif Plane_Anchor_Point_UVC(2) < Plane_Normal_Point_UVC(2)

                                            Plane_Normal_Unit = 1 * Plane_Normal_Unit;

                                        end

% %                                     % Plot to Validate the Results:
% %         
% %                                         figure(3);
% %         
% %                                             hold on;
% %         
% %                                                 surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'r');
% %         
% %                                                 scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*g');
% %         
% %                                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_One_Unit(1), Plane_Vector_One_Unit(2), Plane_Vector_One_Unit(3), 'b');
% %         
% %                                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Vector_Two_Unit(1), Plane_Vector_Two_Unit(2), Plane_Vector_Two_Unit(3), 'b');
% %         
% %                                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'b');
% %         
% %                                                 title('Fitted Plane with Desired Components');
% %         
% %                                                 xlabel('X-Axis');
% %                                                 ylabel('Y-Axis');
% %                                                 zlabel('Z-Axis');
% %         
% %                                             hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Script to Determine Fiber Angles:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Imbrication Angle:

                            % Calcualte the Angle Between the Normal and the Fiber Vector:

                                Temporary_Imbrication_Angle = atan2d(norm(cross(Temporary_DTI_Vector, Plane_Normal_Unit)),dot(Temporary_DTI_Vector, Plane_Normal_Unit));

                                % Determine the Correct Orientation for the Angle with Respect to a RHO Plane and Epicardium:

                                    if Temporary_Imbrication_Angle > 90

                                        Imbrication_Angle(Second_Index, 1) = -1 * (90 - Temporary_Imbrication_Angle);

                                    elseif Temporary_Imbrication_Angle < 90

                                        Imbrication_Angle(Second_Index, 1) = 90 - Temporary_Imbrication_Angle;

                                    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % Fiber Angle:

                            % Project Fiber onto the Plane - Remove Imbrication Component:

                                Fiber_Projection_with_Normal = (dot(Temporary_DTI_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                                Projected_Fiber_Vector = Temporary_DTI_Vector' - Fiber_Projection_with_Normal;

                            % Project Z-Unit Vector to Preform Angle Calculation in Plane:

                                Z_Unit_Vector = [0, 0, 1];

                                Z_Projection_with_Normal = (dot(Z_Unit_Vector, Plane_Normal_Unit)/(norm(Plane_Normal_Unit)^2)) * Plane_Normal_Unit;
                                Projected_Z_Unit_Vector = Z_Unit_Vector - Z_Projection_with_Normal;

                            % Calculate a Vector Perpendicular to the Projected Z Unit Vector:

                                Horizontal_Plane_Vector_Option_One = cross(Projected_Z_Unit_Vector, Plane_Normal_Unit);
                                Horizontal_Plane_Vector_Option_Two = -1 * Horizontal_Plane_Vector_Option_One;

                                % Determine Orientation of the Horizontal by Choosing Component with Smaller PHI Value:

                                    Horizontal_Plane_Point_Option_One = Anchor_Plane_Point + Horizontal_Plane_Vector_Option_One;
                                    Horizontal_Plane_Point_Index_Option_One = dsearchn(Points, Horizontal_Plane_Point_Option_One);
                                    Horizontal_Plane_UVC_Point_Option_One = UVC_Coordinates(Horizontal_Plane_Point_Index_Option_One, :);

                                    Horizontal_Plane_Point_Option_Two = Anchor_Plane_Point + Horizontal_Plane_Vector_Option_Two;
                                    Horizontal_Plane_Point_Index_Option_Two = dsearchn(Points, Horizontal_Plane_Point_Option_Two);
                                    Horizontal_Plane_UVC_Point_Option_Two = UVC_Coordinates(Horizontal_Plane_Point_Index_Option_Two, :);

                                    if Horizontal_Plane_UVC_Point_Option_One(3) < Horizontal_Plane_UVC_Point_Option_Two(3)

                                        Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_One;

                                    elseif Horizontal_Plane_UVC_Point_Option_One(3) > Horizontal_Plane_UVC_Point_Option_Two(3)

                                        Horizontal_Plane_Vector = Horizontal_Plane_Vector_Option_Two;

                                    end

                            % Determine which Quadrant the Vector is in with Respect to the Two Defined Z and X Vectors and Calculate the Angle:

                                Z_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Projected_Z_Unit_Vector)),dot(Projected_Fiber_Vector, Projected_Z_Unit_Vector)));
                                X_Positive_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, Horizontal_Plane_Vector)),dot(Projected_Fiber_Vector, Horizontal_Plane_Vector)));
                                X_Negative_Vector_Angle_Value = abs(atan2d(norm(cross(Projected_Fiber_Vector, (-1*Horizontal_Plane_Vector))),dot(Projected_Fiber_Vector, (-1 * Horizontal_Plane_Vector))));

                                if (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value < 90)

                                    Quadrant_Location = 1;

                                    Fiber_Angle(Second_Index, 1) = X_Positive_Vector_Angle_Value;

                                elseif (Z_Vector_Angle_Value < 90) && (X_Positive_Vector_Angle_Value > 90)

                                    Quadrant_Location = 2;

                                    Fiber_Angle(Second_Index, 1) = -1 * X_Negative_Vector_Angle_Value;

                                elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value < 90)

                                    Quadrant_Location = 3;

                                    Fiber_Angle(Second_Index, 1) = -1 * X_Positive_Vector_Angle_Value;

                                elseif (Z_Vector_Angle_Value > 90) && (X_Positive_Vector_Angle_Value > 90)

                                    Quadrant_Location = 4;

                                    Fiber_Angle(Second_Index, 1) = X_Negative_Vector_Angle_Value;

                                end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %                     % Plot to Validate the Results:
% %         
% %                         figure(4);
% %         
% %                             hold on;
% %         
% %                                 surf(Plane_X, Plane_Y, Plane_Z, 'EdgeColor', 'none', 'FaceColor', 'y');
% %         
% %                                 scatter3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), '*b');
% %         
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Temporary_DTI_Vector(1), Temporary_DTI_Vector(2), Temporary_DTI_Vector(3), 'r');
% %         
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Fiber_Vector(1), Projected_Fiber_Vector(2), Projected_Fiber_Vector(3), 'b');
% %         
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Projected_Z_Unit_Vector(1), Projected_Z_Unit_Vector(2), Projected_Z_Unit_Vector(3), 'g');
% %         
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Plane_Normal_Unit(1), Plane_Normal_Unit(2), Plane_Normal_Unit(3), 'm');
% %         
% %                                 quiver3(Anchor_Plane_Point(1), Anchor_Plane_Point(2), Anchor_Plane_Point(3), Horizontal_Plane_Vector(1), Horizontal_Plane_Vector(2), Horizontal_Plane_Vector(3), 'c');
% %         
% %                                 legend('Fitted Plane', 'Point of Interest', 'Original Fiber Vector', 'Projected Fiber Vector', 'Projected Unit Z', 'Plane Normal', 'Projected Horizontal');
% %         
% %                                 xlabel('X-Axis');
% %                                 ylabel('Y-Axis');
% %                                 zlabel('Z-Axis');
% %         
% %                             hold off;

                end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Calcualte the Average Fiber Angle:

            [Mean_Fiber_Angle, STD_Fiber_Angle] = Calculate_Average_of_Fiber_Angles_Function(Fiber_Angle, Element_Points_of_Interest_Experimental, Stimulation_Site, Average_Breakthrough_Site_Points_of_Interest', Division_Value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Script to Save Out the Results:
        
            Compiled_Mean_Fiber_Angle(First_Index, 1) = Mean_Fiber_Angle;
            Compiled_STD_Fiber_Angle(First_Index, 1) = STD_Fiber_Angle;
            
            % Create Additional Variable to be Saved for Visualization in SCIRun:
            
                Fiber_Section.node = Element_Points_of_Interest_Experimental;
                Fiber_Section.field = DTI_Fiber_Vectors(:, Cylinder_Indicies_Experimental);
        
            % File Names:
        
                File_Name_One = sprintf('Element_Points_Run%d.pts', Run_Number);
                File_Name_Two = sprintf('Fiber_Angles_Run%d.mat', Run_Number);
                File_Name_Three = sprintf('Imbrication_Angles_Run%d.mat', Run_Number);
                File_Name_Four = sprintf('Fiber_Section_Run%d.mat', Run_Number);
                
            % Save:
            
                save(File_Name_One, 'Element_Points_of_Interest_Experimental', '-ascii');
                save(File_Name_Two, 'Fiber_Angle');
                save(File_Name_Three, 'Imbrication_Angle');
                save(File_Name_Four, 'Fiber_Section');
                
        % Clear Variables:
        
            clearvars -except Coordinates_of_Interest Run_Numbers Number_of_Centroid_Points Cylinder_Radius Division_Value Barycentric_Grid_Resolution Angle_Grid_Resolution PHI_Range Z_Range RHO_Range Points Elements UVC_RHO UVC_PHI UVC_Z UVC_V UVC_Coordinates Sock_Points Sock_Faces Bad_Leads Mapping_Matrix DTI_Fiber_Points DTI_Fiber_Vectors DTI_Fiber_Elements DTI_Element_Centroid First_Index Compiled_Mean_Fiber_Angle Compiled_STD_Fiber_Angle

    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save Out Final Results:

    save('Mean_Fiber_Angle.mat', 'Compiled_Mean_Fiber_Angle');
    save('STD_Fiber_Angle.mat', 'Compiled_STD_Fiber_Angle');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 