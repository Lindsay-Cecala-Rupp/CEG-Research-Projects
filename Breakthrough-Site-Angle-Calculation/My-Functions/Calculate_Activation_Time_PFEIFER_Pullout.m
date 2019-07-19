function [Activation_Times] = Calculate_Activation_Time_PFEIFER_Pullout(ECG_Signal, Starting_Point, Ending_Point)

      for First_Index = 1:size(ECG_Signal, 1)
            
            signal = ECG_Signal(First_Index, Starting_Point:Ending_Point);

            windowLength = 5;
            degree = 3;

            %%%% make sure win is uneven
            if mod(windowLength,2) == 0, windowLength = windowLength + 1; end

            %%%% return x=1, if len(sig)<win
            if length(signal) < windowLength, x=1; return; end


            %%%% Detection of the minimum derivative using a window of 5 frames and fit a 2nd order polynomial
            cen = ceil(windowLength/2);
            X = zeros(windowLength,(degree+1));
            L = [-(cen-1):(cen-1)]';
            for p=1:(degree+1)
                X(:,p) = L.^((degree+1)-p);
            end

            E = (X'*X)\X';
            %singal = singal';
            signal = [signal signal(end)*ones(1,cen-1)];

            a = filter(E(degree,(windowLength:-1:1)),1,signal);
            dy = a(cen:end);



            [~,mi] = min(dy(cen:end-cen));
            mi = mi(1)+(cen-1);

            % preset values for peak detector

            win2 = 5;
            deg2 = 2;

            cen2 = ceil(win2/2);
            L2 = (-(cen2-1):(cen2-1))';


            X2=zeros(length(L2),length((deg2+1)));
            for p=1:(deg2+1)
                X2(:,p) = L2.^((deg2+1)-p);
            end
            c = (X2'*X2)\X2'*(dy(L2+mi)');


            if abs(c(1)) < 100*eps
                dx = 0;
            else
                dx = -c(2)/(2*c(1));
            end

            dx = median([-0.5 dx 0.5]);

            x = mi+dx-1;

            Activation_Times(First_Index, 1) = x + Starting_Point;
            
            clearvars -except Activation_Times ECG_Signal Starting_Point Ending_Point

      end
      
end