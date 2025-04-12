%% BPC-ABS // Cviceni 8 // Analyza dat z IMU senzoru II 
% Autor: Jakub Hekal    

close all; clear; clc

%% Nacteni dat
fvz = 60; % vzorkovaci frekvence (napsana v souboru s daty)
data = readtable("K_leva.csv"); % nacteni dat - promena "data" je typu table

start = 200; % pocatecni orez na zacatek aktivity

% data z akcelerometru (zrychleni)
x = data.FreeAcc_X(start:end); 
y = data.FreeAcc_Y(start:end);
z = data.FreeAcc_Z(start:end) - 9.81;

% data z gyroskopu (natoceni)
qw = data.Quat_W(start:end); 
qx = data.Quat_X(start:end); 
qy = data.Quat_Y(start:end); 
qz = data.Quat_Z(start:end); 
q = quaternion(qw, qx, qy, qz);

%% Vypocty natoceni
% prepocet na z quaternionu na jednotlive uhly
% vzorce jsou v prezentaci cviceni 
yaw = atan2(2*(qw.*qz + qx.*qy), 1 - 2*(qy.^2 + qz.^2)); 
pitch = asin(2*(qw.*qy - qx.*qz));
roll = atan2(2*(qw.*qx + qy.*qz), 1 - 2*(qx.^2 + qy.^2));


%% Zobrazeni vysledku
figure 
subplot 311; 
hold on
plot(rad2deg(yaw)); % uhly jsou prepoctene z radianu na stupne
plot(z);
hold off
title("Osa Z - yaw")
subplot 312; 
hold on
plot(rad2deg(pitch));
plot(y);
hold off
title("Osa Y - pitch")
subplot 313; 
hold on
plot(rad2deg(roll));
plot(x);
hold off
title("Osa X - roll");