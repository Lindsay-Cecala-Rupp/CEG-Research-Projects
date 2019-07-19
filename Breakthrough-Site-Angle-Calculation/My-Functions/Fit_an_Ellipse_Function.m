function [Ellipse_Structure, New_Vertical_Line, New_Horizontal_Line, Rotated_Ellipse] = Fit_an_Ellipse_Function(Global_Projected_Points)

    % Initialize the Points:

        % Error Vector:

            Orientation_Tolerance = 1e-3;

        % Prepare Vectors to that They are in Column Form:

            Horizontal_Coordinates = Global_Projected_Points(:, 1);
                Horizontal_Coordinates = Horizontal_Coordinates(:);

            Vertical_Coordinates = Global_Projected_Points(:, 2);
                Vertical_Coordinates = Vertical_Coordinates(:);

        % Remove Bias of the Ellipse to Make Matrix Inversion More Accurate - Will be Added on Later:

            Average_of_the_Horizontal_Coordinates = mean(Horizontal_Coordinates);
            Average_of_the_Vertical_Coordinates = mean(Vertical_Coordinates);

            Horizontal_Coordinates = Horizontal_Coordinates - Average_of_the_Horizontal_Coordinates;
            Vertical_Coordinates = Vertical_Coordinates - Average_of_the_Vertical_Coordinates;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Apply Conic Equation to Fit an Ellipse:           

        % Estimation for the Conic Equation of the Ellipse:

            Conic_Equation_Stuff_One = [Horizontal_Coordinates .^ 2, Horizontal_Coordinates .* Vertical_Coordinates, Vertical_Coordinates .^2 , Horizontal_Coordinates, Vertical_Coordinates];
            A = sum(Conic_Equation_Stuff_One) / (Conic_Equation_Stuff_One' * Conic_Equation_Stuff_One); 

        % Extract Parameters from the Conic Equation:

            [A, B, C, D, E] = deal(A(1), A(2), A(3), A(4), A(5));

        % Remove the Orientation from the Ellipse:

            if (min(abs(B/A),abs(B/C)) > Orientation_Tolerance)

                Orientation_Radius = 1/2 * atan(B / (C - A));
                Cosine_Phi = cos(Orientation_Radius);
                Sin_Phi = sin(Orientation_Radius);
                [A, B, C, D, E] = deal(A * Cosine_Phi ^ 2 - B * Cosine_Phi * Sin_Phi + C * Sin_Phi ^ 2, 0, A * Sin_Phi ^ 2 + B * Cosine_Phi * Sin_Phi + C * Cosine_Phi ^ 2, D * Cosine_Phi - E * Sin_Phi, D * Sin_Phi + E * Cosine_Phi);
                [Average_of_the_Horizontal_Coordinates, Average_of_the_Vertical_Coordinates] = deal(Cosine_Phi * Average_of_the_Horizontal_Coordinates - Sin_Phi * Average_of_the_Vertical_Coordinates, Sin_Phi * Average_of_the_Horizontal_Coordinates + Cosine_Phi * Average_of_the_Vertical_Coordinates);

            else

                Orientation_Radius = 0;
                Cosine_Phi = cos(Orientation_Radius);
                Sin_Phi = sin(Orientation_Radius);

            end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Pull Out Results: 

         % Check if Conic Equation Represents an Ellipse:

                Test_Ellipse = A * C;
                    switch (1)

                        case (Test_Ellipse > 0),  status = '';
                        case (Test_Ellipse == 0), status = 'Parabola found';  warning( 'fit_ellipse: Did not locate an ellipse - Parabolar' );
                        case (Test_Ellipse < 0),  status = 'Hyperbola found'; warning( 'fit_ellipse: Did not locate an ellipse - Hyperbola' );

                    end

            % If We Found an Ellipse Return it's Data:

                if (Test_Ellipse > 0)

                    % Make Sure Coefficients Are Positive as Required:

                        if (A < 0), [A, C, D, E] = deal(-A, -C, -D, -E); end

                    % Final Ellipse Parameters

                        X0 = Average_of_the_Horizontal_Coordinates - D / 2 / A;
                        Y0 = Average_of_the_Vertical_Coordinates - E / 2 / C;
                        F = 1 + (D ^ 2) / (4 * A) + (E ^ 2) / (4 * C);
                        [A, B] = deal(sqrt(F / A), sqrt(F / C));    
                        Long_Axis = 2 * max(A, B);
                        Short_Axis = 2 * min(A, B);

                    % Rotate the Axes Backwards to Find the Center Point of the Original Tilted Ellipse:

                        Ellipse_Rotation_Matrix = [Cosine_Phi Sin_Phi; -Sin_Phi Cosine_Phi];
                        P_In = Ellipse_Rotation_Matrix * [X0; Y0];
                        X0_In = P_In(1);
                        Y0_In = P_In(2);

                    % Pack Ellipse Into a Structure:

                        Ellipse_Structure = struct('a', A, 'b', B, 'phi', Orientation_Radius, 'X0', X0, 'Y0', Y0, 'X0_in', X0_In, 'Y0_in', Y0_In, 'long_axis', Long_Axis, 'short_axis', Short_Axis, 'status', '');

                else

                    % Report an Empty Structure:

                        Ellipse_Structure = struct('a', [], 'b', [], 'phi', [], 'X0', [], 'Y0', [], 'X0_in', [], 'Y0_in', [], 'long_axis',[], 'short_axis', [], 'status', status);

                end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Script to Calcualte Data to Plot the Resulting in Ellipse if One was Fit:

        % If Statement to Check if Structure is Empty:
        
            if size(Ellipse_Structure.a,1) == 0
                
                New_Vertical_Line = 0;
                New_Horizontal_Line = 0;
                Rotated_Ellipse = 0;

            else

                % Calculate Data to Plot the Ellipse:

                    % Rotation Matrix to Rotate the Axes with Respect to an Angle Phi:

                        Ellipse_Rotation_Matrix = [Cosine_Phi Sin_Phi; -Sin_Phi Cosine_Phi];

                    % The Axes:

                        Verticle_Line = [[X0 X0]; Y0 + B * [-1 1]];
                        Horizontal_Line = [X0 + A * [-1 1]; [Y0 Y0]];
                        New_Vertical_Line = Ellipse_Rotation_Matrix * Verticle_Line;
                        New_Horizontal_Line = Ellipse_Rotation_Matrix * Horizontal_Line;

                    % The Ellipse:

                        Theta_R = linspace(0, 2 * pi, 1000);
                        Ellipse_X_R = X0 + A * cos(Theta_R);
                        Ellipse_Y_R = Y0 + B * sin(Theta_R);
                        Rotated_Ellipse = Ellipse_Rotation_Matrix * [Ellipse_X_R; Ellipse_Y_R];

            end

end