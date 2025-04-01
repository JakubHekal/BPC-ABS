%% BPC-ABS // Cviceni 6 // Analyza variability srdecniho rytmu
% Autor: Jakub Hekal 

close all; clear; clc

load("QRS.mat");

fvz = 500; % vzorkovaci frekvence zminena v prezentaci cviceni

time = linspace(0, length(QRS)/fvz - 1/fvz, length(QRS)-1); % casova osa

%% Intervalovy tachogram
nn_intervals = diff(QRS); % vzdalenosti NN ve vzorcich

%% Intervalova funkce
nn_intervals = nn_intervals / fvz; % vzdalenosti NN v sekundach

%% Tepova frekvence
heart_rate = 60 ./ nn_intervals; 

figure
subplot 311; stem(nn_intervals); xlabel("N [-]"); ylabel("NN [s]"); title("Intervalovy tachogram")
subplot 312; plot(time, nn_intervals); xlabel("t [s]"); ylabel("NN [s]"); title("Intervalova funkce")
subplot 313; plot(time, heart_rate); xlabel("t [s]"); ylabel("Tepova frekvence [tepu/min]"); title("Tepova frekvence")