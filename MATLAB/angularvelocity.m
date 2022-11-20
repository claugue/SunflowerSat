clc; clear all; close all;

% Load variables
load("time_orbit.mat")
load("sc_orbit.mat")
load("sun_orbit.mat")

% Calculating norm and unit vectors
SC          = [x_sc_orbit y_sc_orbit z_sc_orbit];
SUN         = [x_sun_orbit y_sun_orbit z_sun_orbit];
SC_SUN      = SUN - SC;
sc          = (vecnorm(SC'))';
sc_vers     = SC./sc;
sun         = (vecnorm(SUN'))';
sun_vers    = SUN./sun;
sc_sun      = (vecnorm(SC_SUN'))';
sc_sun_vers = SC_SUN./sc_sun;

% Allocating variables
seconds_in_day        = 24*60*60;
timeS                 = time_orbit*seconds_in_day;
timeSi                = linspace(timeS(1), timeS(end), 100);
t                     = length(timeSi);
alpha                 = nan(t,1);
Deltat                = nan(t-1,1);
omega                 = nan(t-1,1);
time_eclipse          = nan(2, 1);

% Interpolating vectors
sc_vers     = interp1(timeS, sc_vers, timeSi);
sun_vers    = interp1(timeS, sun_vers, timeSi);
sc_sun_vers = interp1(timeS, sc_sun_vers, timeSi);
SC          = interp1(timeS, SC, timeSi);
timeS       = timeSi;

% Calculating the angle and angular velocity
for k = 1:t
    alpha(k) = acos(dot(sc_vers(k, :), sc_sun_vers(k,:)));
end

for m = 2:t
    Deltat(m)  = timeS(m) - timeS(m-1);
    if alpha(m) > pi/2 && (alpha(m-1) >= pi/2 && alpha(m+1) >= pi/2)
        omega(m-1) = 0;
    else
        omega(m-1)   = abs(alpha(m) - alpha(m-1))/Deltat(m);
    end
end

% Eclipse definition
h = zeros(t-1, 1);
for i = 1:t-1
    h(i) = norm(cross(SC(i,:), sun_vers(i,:)));
    if h(i) <= 6.371e3 && alpha(i) > pi/2
        omega(i) = 0;
        alpha(i) = 0;
    end
end

for j = 1:t
    if j ~= t && alpha(j) ~= 0 && alpha(j+1) == 0
        time_eclipse(1) = timeS(j+1);
    elseif j ~= t && alpha(j) == 0 && alpha(j+1) ~= 0
        time_eclipse(2) = timeS(j);
    end
end

T = 300;
te = timeS(timeS > time_eclipse(1) & timeS < time_eclipse(2));
eclipse_alpha = eclipse_angle(te, T);

% Considering the physical angular limitations
alpha(alpha > pi/2) = pi/2;

% Estimating the mean angular velocity
mean_omega = sum(omega)/length(omega);

% Define angle and angular velocity vectors during daylight only
ALPHA = [alpha(timeS > time_eclipse(2)); alpha(timeS < time_eclipse(1))];
OMEGA = [omega(timeS(2:end) > time_eclipse(2)); omega(timeS(2:end) < time_eclipse(1))];

% Display and plots
disp(['The mean angular velocity is ', num2str(mean_omega), ' rad/s'])

figure(1); plot(timeS(2:end)-timeS(1), omega, 'r', 'LineWidth', 1);
title('Instantaneous Angular Velocity'); xlabel('Time from deployment [s]')
ylabel('\omega [rad/s]')

figure(2); plot(timeS-timeS(1), alpha, 'b', 'LineWidth', 1);
title('Angle between Nadir and Sun direction'); xlabel('Time from deployment [s]')
ylabel('\alpha [rad]');

figure(3); plot(1:length(ALPHA), ALPHA);
figure(4); plot(1:length(OMEGA), OMEGA);

