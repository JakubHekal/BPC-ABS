%% BPC-ABS // Cviceni 7 // Analyza dat z IMU senzoru 
% Autor: Jakub Hekal    

close all; clear; clc

%% Nacteni dat
fvz = 60; % vzorkovaci frekvence (napsana v souboru s daty)
data = readtable("Signal1.csv"); % nacteni dat - promena "data" je typu table

%% Extrakce jednotlivych signalu a jejich zobrazeni
% sloupce s daty z akcelerometru na ose X, Y a Z maji nazev zacinajici
% na "FreeAcc_" (pro tento typ senzoru, koukni se jak vypada promena) 

x = data.FreeAcc_X; 
y = data.FreeAcc_Y;
z = data.FreeAcc_Z - 9.81; % od osy Z je odecteno gravitacni zrychleni

figure 
subplot 311; plot(x); title("Osa akcelerometru X")
subplot 312; plot(y); title("Osa akcelerometru Y")
subplot 313; plot(z); title("Osa akcelerometru Z")

%% Slozeni signalu z os do jednoho
% "start" je index vzorku signalu od kterereho checeme zacit zpracovavat.
% jeho hodnota se da vycist z predchozich grafu (hledame kde zacina
% periodicke opakovani}

start = 219;

signal = sqrt(x.^2 + y.^2 + z.^2) - 9.81; % skladame znovu odecitame gravitacni zrychleni
signal = signal(start:end); % oriznuti podle predem nalezeneho zacatku
n = length(signal); % delka signalu
t = linspace(0, n/fvz - 1/fvz, n); % vytvoreni casove osy

%% Filtrace a zobrazeni filtrovaneho signalu
% frekvence chuze se udava mezi 2 - 3 Hz
% vyzkousej ktera hodnota vede nejhezcimu vystupu

[b, a] = fir1(fvz + 1, 3 / (fvz/2), "low"); % vytvoreni spodni propusti
filtered = filtfilt(b, a, signal); % oboustrana filtrace - redukuje posun 

figure 
hold on % zobrazovani do jednoho grafu
plot(t, signal);
plot(t, filtered);
title("Signal pred a po filtraci");
hold off

%% Detekce jednotlivych kroku
% pouzivame findpeaks bez parametru protoze signal obsahuje jenom uzitecne peaky 

[peaks, locs] = findpeaks(filtered);
step_period = mean(diff(locs)) / fvz; % vypocet periody kroku [sekunda]
step_frequency = 1 / step_period; % vypocet frekvence kroku [kroky za sekundu]

figure
hold on
plot(signal);
xline(locs); % svisle primky zobrazujici pozici kroku
title("Pozice kroku v puvodnim signalu", "1 krok za " + step_period + " s, " + round(step_frequency * 60) + " kroku za minutu");
hold off

%% Vypocet z frekvencniho spektra

spectrum = abs(fftshift(fft(signal))); % ziskani frekvencniho spektra
spectrum = spectrum(n/2:end); % oddeleni kladne poloviny spektra
frequencies = fvz*(0:(n/2))/n; % vytvoreni frekvencni osy

[~, idx] = max(spectrum); % ziskani pozice nejvice zastoupene frekvence
step_frequency = frequencies(idx); % ziskani hodnoty nejvice zastoupene frekvence - odpovida frekvenci kroku
step_period = 1 / step_frequency; % prepocet na periodu kroku

figure
plot(frequencies, spectrum);
xline(step_frequency);
title("Spektrum", "1 krok za " + step_period + " s, " + round(step_frequency * 60) + " kroku za minutu");
xlabel("f [Hz]")


