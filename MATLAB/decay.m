clc; close all; clear all;

% Altitude plot and linear fit
load("altitude_0477.mat")
plot(time-time(1), h, 'b');
P = polyfit(time,h,1);
hfit = polyval(P,time);
hold on;
plot(time-time(1),hfit,'r-', 'LineWidth', 2); ylabel('Altitude [km]');
xlabel('Time from deployment [days]')

total_decay = abs(hfit(end) - hfit(1)); % [km] in 40 days
mean_decay = total_decay/((time(end) - time(1))); % [km/day]

% Projected decay to 250km

mission_lifetime = (h(1)-250)/mean_decay;
