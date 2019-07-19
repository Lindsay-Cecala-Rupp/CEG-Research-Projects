
% Script to Visualize the Time Signals in MATLAB Based on Different Runs - Plotting the Electrograms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load in Time Signal:
    
        % Need Variables:
    
            Run_Number = 36;
            Electrode_Number = 58; 
            Beat_Number_Interest = 1;
        
        % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
        
            if Run_Number > 0 && Run_Number <= 9
                Number_of_Zeros = '000';
            elseif Run_Number > 9 && Run_Number <= 99 
                Number_of_Zeros = '00';
            else
                Number_of_Zeros = '0';
            end
            
        % Grab File:

            Time_Signal_Interest = load(strcat('/Users/lindsayrupp/Documents/CEG Research/Pacing Experiment Data/14-10-27/PFEIFER Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number_Interest),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
                            
    % Plotting the Time Signals as the Output Voltages - Plotting the Electrograms:
    
        Time_Signal_Interest = Time_Signal_Interest.ts.potvals;
        
        % Plot the Signal from the Single Electrode:
        
            figure(1)
            
                hold on;
                
                    plot((Time_Signal_Interest(Electrode_Number, :)), 'LineWidth', 2);

                hold off;
       
