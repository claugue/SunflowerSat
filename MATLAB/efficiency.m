function eta = efficiency(ni, theta, Area, eta0)

% Parameters
S        = 1371; % [W/m^2] Solar constant
T0       = 298.15;

% Top panel material: Solar cell-fused silica cover
alphaSt      = 0.805; % Solar absorbivity
epsIRt       = 0.825; % Infrared emissivity
% Bottom panel material: Silverized FEP Teflon
alphaSb      = 0.08;
epsIRb       = 0.66;

% Albedo parameters
roE = 0.3; % annual average value of the albedo coefficient
H   = 4.1e5; % [m]
Re  = 6.371e6; % [m]
kA  = 0.657 + 0.54*Re./(Re + H)-0.196*(Re./(Re + H)).^2;

% Direct Earth thermal radiation
qIR = 237; % [W/m^2]

% View factor for Albedo and Earth Radiation
sin_ro        = Re./(Re + H);
F_panel_earth = (sin_ro^2).*cos(ni); %ni is what we called alpha

% Earth infrared emission
Qir  = epsIRb.*F_panel_earth*Area*qIR;

% Albedo radiation
Qalb = alphaSb*(roE*S)*Area.*F_panel_earth.*kA;

% Sun radiation
Qsun = alphaSt*S*Area.*cos(theta);

% Thermal balance
sigma = 5.67e-8; % [W/(m^2*K^4)]
dif   = 1;
T1    = T0;
while dif > 10e-7
    Qabs = Qsun + Qalb + Qir - eta0*S*Area.*cos(theta);
    Qint = 10; % [W]
    T    = ((Qabs + Qint)/(sigma*(epsIRb + epsIRt)*Area)).^(1/4);
    etaT = 1 - 0.005*(T - T0);
    eta  = etaT.*eta0;
    dif  = T-T1;
    T1 = T;
end