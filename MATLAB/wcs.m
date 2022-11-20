clc; clear all; close all;

E = 33.33; % [min]
T  = 120;
X  = round(E*60) - 2*T;
ti = 5;
ta = 1/3 * T;
tc = 1/3 * T;
t = 1:10:T;
alphai = 0;
alphaf = pi/2;
alpha = nan(length(t), 1);
alphab = nan(length(t), 1);

% Phase 1: constant acceleration
% alpha1 = alpha1i + omega1i*t + 1/2 * acc * t^2
% omega1i = 0
% alpha1i = 0
% alpha1f = 1/2 * acc * ta^2
% ta = 30

% Phase 2: constant velocity 
% alpha2 = alpha2i + omega2i * t
% omega2i = omega1i + acc1 * ta = acc * ta
% alpha2i = alpha1f = 1/2 * acc * ta^2
% alpha2f = alpha2i + omega2i * tc = (1/2 * acc * ta^2) + (acc * ta) * tc
% tc = 60

% Phase 3: constant deceleration
% alpha3 = alpha3i + omega3i*t - 1/2 * acc * t^2
% omega3i = omega2i = acc * ta
% alpha3i = alpha2f = (1/2 * acc * ta^2) + (acc * ta) * tc
% alpha3f = alpha3i + omega3i*ta - 1/2 * acc * ta^2 = ((1/2 * acc * ta^2) +
% (acc * ta) * tc) + (acc * ta) * ta - 1/2 * acc * ta^2 = alphaf = pi/2
% ta = 30

% acc * (1/2*ta^2 + ta*tc + ta^2 - 1/2 *  ta^2) = pi/2;
acc = alphaf / (ta*tc + ta^2);
vel = acc * ta;

% Filling in the alpha function
for i = 1: length(t)
    if t(i) <= t(1) + ta
        alpha(i) = 1/2 * acc * t(i).^2;
        alphata = alpha(i);
    elseif t(i) > t(1)+ta && t(i) <= t(1)+(ta+tc)
        alpha(i) = alphata + vel * (t(i)-ta);
        alphatc = alpha(i);
    else
        alpha(i) = alphatc + vel * (t(i)-(ta+tc)) - 1/2 * acc * (t(i)-(ta+tc)).^2;
    end
end
% reverse movement
alphab = flip(alpha);

% Plot
eclipse_alpha = [alphab; zeros(10, 1); alpha];
eclipse_omega = nan(length(eclipse_alpha)-1, 1);
deltat        = t(2)-t(1);
for m = 2:length(eclipse_alpha)
    eclipse_omega(m-1)   = (eclipse_alpha(m) - eclipse_alpha(m-1))/deltat;
end
figure(1);plot(1:length(eclipse_alpha), eclipse_alpha)
figure(2);plot(1:length(eclipse_omega), eclipse_omega)


