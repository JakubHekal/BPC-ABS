%% BPC-ABS // Cviceni 5 // Detekce QRS a rozmerení EKG
% Autor: Jakub Hekal    

close all; clear; clc

load("MO1_004_03.mat");

fvz = 500; % vzorkovaci frekvence zminena v prezentaci cviceni
x = x'; % transpozice z radku do sloupcu pro jednodussi praci
 
%% Pozice R vln
% popsany kod v souboru "detektor_R.m"

[b, a] = fir1(fvz + 1, [5 30] / (fvz/2), "bandpass");
y = filtfilt(b, a, x);

[b, a] = fir1(fvz + 1, 3 / (fvz/2), "low");
e = filtfilt(b, a, y .^ 2);

[~, r_waves(:,1)] = findpeaks(e(:,1), "MinPeakHeight", mean(e(:,1)));
[~, r_waves(:,2)] = findpeaks(e(:,2), "MinPeakHeight", mean(e(:,2)));
[~, r_waves(:,3)] = findpeaks(e(:,3), "MinPeakHeight", mean(e(:,3)));

%% Filtrace
% PP s frekvencemi 2 - 5 Hz (oblast EKG kde se nejvice projevuje P a T vlny)
 
% filtrace PP
[b, a] = fir1(fvz + 1, [2 5] / (fvz/2), "bandpass");
y = filtfilt(b, a, x);

% energie signalu
e = y .^ 2;

%% Detekce P a T vln v jednotlivych svodech 
for signal_idx = 1:3 % prochazeni vsemi svody
    signal = e(:, signal_idx); % oddeleni energie jednoho svodu
    
    p_waves = [];
    t_waves = [];
    
    for i = 1:length(r_waves(:, signal_idx)) % prochazeni vsech R vln ve svodu
        pos = r_waves(i, signal_idx); % pozice R vlny v signalu
        s = signal(pos-100:pos+150); % vyrez energie v okoli R vlny
        [~, l] = findpeaks(s); % detekce piku v vyrezu
        l = l + (pos-100); % odsazeni pozice aby odpovidali signalu
        p_waves = [p_waves; l(1)];
        t_waves = [t_waves; l(end)];
    end

    % zobrazeni vln v puvodnim signalu
    figure
    subplot 211; plot(e(:,signal_idx)); title("Energie signalu v " + signal_idx + ".svodu po filtraci DP");
    subplot 212; plot(x(:,signal_idx)); title("Pozice P,R a T vln v " + signal_idx + ".svodu");
    xline(r_waves(:,signal_idx), "Color", "red")
    xline(p_waves, "Color", "green")
    xline(t_waves, "Color", "blue")

end