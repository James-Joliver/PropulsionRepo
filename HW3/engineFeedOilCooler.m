clc;
clear;
simIn = Simulink.SimulationInput('engineFeedOilCooler_JamesWilkinson');


% Define initialization and data to keep track of
RPM_percent_vec = [10 50 75 100];
SA_vec = [0.5 1 5 10];


%SA = 0.5;
%radPerSec = 100 * 0.01 * 366.52;
%data = sim(simIn);


effectiveness = zeros(4);
fuelFlowRate = zeros(4);
fuelTempDiff = zeros(4);
heatToFuel = zeros(4);
oilResTemp = zeros(4);



% Loop through every itteration
for i = 1:numel(RPM_percent_vec)
    for j = 1:numel(SA_vec)

        % initialize sim
        radPerSec = RPM_percent_vec(i) * 0.01 * 366.52;
        SA = SA_vec(j);
        
        % run sim
        data = sim(simIn);
        
        % record data
        itteration = (i - 1) * 4 + j;
        effectiveness(i, j) = data.effectiveness.Data(end);
        fuelFlowRate(i, j) = data.fuelFlowRate.Data(end);
        fuelTempDiff(i, j) = data.fuelTempDiff.Data(end);
        heatToFuel(i, j) = data.heatToFuel.Data(end);
        oilResTemp(i, j) = data.oilResTemp.Data(end);


    end
end



%%
% PLOTS

figure
surf(effectiveness, fuelFlowRate, fuelTempDiff);
xlabel("effectiveness")
ylabel("FuelFlowRate")
zlabel("FuelTempDiff")
title("Fuel Temperature Rise vs Effectiveness and Fuel Flow Rate");


figure
surf(effectiveness, fuelFlowRate, oilResTemp)
xlabel("effectiveness");
ylabel("FuelFlowRate");
zlabel("OilResTemp");
title("Oil Reservoir Temperature vs Effectiveness and Fuel Flow Rate");