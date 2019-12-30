
% Script to Visualize the Time Signals in MATLAB Based on Different Runs - Plotting the Electrograms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load in Time Signal:
    
        % Necessary Variables:
    
            Run_Number = 36;
            Electrode_Number = 106; 
            Beat_Number_One = 2;
            Beat_Number_Two = 3;
        
        % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
        
            if Run_Number > 0 && Run_Number <= 9
                
                Number_of_Zeros = '000';
                
            elseif Run_Number > 9 && Run_Number <= 99 
                
                Number_of_Zeros = '00';
                
            else
                
                Number_of_Zeros = '0';
                
            end
            
        % Grab File:

            Time_Signal_One = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Signals/PFEIFER-Processed-Signals-Option-One/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number_One),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                Time_Signal_One = Time_Signal_One.ts.potvals;
            
            Time_Signal_Two = load(strcat('/Users/lindsayrupp/Documents/CEG-Research/Pacing-Experiment-Data/14-10-27/Experimental-Data/Signals/PFEIFER-Processed-Signals-Option-One/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number_Two),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                Time_Signal_Two = Time_Signal_Two.ts.potvals;
            
    % Plotting the Time Signals as the Output Voltages - Plotting the Electrograms:

        % Plot the Signal from the Single Electrode:
        
            figure(1)
            
                hold on;
                
                    plot((Time_Signal_One(Electrode_Number, :)), 'r', 'LineWidth', 2);
                    
                    plot((Time_Signal_Two(Electrode_Number, :)), 'b', 'LineWidth', 2);

                hold off;
                
            figure(2);
            
                hold on;
                
                    plot(rms(Time_Signal_One), 'r', 'LineWidth', 2);
                    
                    plot(rms(Time_Signal_Two), 'b', 'LineWidth', 2);
                    
                hold off;
       
