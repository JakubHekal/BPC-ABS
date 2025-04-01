%% BPC-ABS // Cviceni 5 // Detekce QRS a rozmerení EKG
% Autor: Jakub Hekal 

close all; clear; clc

load("QRS.mat");

fvz = 500; % vzorkovaci frekvence zminena v prezentaci cviceni

nn_intervals = diff(QRS); % vzdalenosti NN ve vzorcich
nn_intervals = nn_intervals / fvz; % vzdalenosti NN v sekundach
slice_positions = [1 226 863 1207 1810 length(nn_intervals)]; % Pozice oddelujici jednotlive typy aktivity

%% Rozdeleni signalu na casti s ruznou aktivitou 
for i = 2:length(slice_positions)
    
    % oddeleni jedne casti signalu
    sliced_nn_intervals = nn_intervals(slice_positions(i-1):slice_positions(i));
    
    %% Tvorba histogramu
    fi = figure(1);
    column_width = 1/128;
    h = histogram(sliced_nn_intervals, "BinWidth", column_width, "BinLimits", [0.4 1.2]);

    y = h.Values; % hodnoty sloupcu
    x = h.BinEdges; % pozice na ose x
    x = x(1:end-1)+(column_width/2); % presun pozic do stredu sloupcu

    %% Hledani trojuhleniku
    [v, maxi] = max(y); % maximalni pik
    starti = find(y(1:maxi) == 0, 1, "last"); % posledni nulova hodnota pred maximem
    endi = find(y(maxi:end) == 0, 1, "first") + maxi-1; % prvni nulova hodnota po maximem

    HRV_index = length(sliced_nn_intervals)/ v;
    TINN = (endi - starti)/fvz;
    close(fi)
    
    % zobrazeni trojuhelnikoveho indexu
    figure(2)
    subplot(3, 2, i-1)
    plot(x,y)
    line([x(starti) x(maxi) x(endi) x(starti)], [0 v 0 0], "Color", "red", "LineWidth", 0.75)
    title("Position: " + (i - 1) + ", HRV: " + HRV_index + ", TINN: " + TINN);
    
    % zobrazeni poincareho map
    figure(3)
    subplot(3, 2, i-1)
    plot(sliced_nn_intervals(1:end-1),sliced_nn_intervals(2:end), "r.")
    title("Position: " + (i - 1) + ", HRV: " + HRV_index + ", TINN: " + TINN);
    xlabel("RR(i) [ms]")
    ylabel("RR(i+1) [ms]")
end