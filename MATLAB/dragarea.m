clc; close all; clear all;

% Load variables
load("time.mat")
load("spacecraft.mat")
load("sun.mat")

% Calculating norm vectors
SC  = [x_sc y_sc z_sc];
SUN = [x_sun y_sun z_sun];
SC_SUN = SUN - SC;
sc = (vecnorm(SC'))';
sun = (vecnorm(SUN'))';
sc_sun = (vecnorm(SC_SUN'))';

% Calculating the angle sun-spacraft-earth
gamma = acos((sc.^2 + sc_sun.^2 - sun.^2)./(2*sc.*sc_sun)); % Carnot theorem

% Solar array angle of inclination
alpha = pi - gamma;

% Mean drag area
DA = 0.02 + 0.09*abs(cos(alpha));
mean_DA = mean(DA);
sun_vers = SUN./sun;
h = zeros(length(DA), 1);
for i = 1:length(DA)
    h(i) = norm(cross(SC(i,:), sun_vers(i,:)));
    if h(i) <= 6.371e3 && alpha(i) > pi/2
        DA(i) = 0.02;
    end
end
mean_DA2 = mean(DA);