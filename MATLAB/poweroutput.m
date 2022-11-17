clc; clear all; close all;

% Load variables
load("time.mat")
load("spacecraft.mat")
load("sun.mat")

% Calculating norm and unit vectors
SC          = [x_sc y_sc z_sc];
SUN         = [x_sun y_sun z_sun];
SC_SUN      = SUN - SC;
sc          = (vecnorm(SC'))';
sc_vers     = SC./sc;
sun         = (vecnorm(SUN'))';
sun_vers    = SUN./sun;
sc_sun      = (vecnorm(SC_SUN'))';
sc_sun_vers = SC_SUN./sc_sun;

% Allocating the variables
t       = length(time);
alpha   = nan(t,1);
theta   = nan(t,1);
eclipse = zeros(t,1);
h       = nan(t,1);
powerM  = nan(t,1);
powerF  = nan(t,1);
Deltat  = nan(t-1,1);
energyM = nan(t-1,1);
energyF = nan(t-1,1);

seconds_in_day        = 24*60*60;
timeS                 = time*seconds_in_day;
Area                  = 0.09;
Area_sp               = Area*0.80; %[m^2]
S                     = 1371; %[W/m^2]
eta0                  = 0.30;

for k = 1:t

    % Alpha is the angle between the direction of the sun and the zenith
    % direction
    % Theta is the angle between the sun direction and the normal of the
    % solar panels
    alpha(k) = acos(dot(sc_vers(k, :), sc_sun_vers(k,:)));

    % If alpha is less than 90° theta equals to 0
    % otherwise theta is equal to alpha minus 90°
    if alpha(k) <= pi/2
        theta(k) = 0;
    else
        theta(k) = alpha(k)-pi/2;
    end
end

etaM = efficiency(alpha, theta, Area, eta0);
etaF = efficiency(zeros(length(theta)), alpha, Area, eta0);

for k = 1:t
    % Eclipse is 0 if we are in sunlight or 1 if we are in the shadow
    h(k) = norm(cross(SC(k,:), sun_vers(k,:)));
    if h(k) <= 6.371e3 && alpha(k) > pi/2
        eclipse(k) = 1;
        powerM(k)  = 0;
        powerF(k)  = 0;
    else
        powerM(k) = S*etaM(k)*Area_sp*cos(theta(k));
        if alpha(k) < pi/2
            powerF(k) = S*etaF(k)*Area_sp*cos(alpha(k));
        else
            powerF(k) = 0;      % When alpha is higher that 90° the sun direction 
        end                     % is below the solar panels (no power output)
        
    end

    % Calculating the energy
    if k ~= t
        Deltat(k)  = timeS(k+1) - timeS(k);
        energyM(k) = powerM(k) * Deltat(k);
        energyF(k) = powerF(k) * Deltat(k);
    end
end

TenergyM = sum(energyM);
TenergyF = sum(energyF);

% Power per orbit and power ratio
ppoM         = sum(powerM)/16;
ppoF         = sum(powerF)/16;
Tpower_ratio = sum(powerM)/sum(powerF);

% Power outputs and power difference plots
figure(1); plot(timeS(1:1000)-timeS(1), powerM(1:1000), 'k'); hold on;
ylabel("Power [W]"); xlabel("Time from deployment [s]");
title("Power output Moving vs. Fixed configuration");
plot(timeS(1:1000)-timeS(1), powerF(1:1000), 'r--'); 
legend("Moving", "Fixed"); hold off

figure(2); plot(timeS(15:80)-timeS(1), powerM(15:80)-powerF(15:80), "b", "LineWidth", 1); 
xlabel("Time from deployment [s]"); ylabel("Power difference [W]");
title("Power difference between Moving and Fixed configurations");
%text(3350, 12, {'Total power difference', ['per orbit: ', num2str(round(ppoM - ppoF)), ' W']}, 'Color', 'red')

% Display
disp(['The average power per orbit for a moving configuration is ', num2str(round(ppoM)), ' W'])
disp(['The average power per orbit for a fixed configuration is ', num2str(round(ppoF)), ' W'])
disp('')
disp(['The power ratio is ', num2str(Tpower_ratio)])
disp('The power gain obtained using a moving configuration')
disp(['instead of a fixed one is about ', num2str(round((Tpower_ratio-1)*100)), '%'])





