%% BPC-ABS // Cviceni 8 // Analyza dat z IMU senzoru II 
% Autor: Jakub Hekal    

close all; clear; clc

%% Nacteni dat
load("ACC_stairs.mat")
fvz = 100; % vzorkovaci frekvence (napsana v prezentaci cviceni)

%% Extrakce jednotlivych os
% data jsou ulozena v matici o trech radcich

z = ACC_stairs(1,:) - 9.81; % od osy Z je odecteno gravitacni zrychleni
y = ACC_stairs(2,:);
x = ACC_stairs(3,:); 

signal = sqrt(x.^2 + y.^2 + z.^2) - 9.81; % skladame znovu odecitame gravitacni zrychleni

%% Filtrace
% frekvence chuze se udava mezi 2 - 3 Hz
% vyzkousej ktera hodnota vede nejhezcimu vystupu

[b, a] = butter(3,  3 / (fvz/2), "low"); % vytvoreni spodni propusti
filtered = filtfilt(b, a, signal); % oboustrana filtrace - redukuje posun 

%% Detekce piku
% detekce kroku probiha v posuvnem okne aby se dala analyzovat promenlivost v case

half_window = 5 * fvz; % velikost poloviny okna - cele okno = (2 * half_window) + 1
output = [];

% pruchod signalem posuvnym oknem
for i = half_window+1:half_window:length(signal)-half_window
    signal_window = filtered(i-half_window:i+half_window); % vytazeni okna z filtrovaneho signalu
    [~, locs] = findpeaks(signal_window); % detekce piku v okne
   
    pp_intervals = diff(locs) / fvz; % vypocet intervalu mezi piky (kroky)
    step_period = mean(pp_intervals); % prumerna perioda kroku v okne 
    step_frequency = 1 / step_period; % prepocet na frekvenci kroku
    step_per_minute = round(step_frequency * 60); % prepocet na kroky za minutu
    
    output = [output [step_per_minute; length(locs); step_period; min(pp_intervals); max(pp_intervals)]];
end

%% Zobrazeni vysledku
figure
subplot 311
plot(output(1,:)) % kroky za minutu
title("Kadence kroku")
subplot 312
plot(output(2,:)) % pocet kroku v okne
title("Pocet kroku")
subplot 313
errorbar(1:length(output(3,:)), output(3,:), output(4,:), output(5,:))
title("Promenlivost periody kroku")
