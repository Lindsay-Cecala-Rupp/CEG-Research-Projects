
% Script to Create an Electrode Mask where One is a Bad Lead and Zero is a Good Leads:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in Relevant Variables:

    % Bad Leads:
    
        Bad_Leads = [245, 165]; 

    % Activation Times:
    
        Run_Number = 36; % NOTE: CHANGE THIS DEPENDING ON WHAT RUN I WANT TO LOOK AT!!!!!!!!!!!
        Beat_Number = 1; % NOTE: CHANGE THIS DEPENDING ON WHAT BEAT I WANT TO LOOK AT!!!!!!!!!!!

        % If/ElseIf/Else Statements to Make Sure that the Right File get Loaded:
            if Run_Number > 0 && Run_Number <= 9
                Number_of_Zeros = '000';
            elseif Run_Number > 9 && Run_Number <= 99 
                Number_of_Zeros = '00';
            else
                Number_of_Zeros = '0';
            end

        % Grab File:
            
            Time_Signal = load(strcat('/usr/sci/cibc/Maprodxn/InSitu/18-04-24/Data/Processed/Run0005-cs.mat'));
        
            %Time_Signal = load(strcat('/Users/rupp/Documents/PFEIFER-Calculations/Experiment-14-10-27/Processed/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number),'-ns.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!
        
            %Time_Signal = load(strcat('/Users/lindsayrupp/Documents/CEG Research/Pacing Experiment Data/14-10-27/PFEIFER Processed Data/Run', Number_of_Zeros, num2str(Run_Number), '-b', num2str(Beat_Number),'-cs.mat')); % NOTE: CHANGE THIS LOCATION DEPENDING ON WHERE FILE IS STORED!!!!!!!!!!

            % Pull Out Povals from Signal:
            
                ECG_Signal = Time_Signal.ts.potvals;
                %ECG_Signal = zeros(310, 1);
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create Mask:

    Bad_Leads_Mask = zeros(1, size(ECG_Signal, 1));
    
    Bad_Leads_Mask(Bad_Leads) = 1;
    
%     save('14_10_27_Bad_Leads_Mask.mat', 'Bad_Leads_Mask')
                
                