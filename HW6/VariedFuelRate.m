% this script will vary fuel flow through the system and see the reaction
clc; clear;

simIn = Simulink.SimulationInput('HW6_JamesWilkinson2');
%warning('off', 'all')
% These values have been grabbed from https://www.engineeringtoolbox.com/standard-atmosphere-d_604.html
Alt = 25000;    % ft
T = 238.65;     % K
P = 0.03765227;   % MPa
AirFlow = 100;  % kg/sec
DesignedPR = 7.5;

HeatRate_vec = 7.5*(10^7):0.5*(10^7):13*(10^7);
FuelFlow = HeatRate_vec * (1/48800000);

OPR = zeros(numel(HeatRate_vec), 1);
Thrust = zeros(numel(HeatRate_vec), 1);
SFC = zeros(numel(HeatRate_vec), 1);


for i = 1:numel(HeatRate_vec)
    
    HeatRate = HeatRate_vec(i);
    fprintf("Running: %f kg/s\n %f Left\n", FuelFlow, numel(HeatRate_vec)-i);
    data = sim(simIn);

    OPR(i) = data.OPR.Data(end);  % Extract OPR from simulation results
    Thrust(i) = data.Thrust.Data(end);  % Extract Thrust from simulation results
    SFC(i) = data.SFC.Data(end);  % Extract SFC from simulation results

end


%%
%%%%%% PLOTS %%%%%%%%%%
figure;
subplot(3, 1, 1);
plot(FuelFlow, OPR);
title("OPR");
xlabel("Fuel Flow (kg/sec)");
ylabel("OPR");
grid on


subplot(3, 1, 2);
plot(FuelFlow, Thrust);
title("Thrust");
xlabel("Fuel Flow (kg/sec)");
ylabel("Thrust (N)");
grid on


subplot(3, 1, 3)
plot(FuelFlow, SFC);
title("SFC");
xlabel("Fuel Flow (kg/sec)")
ylabel("SFC");
grid on

