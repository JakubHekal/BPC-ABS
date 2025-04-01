%% BPC-ABS // Cviceni 5 // Detekce QRS a rozmerení EKG
% Autor: Jakub Hekal 

close all; clear; clc

load("MO1_004_03.mat");

fvz = 500; % vzorkovaci frekvence zminena v prezentaci cviceni
x = x'; % transpozice z radku do sloupcu pro jednodussi praci

%% Zobrazeni puvodnich signalu

figure
subplot 311; plot(x(:, 1)); title("Puvodni signal v 1.svodu");
subplot 312; plot(x(:, 2)); title("Puvodni signal v 2.svodu");
subplot 313; plot(x(:, 3)); title("Puvodni signal v 3.svodu");

%% Filtrace a zobrazeni filtrovaneho signalu
% podle doporuceni ze cvik je pouzit kaskada filtru:
% PP s frekvencemi 5 - 30 Hz (oblast EKG kde se nejvice projevuje QRS komplex)
% DP s frekvenci 3 Hz (empiricky zjistena hodnota pro co nejlepsi oddeleni R vlny) 

% filtrace PP
[b, a] = fir1(fvz + 1, [5 30] / (fvz/2), "bandpass");
y_pp = filtfilt(b, a, x);

% zobrazeni po filtraci PP
figure
subplot 311; plot(y_pp(:,1)); title("Signal v 1.svodu po filtraci PP");
subplot 312; plot(y_pp(:,2)); title("Signal v 2.svodu po filtraci PP");
subplot 313; plot(y_pp(:,3)); title("Signal v 3.svodu po filtraci PP");

% energie signalu
e_pp = y_pp .^ 2;

% filtrace enrgie DP
[b, a] = fir1(fvz + 1, 3 / (fvz/2), "low");
e_dp = filtfilt(b, a, e_pp);

% zobrazeni energie signalu po filtraci DP
figure
subplot 311; plot(e_dp(:,1)); title("Energie signalu v 1.svodu po filtraci DP");
subplot 312; plot(e_dp(:,1)); title("Energie signalu v 2.svodu po filtraci DP");
subplot 313; plot(e_dp(:,3)); title("Energie signalu v 3.svodu po filtraci DP");

%% Detekce pozice R vln

% hledani piku - pouze ty ktere maji hodnotu vyssi nez prumer
[~, r_waves_1] = findpeaks(e_dp(:,1), "MinPeakHeight", mean(e_dp(:,1)));
[~, r_waves_2] = findpeaks(e_dp(:,2), "MinPeakHeight", mean(e_dp(:,2)));
[~, r_waves_3] = findpeaks(e_dp(:,3), "MinPeakHeight", mean(e_dp(:,3)));

% vyhodnoceni kvality detekce pro 1.svod
load("poziceQRSvCSEv2.mat");
mat1 = cell2mat(poziceQRSvCSEv2(4));
[TP, FP, FN] = SeP(r_waves_1, mat1, 10); % funkce SeP se nachazi v materialech pro cviceni

% zobrazeni vln v puvodnim signalu
figure
subplot 311; plot(x(:, 1), "MarkerIndices", r_waves_1, "Marker", "v", "MarkerFaceColor", "red", "MarkerEdgeColor", "red"); title("Pozice R vln v 1.svodu", "TP: " + TP + ", FP: " + FP + ", FN: " + FN);
subplot 312; plot(x(:, 2), "MarkerIndices", r_waves_2, "Marker", "v", "MarkerFaceColor", "red", "MarkerEdgeColor", "red"); title("Pozice R vln v 2.svodu");
subplot 313; plot(x(:, 3), "MarkerIndices", r_waves_3, "Marker", "v", "MarkerFaceColor", "red", "MarkerEdgeColor", "red"); title("Pozice R vln v 3.svodu");
